CLASS ycl_read_practice DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YCL_READ_PRACTICE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*    READ ENTITY yi_travel_tech_m
*     FROM VALUE #( ( %key-TravelId = '0000004159'
*                     %control = VALUE #( AgencyId    = if_abap_behv=>mk-on
*                                         CUSTOMERID  = if_abap_behv=>mk-on
*                                         BEGINDATE   = if_abap_behv=>mk-on
*                                         )
*
*          )
*                    )
*     RESULT DATA(lt_result_short)
*     FAILED DATA(lt_failed_sort).
*
*    IF lt_failed_sort IS NOT INITIAL.
*      out->write( 'Read failed' ).
*
*    ELSE.
*      out->write( lt_result_short ).
*    ENDIF.

*    READ ENTITY YI_TRAVEL_eug_M
*    BY \_Booking
*    ALL FIELDS
*    WITH VALUE #( ( %key-TravelId = '0000004159' )
*                  ( %key-TravelId = '0000004136' )
*                              )
*    RESULT DATA(lt_result_short)
*    FAILED DATA(lt_failed_short).
*
*    IF lt_failed_short IS NOT INITIAL.
*      out->write(  'Read Failed' ).
*    ELSE.
*      out->write( lt_result_short ).
*    ENDIF.


    out->write( 'start' ).

*    READ ENTITIES OF YI_TRAVEL_eug_M
*
*    ENTITY YI_TRAVEL_eug_M
*    ALL FIELDS WITH VALUE #( ( %key-TravelId = '0000004159' )
*                             ( %key-TravelId = '0000004136' )
*                              )
*    RESULT DATA(lt_result_travel)
*
*    ENTITY yi_booking_eug_m
*    ALL FIELDS WITH VALUE #(  (  %key-TravelId = '0000004159'
*                                 %key-BookingId = '0001'  ) )
*     RESULT DATA(lt_result_book)
*
*     FAILED DATA(lt_failed_short).
*
*    IF lt_failed_short IS NOT INITIAL.
*      out->write( 'Read Failed' ).
*    ELSE.
*      out->write( lt_result_travel ).
*      out->write( lt_result_book ).
*    ENDIF.


    DATA:it_optab          TYPE abp_behv_retrievals_tab,
         it_travel         TYPE TABLE FOR READ IMPORT YI_TRAVEL_eug_M,
         it_travel_result  TYPE TABLE FOR READ RESULT YI_TRAVEL_eug_M,
         it_booking        TYPE TABLE FOR READ IMPORT YI_TRAVEL_eug_M\_Booking,
         it_booking_result TYPE TABLE FOR READ RESULT YI_TRAVEL_eug_M\_Booking.

    it_travel = VALUE #( ( %key-TravelId = '0000004159'
                           %control = VALUE #( AgencyId = if_abap_behv=>mk-on
                                               CustomerId = if_abap_behv=>mk-on
                                               BeginDate = if_abap_behv=>mk-on )
     ) ).

    it_booking = VALUE #( ( %key-TravelId = '0000004159'
                            %control = VALUE #( BookingDate = if_abap_behv=>mk-on
                                                BookingStatus = if_abap_behv=>mk-on
                                                BookingId = if_abap_behv=>mk-on )
                         ) ).



    it_optab = VALUE #( ( op = if_abap_behv=>op-r-read
                          entity_name = 'YI_TRAVEL_EUG_M'  "반드시 대문자로 써야함
                          instances = REF #( it_travel )
                          results =  REF #( it_travel_result ) )
*
                         ( op = if_abap_behv=>op-r-read_ba
                          entity_name = 'YI_TRAVEL_EUG_M'
                          sub_name   = '_BOOKING'
                          instances = REF #( it_booking ) "#은 data type을 왼쪽 instances에서 infer 즉 추론 한다는 뜻이고,
                          results = REF #( it_booking_result ) ) "  ref는 참조변수형식의 메모리를 할당한다는 뜻.
                                                            "실제 instances나 result는 type ref to data형식임.
                                     "즉 ref 변수를 생성하고 type은 operand즉 왼쪽변수 그대로 하고 ()안의 변수를 거기에 넣어준다.
*
                         ).
*

    READ ENTITIES
    OPERATIONS it_optab
     FAILED DATA(lt_failed_dy).

    IF lt_failed_dy IS NOT INITIAL.
      out->write(  'read failed' ).
    ELSE.
      out->write( it_travel_result ).
    ENDIF.

*    DATA: it_optab         TYPE abp_behv_retrievals_tab,
*          it_travel        TYPE TABLE FOR READ IMPORT yi_travel_tech_m,
*          it_travel_result TYPE TABLE FOR READ RESULT  yi_travel_tech_m,
*          it_booking       TYPE TABLE FOR READ IMPORT yi_travel_tech_m\_Booking,
*          it_booking_result       TYPE TABLE FOR READ RESULT yi_travel_tech_m\_Booking.
*
*    it_travel = VALUE #( ( %key-TravelId = '0000004159'
*                          %control = VALUE #( AgencyId    = if_abap_behv=>mk-on
*                                             customerid  = if_abap_behv=>mk-on
*                                             begindate   = if_abap_behv=>mk-on
*                                          ) ) ).
*
*   it_booking = VALUE #( ( %key-TravelId = '0000004159'
*                           %control = VALUE #(
*                              BookingDate = if_abap_behv=>mk-on
*                               BookingStatus = if_abap_behv=>mk-on
*                               BookingId =  if_abap_behv=>mk-on
*                           )    ) ).
*
*    it_optab = VALUE #( ( op = if_abap_behv=>op-r-read
*                          entity_name = 'YI_TRAVEL_TECH_M'
*                          instances = REF #( it_travel )
*                          results  = REF #( it_travel_result )  )
*                        ( op = if_abap_behv=>op-r-read_ba
*                          entity_name = 'YI_TRAVEL_TECH_M'
*                          sub_name  = '_BOOKING'
*                          instances = REF #( it_booking )
*                          results  = REF #( it_booking_result )
*                            ) ).
*
*    READ ENTITIES
*       OPERATIONS it_optab
*         FAILED DATA(lt_failed_dy).
*
*    IF lt_failed_dy IS NOT INITIAL.
*      out->write( 'Read failed' ).
*
*    ELSE.
*      out->write( it_travel_result ).
*      out->write( it_booking_result ).
*    ENDIF.


  ENDMETHOD.
ENDCLASS.
