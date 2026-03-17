CLASS lhc_yi_booking_eug_m DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Bookingsupp FOR NUMBERING
      IMPORTING entities FOR CREATE yi_booking_eug_m\_Bookingsuppl.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR yi_booking_eug_m RESULT result.
    METHODS validateconnection FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_booking_eug_m~validateconnection.

    METHODS validatecurrencycode FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_booking_eug_m~validatecurrencycode.

    METHODS validatecustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_booking_eug_m~validatecustomer.

    METHODS validateflightprice FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_booking_eug_m~validateflightprice.

    METHODS validatestatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_booking_eug_m~validatestatus.
    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR yi_booking_eug_m~calculatetotalprice.

ENDCLASS.

CLASS lhc_yi_booking_eug_m IMPLEMENTATION.

* behav def의 booking에서  association _Bookingsuppl { create; } 로 generated된 것이어서
* 이곳 booking class에 생성된다.
* 이곳은 booking에서 create by association으로 생성된 early numbering부분으로,
* 기본 parameter인 entities는 table type으로, %cid_ref, travelid, bookingid, %target으로 되어있는데,
* %target은 또 table type으로 %cid, travelid, bookingid,  bookingsupplementid... 로 이루어져 있다.
* 즉, 지금 작업중인 booksuppl의 원래 ref key 2개와, 여러개 작업중인 booksupplid 정보를 가지고 있다.
  METHOD earlynumbering_cba_Bookingsupp.
    DATA:max_booking_suppl_id TYPE /dmo/booking_supplement_id.

    "booking을 현재 associ인 _Bookingsuppl로 읽는다.
    "table type으로 하나의 행은 structure로 각각 항목이 있는데, "source에 키필드 2개, target에 키필드 3개로
*지금 작업중인 suppl의 부모키로 이전에 어떤 값들의 suppl이 있었는지 읽어오는 것으로 이해하면 됨
*단, 자체가 table type이므로 여러 사용자 동시접속으로 부모키도 table로 여러건 있다는 가정하에
    READ ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
    ENTITY yi_booking_eug_m BY \_Bookingsuppl
    FROM CORRESPONDING #( entities )
    LINK DATA(booking_supplements).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking_group>) GROUP BY <booking_group>-%tky.
      "먼저 지금 suppl의 부모키의 이전 값 정보를 읽어서 최대 max supplid를 읽어온다.
      max_booking_suppl_id = REDUCE #( INIT lv_max = CONV /dmo/booking_supplement_id( '0' )
                                       FOR booksuppl IN booking_supplements USING KEY entity
                                         WHERE ( source-TravelId = <booking_group>-TravelId
                                            AND source-BookingId = <booking_group>-BookingId  )
                                         NEXT lv_max = COND #( WHEN booksuppl-target-BookingSupplementId > lv_max
                                                               THEN booksuppl-target-BookingSupplementId
                                                               ELSE lv_max )
           ).


      "다음으로 지금 작업중인 suppl의 정보를 읽어서 최대 max supplid를 읽어온다.

      max_booking_suppl_id = REDUCE #( INIT lv_max = max_booking_suppl_id
                                       FOR entity IN entities USING KEY entity
                                         WHERE ( TravelId = <booking_group>-TravelId
                                             AND BookingId = <booking_group>-BookingId )
                                          FOR target IN entity-%target
                                          NEXT lv_max = COND #( WHEN target-BookingSupplementId > lv_max
                                                                THEN target-BookingSupplementId
                                                                ELSE lv_max )
       ).

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking>) USING KEY entity WHERE TravelId = <booking_group>-TravelId
                                                                            AND BookingId = <booking_group>-BookingId.
        LOOP AT <booking>-%target ASSIGNING FIELD-SYMBOL(<booksuppl_wo_no>).
          APPEND CORRESPONDING #( <booksuppl_wo_no> ) TO mapped-yi_booksuppl_eug_m ASSIGNING FIELD-SYMBOL(<mapped_booksuppl>).
          IF <mapped_booksuppl>-BookingSupplementId IS INITIAL.
            max_booking_suppl_id += 1.
            <mapped_booksuppl>-BookingSupplementId = max_booking_suppl_id.
          ENDIF.

        ENDLOOP.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

* base view의 booking에서 feature control을 했으므로 해당 booking의 class에 코딩한다.
  METHOD get_instance_features.

    READ ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
    ENTITY YI_TRAVEL_eug_M BY \_Booking   "association을 통해서 즉 booking을 읽으란 예기
    FIELDS ( TravelId BookingStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_booking).
* book의 상태값이 reject가 되어있으면 cba booksuppl 기능이 막히고, 그 외에는 열린다
* 여기는 approver가 아니라 creater가 영향을 받는 부분이다.
* base behav def 에서 모든 feature control관련 내용을 지정하지만, comsump behav에서
* use를 다르게 하고, 이곳은 base view의 booking의 cba괸련 내용이고 pool class를 booking에서 imple했다.
    result = VALUE #( FOR ls_booking IN lt_booking
                    ( %tky = ls_booking-%tky
                      %features-%assoc-_Bookingsuppl = COND #( WHEN ls_booking-BookingStatus = 'X'
                                                               THEN if_abap_behv=>fc-o-disabled
                                                               ELSE if_abap_behv=>fc-o-enabled ) )

     ).

  ENDMETHOD.

  METHOD validateConnection.
  ENDMETHOD.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validateCustomer.
  ENDMETHOD.

  METHOD validateFlightPrice.
  ENDMETHOD.

  METHOD validateStatus.
  ENDMETHOD.

  METHOD calculateTotalPrice.

* 키 이름을 key로 하고 구성품을 travelid 로하는 unique hashed key를 받게 internal table을 만든다.
* 키에서 bookingid는 필요없으므로
    DATA: it_travel TYPE STANDARD TABLE OF YI_TRAVEL_eug_M WITH UNIQUE HASHED KEY key COMPONENTS TravelId.
    it_travel = CORRESPONDING #( keys DISCARDING DUPLICATES MAPPING TravelId = TravelId ).
    MODIFY ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
    ENTITY YI_TRAVEL_eug_M
    EXECUTE recalcTotPrice
    FROM CORRESPONDING #( it_travel ).

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
