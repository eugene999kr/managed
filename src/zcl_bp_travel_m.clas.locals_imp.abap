CLASS lsc_yi_travel_eug_m DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_yi_travel_eug_m IMPLEMENTATION.

  METHOD save_modified.
* travel에 with additional save를 해서 이곳으로 호출되고,
* booksuppl에서 with unmanaged save를 해서 여기로 온다.

    DATA:lt_travel_log TYPE STANDARD TABLE OF ylog_travel_m.
    DATA:lt_travel_log_c TYPE STANDARD TABLE OF ylog_travel_m.
    DATA:lt_travel_log_u TYPE STANDARD TABLE OF ylog_travel_m.

    IF create-yi_travel_eug_m IS NOT INITIAL.

      lt_travel_log = CORRESPONDING #( create-yi_travel_eug_m ).

      LOOP AT lt_travel_log ASSIGNING FIELD-SYMBOL(<ls_travel_log>).

        <ls_travel_log>-changing_operation = 'CREATE'.
        GET TIME STAMP FIELD <ls_travel_log>-created_at.

        READ TABLE create-yi_travel_eug_m ASSIGNING FIELD-SYMBOL(<ls_travel>)
                                     WITH TABLE KEY entity
                                      COMPONENTS TravelId = <ls_travel_log>-travelid.
        IF sy-subrc IS INITIAL.
          IF <ls_travel>-%control-BookingFee = cl_abap_behv=>flag_changed.
            <ls_travel_log>-changed_field_name = 'Booking Fee'.
            <ls_travel_log>-changed_value = <ls_travel>-BookingFee.
            TRY.
                <ls_travel_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ).
              CATCH cx_uuid_error."_ into cx.
            ENDTRY.

          ENDIF.

          APPEND <ls_travel_log> TO lt_travel_log_c.

          IF <ls_travel>-%control-OverallStatus = cl_abap_behv=>flag_changed.
            <ls_travel_log>-changed_field_name = 'Overall Status'.
            <ls_travel_log>-changed_value = <ls_travel>-OverallStatus.
            TRY.
                <ls_travel_log>-change_id = cl_system_uuid=>create_uuid_x16_static( ).
              CATCH cx_uuid_error."_ into cx.
            ENDTRY.

          ENDIF.

          APPEND <ls_travel_log> TO lt_travel_log_c.


        ENDIF.


      ENDLOOP.

      INSERT ylog_travel_m FROM TABLE @lt_travel_log_c.

    ENDIF.

    IF update-yi_travel_eug_m IS NOT INITIAL.

      lt_travel_log = CORRESPONDING #( update-yi_travel_eug_m ).

      LOOP AT update-yi_travel_eug_m ASSIGNING FIELD-SYMBOL(<ls_log_update>).
        ASSIGN lt_travel_log[ travelid = <ls_log_update>-TravelId ] TO FIELD-SYMBOL(<ls_log_u>).

        <ls_log_u>-changing_operation = 'UPDATE'.
        GET TIME STAMP FIELD <ls_log_u>-created_at.

        IF <ls_log_update>-%control-CustomerId = if_abap_behv=>mk-on.
          <ls_log_u>-changed_value = <ls_log_update>-CustomerId.

          TRY.
              <ls_log_u>-change_id = cl_system_uuid=>create_uuid_x16_static( ).
            CATCH cx_uuid_error. "_ into cx.
          ENDTRY.
          <ls_log_u>-changed_field_name = 'Customer_id'.

          APPEND <ls_log_u> TO lt_travel_log_u.

        ENDIF.

        IF <ls_log_update>-%control-Description = if_abap_behv=>mk-on.
          <ls_log_u>-changed_value = <ls_log_update>-Description.

          TRY.
              <ls_log_u>-change_id = cl_system_uuid=>create_uuid_x16_static( ).
            CATCH cx_uuid_error. " into cx.
          ENDTRY.
          <ls_log_u>-changed_field_name = 'Description'.

          APPEND <ls_log_u> TO lt_travel_log_u.
        ENDIF.


      ENDLOOP.

      INSERT ylog_travel_m FROM TABLE @lt_travel_log_u.

    ENDIF.

    IF delete-yi_travel_eug_m IS NOT INITIAL.

      lt_travel_log = CORRESPONDING #( delete-yi_travel_eug_m ).

      LOOP AT lt_travel_log ASSIGNING FIELD-SYMBOL(<ls_log_del>).
        <ls_log_del>-changing_operation = 'DELETE'.
        GET TIME STAMP FIELD <ls_log_del>-created_at.

        TRY.
            <ls_log_del>-change_id = cl_system_uuid=>create_uuid_x16_static( ).
          CATCH cx_uuid_error."_ into cx.
        ENDTRY.


      ENDLOOP.

      INSERT ylog_travel_m FROM TABLE @( lt_travel_log ).

    ENDIF.


* 여기는 booksuppl에서 unmanaged save를 해서 이리로 온다
* boolsuppl은 system의 managed save는 실행되지 않고 여기에서만 저장되게 된다.
    DATA: lt_book_suppl TYPE STANDARD TABLE OF ybooksuppl_eug_m.

    IF create-yi_booksuppl_eug_m IS NOT INITIAL.

      lt_book_suppl = VALUE #( FOR ls_booksup IN create-yi_booksuppl_eug_m
                                  ( travel_id = ls_booksup-TravelId
                                    booking_id = ls_booksup-BookingId
                                    booking_supplement_id = ls_booksup-BookingSupplementId
                                    supplement_id = ls_booksup-SupplementId
                                    price = ls_booksup-Price
                                    currency_code = ls_booksup-CurrencyCode
                                    last_changed_at = ls_booksup-LastChangedAt

                                   )
       ).

      INSERT ybooksuppl_eug_m FROM TABLE @lt_book_suppl.

    ENDIF.

    IF update-yi_booksuppl_eug_m IS NOT INITIAL.
      lt_book_suppl = VALUE #( FOR ls_booksup IN update-yi_booksuppl_eug_m
                                  ( travel_id = ls_booksup-TravelId
                                    booking_id = ls_booksup-BookingId
                                    booking_supplement_id = ls_booksup-BookingSupplementId
                                    supplement_id = ls_booksup-SupplementId
                                    price = ls_booksup-Price
                                    currency_code = ls_booksup-CurrencyCode
                                    last_changed_at = ls_booksup-LastChangedAt

                                   )
       ).

      UPDATE ybooksuppl_eug_m FROM TABLE @lt_book_suppl.
    ENDIF.

    IF delete-yi_booksuppl_eug_m IS NOT INITIAL.
      lt_book_suppl = VALUE #( FOR ls_del IN delete-yi_booksuppl_eug_m
                                  ( travel_id = ls_del-TravelId
                                    booking_id = ls_del-BookingId
                                    booking_supplement_id = ls_del-BookingSupplementId

                                   )
       ).

      DELETE ybooksuppl_eug_m FROM TABLE @lt_book_suppl.
    ENDIF.





  ENDMETHOD.

ENDCLASS.

CLASS lhc_YI_TRAVEL_eug_M DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys
                  REQUEST requested_authorizations
                  FOR YI_TRAVEL_eug_M
      RESULT    result.

    METHODS accepttravel FOR MODIFY
      IMPORTING keys FOR ACTION yi_travel_eug_m~accepttravel RESULT result.

    METHODS copytravel FOR MODIFY
      IMPORTING keys FOR ACTION yi_travel_eug_m~copytravel.

    METHODS recalctotprice FOR MODIFY
      IMPORTING keys FOR ACTION yi_travel_eug_m~recalctotprice.

    METHODS rejecttravel FOR MODIFY
      IMPORTING keys FOR ACTION yi_travel_eug_m~rejecttravel RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR yi_travel_eug_m RESULT result.

    METHODS validatecustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_travel_eug_m~validatecustomer.

    METHODS validatebookingfee FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_travel_eug_m~validatebookingfee.

    METHODS validatecurrencycode FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_travel_eug_m~validatecurrencycode.

    METHODS validatedates FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_travel_eug_m~validatedates.

    METHODS validatestatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_travel_eug_m~validatestatus.

    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR yi_travel_eug_m~calculatetotalprice.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR yi_travel_eug_m RESULT result.

    METHODS earlynumbering_cba_booking FOR NUMBERING
      IMPORTING entities FOR CREATE yi_travel_eug_m\_booking.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities
                  FOR CREATE yi_travel_eug_m.
*
*    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
*      IMPORTING REQUEST requested_authorizations FOR YI_TRAVEL_eug_M RESULT result.

ENDCLASS.

CLASS lhc_YI_TRAVEL_eug_M IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD get_global_authorizations.
*  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA(lt_entities) = entities.

    DELETE lt_entities WHERE TravelId IS NOT INITIAL.
    TRY.
        cl_numberrange_runtime=>number_get(
         EXPORTING
*        ignore_buffer     =
           nr_range_nr       = '01'
           object            =  '/DMO/TRV_M'
           quantity          = CONV #( lines( lt_entities ) )
*        subobject         =
*        toyear            =
         IMPORTING
           number            = DATA(lv_lates_num)
           returncode        = DATA(lv_code)
           returned_quantity = DATA(lv_qty)
       ).
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges INTO DATA(lo_error).
        LOOP AT lt_entities INTO DATA(ls_entities).
          APPEND VALUE #( %cid = ls_entities-%cid
                          %key = ls_entities-%key )
                          TO failed-yi_travel_eug_m.

          APPEND VALUE #( %cid = ls_entities-%cid
                          %key = ls_entities-%key
                          %msg = lo_error )
                          TO reported-yi_travel_eug_m.

        ENDLOOP.
        EXIT.
    ENDTRY.

    ASSERT lv_qty = lines( lt_entities ).
* 3개의 number를 요청하면 최고 번호에서 3을 더한 값을 latest에 주고, 처음에 3을 뺀 값에 1씩 더하면서 3개의 number를 구하는 방식이다.
*    DATA:lt_travel_eug_m TYPE TABLE FOR MAPPED EARLY yi_travel_eug_m,
*         ls_travel_eug_m LIKE LINE OF lt_travel_eug_m.

    DATA(lv_curr_num) = lv_lates_num - lv_qty.

    LOOP AT lt_entities INTO ls_entities.
      lv_curr_num = lv_curr_num + 1.

*      ls_travel_eug_m = VALUE #( %cid = ls_entities-%cid
*                                 TravelId = lv_curr_num ).
*
*      APPEND  ls_travel_eug_m TO mapped-yi_travel_eug_m.

      APPEND VALUE #( %cid = ls_entities-%cid
                      TravelId = lv_curr_num  )
             TO mapped-yi_travel_eug_m.

    ENDLOOP.

  ENDMETHOD.


* behav def 의 association _Booking { create; } 로 generated된, 즉 create by aso 이기 떼문에
* 여기 travel class impl에 생성 된다.
  METHOD earlynumbering_cba_Booking.

    DATA : lv_max_booking  TYPE /dmo/booking_id.

    READ ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
    ENTITY YI_TRAVEL_eug_M BY \_Booking
    FROM CORRESPONDING #(  entities )
    LINK DATA(lt_link_data).


    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_group_entity>)
                               GROUP BY <ls_group_entity>-TravelId.
* lt_link_data에는 지금 booking create 처리하는 과정에서 이전 travel의 예전 버전 저장상태 정보를 가져오는 것이다.
* 즉 이전에 해당 travelid로 존재하는 ls_link-target 중에서 가장 큰 bookingid를 읽어오는 것이다.
* lt_link_data는 table type으로 항목으로 source-travelid, target-travelid, target-bookingid
* 이렇게 각각의 필드로 internal table식으로 정보가 있다. 10 10 1, 10 10 2....
      lv_max_booking = REDUCE #(  INIT lv_max = CONV /dmo/booking_id( 0 )
                              FOR ls_link IN lt_link_data USING KEY entity
                              WHERE ( source-TravelId   = <ls_group_entity>-TravelId )
                              NEXT lv_max = COND #( WHEN lv_max < ls_link-target-BookingId
                                                    THEN ls_link-target-BookingId
                                                    ELSE lv_max  ) ).

* 반면 지금 booking 생성화면에서는 현재 화면에서 추가한 작업중인 booking의 최종 정보를 읽어와야 한다.
* entities는 table type이고 항목으로 source, target이 있지만 그 자체가 table 형태이다.
* 위에서 link data는 항목이 target이 있지만 그것은 그냥 structure를 구성하는 것이고, 여기서는 target도 table이다.
* entities에서는 자체가 table인데, table(source), 10, table(target) 이렇게 되어있다.
* 하나의 행이 각각 source와 target이 table로 되어있어서 위에서 처럼 for 1번으로 안되고
* entities를 for로 loop 돌면서 해당 ls_entity별로 ls_entity-target table을 또 for로 loop 돌아야 값을 가져온다.
      lv_max_booking = REDUCE #( INIT lv_max = lv_max_booking
                                 FOR ls_entity IN entities USING KEY entity
                                 WHERE (  TravelId = <ls_group_entity>-TravelId )
                                 FOR ls_booking IN ls_entity-%target
                                 NEXT lv_max = COND #( WHEN lv_max < ls_booking-BookingId
                                                       THEN ls_booking-BookingId
                                                       ELSE lv_max )
                                                        ).

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entities>)
                       USING KEY entity
                       WHERE TravelId = <ls_group_entity>-TravelId.

        LOOP AT    <ls_entities>-%target ASSIGNING FIELD-SYMBOL(<ls_booking>).
          APPEND CORRESPONDING #(  <ls_booking> ) TO mapped-yi_booking_eug_m
          ASSIGNING FIELD-SYMBOL(<ls_new_map_boook>).

          IF <ls_new_map_boook>-BookingId IS INITIAL.
            lv_max_booking += 10.
            <ls_new_map_boook>-BookingId = lv_max_booking.
          ENDIF.

        ENDLOOP.
      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

  METHOD copyTravel.
    DATA:it_travel        TYPE TABLE FOR CREATE YI_TRAVEL_eug_M,
         it_booking_cba   TYPE TABLE FOR CREATE YI_TRAVEL_eug_M\_Booking, "그냥 create가 아니라 create by asso 이므로 이렇게 지정한다.
         "이렇게 cba로 하면 type을 보면 %cid_ref, travelid, %target 이 있는데, %target table구조 안에 booking내용이 들어있다(%cid까지)
         it_booksuppl_cba TYPE TABLE FOR CREATE yi_booking_eug_m\_Bookingsuppl.


    READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_without_cid>) WITH KEY %cid = ' '.
    ASSERT <ls_without_cid> IS NOT ASSIGNED.

    READ ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
      ENTITY YI_TRAVEL_eug_M
      ALL FIELDS WITH CORRESPONDING #( keys )  "keys에는 travelid가 있으므로
      RESULT DATA(lt_travel_r)
      FAILED DATA(lt_failed).

    READ ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
      ENTITY YI_TRAVEL_eug_M BY \_Booking
      ALL FIELDS WITH CORRESPONDING #( lt_travel_r )  "lt_travel_r에는 travelid외 다 있지만 travelid만 연결필드로 쓴다.
      RESULT DATA(lt_booking_r).

    READ ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
      ENTITY yi_booking_eug_m BY \_Bookingsuppl
      ALL FIELDS WITH CORRESPONDING #( lt_booking_r )  "lt_travel_r에는 travelid, bookingid외 다 있지만 travelid, bookingid만 연결필드로 쓴다.
      RESULT DATA(lt_booksuppl_r).    "all fields를 썻으므로 모든필드를 읽어온다.

    LOOP AT lt_travel_r ASSIGNING FIELD-SYMBOL(<ls_travel_r>).

*      APPEND INITIAL LINE TO it_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
*      <ls_travel>-%cid = keys[ KEY entity TravelId = <ls_travel_r>-TravelId ]-%cid.
*      <ls_travel>-%data = CORRESPONDING #( <ls_travel_r> EXCEPT TravelId ).
* 위처럼 3줄로 해도 되고 아래처럼 1개로 해도 된다.

* 1. Travel생성
* keys 에는 copy travel했을때 넘겨주는 값이 있는데, %cid, travelid 가 있는데, 선택한 행의 Travelid와 신규를 위한 %cid이다.
* 새로 생성할 %cid를 key-%cid 로 넣고, %data는 읽어온 값으로, Travelid는 빼고 넣어준다(생성될 것이므로).
* it_travel는 %data부분이 별도로 있는것이 아니라 %key, %data로 구분할 뿐이고, corres를 쓰기위해 %data를 쓴 것이고, 실제로는 %cid,traveldid,..... 이렇게 되어있다. %data는 component group로 나누기 위한 방편이다.
      APPEND VALUE #( %cid = keys[ KEY entity TravelId = <ls_travel_r>-TravelId ]-%cid
                      %data = CORRESPONDING #( <ls_travel_r> EXCEPT TravelId ) )
                TO it_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

* 새로 만들어줄 행의 기본값을 넣어준다.
      <ls_travel>-BeginDate = cl_abap_context_info=>get_system_date(  ).
      <ls_travel>-EndDate = cl_abap_context_info=>get_system_date(  ) + 30.

      <ls_travel>-OverallStatus = 'O'.


* 2. Booking을 cba로 생성한다. 1.%cid_ref에 값넣기, 2.%target에 값 넣기.
      APPEND VALUE #( %cid_ref = <ls_travel>-%cid ) "cba이므로 cid_ref값을 넣는다.
      TO it_booking_cba ASSIGNING FIELD-SYMBOL(<it_booking>).

      LOOP AT lt_booking_r ASSIGNING FIELD-SYMBOL(<ls_booking_r>)
                           USING KEY entity
                           WHERE TravelId = <ls_travel_r>-TravelId.

* %target에 %cid는 travel의 cid와 읽어온 bookingid를 붙여서 만들고, data는 읽어온 booking_r
* 여기서 except를 travelid만 해주고 booking은 안넣어주는데, travelid는 위에서 만들어주는걸로 할거고(cba이므로 상위 key는 만들어서 보내준다
* 디버깅해보면 travel의 early numbering을 통과해서 mapped에 travel을 넣어주고, 다음 cba booking의 early numbering에서 이미 travelid가 넘어와 있음  알 수 있음)
* bookingid는 원래 있던번호를 그대로
* 쓰겠다는 뜻이다.(실제 book early numbering을 하면 이미 bookid가 있으면 값을 추가로 넣어주지 않는 로직이 있다. 복사생성에서는 굳이 bookid를 추가로 만들어줄 이유가 없으므로)
        APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_booking_r>-BookingId
                        %data = CORRESPONDING #( <ls_booking_r> EXCEPT TravelId ) )
        TO <it_booking>-%target ASSIGNING FIELD-SYMBOL(<ls_booking_n>).

        <ls_booking_n>-BookingStatus = 'N'.

* 3. BookingSuppl cba로 생성
        APPEND VALUE #( %cid_ref = <ls_booking_n>-%cid )
        TO      it_booksuppl_cba ASSIGNING FIELD-SYMBOL(<ls_booksupp>).

        LOOP AT lt_booksuppl_r ASSIGNING FIELD-SYMBOL(<ls_bookingsupp_r>)
                                USING KEY entity
                                WHERE TravelId = <ls_travel_r>-TravelId
                                  AND BookingId = <ls_booking_r>-BookingId.
* 여기서 except를 travelid, bookingid 만 해주고 bookingsuppl은 안넣어주는데,
*travelid는 위에서 만들어주는걸로 할거고(run time) bookingid도 마찬가지 인데,
*이것은 early numbering에서 디버깅 해보면 알 수 있다.(실제 디버깅 해보면, booksupp early numbering 에서는 이미 travelid, booking id는 넘어온다.booksuppid만 정하는 과정이다)
*즉 여기서는 cba로 parent에서 만들어주는 내용은 비우고 나머지 data만 채워줘도 early numbering에서는 parent에서 필요한거 다 받아온다.
*booksupplid 는 원래 있던번호를 그대로 사용하겠다는 뜻이다.(실제로 early numbering에서 이미 값이 있으면 안넣어줌. 이 copy의 경우 새로 넣어줄 필요 없음)
* 주겠다는 뜻이다.
          APPEND VALUE #( %cid = <ls_travel>-%cid && <ls_booking_r>-BookingId && <ls_bookingsupp_r>-BookingSupplementId
                          %data = CORRESPONDING #( <ls_bookingsupp_r> EXCEPT TravelId BookingId ) )
                          TO <ls_booksupp>-%target.


        ENDLOOP.

      ENDLOOP.


    ENDLOOP.

    MODIFY ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
    ENTITY YI_TRAVEL_eug_M
    CREATE FIELDS ( AgencyId CustomerId BeginDate BookingFee TotalPrice CurrencyCode OverallStatus Description  )
    WITH it_travel
      ENTITY YI_TRAVEL_eug_M
      CREATE BY \_Booking
      FIELDS ( BookingId BookingDate CustomerId CarrierId ConnectionId FlightDate FlightPrice CurrencyCode BookingStatus )
      WITH it_booking_cba
        ENTITY yi_booking_eug_m
        CREATE BY \_Bookingsuppl
        FIELDS ( BookingSupplementId SupplementId Price CurrencyCode )
        WITH it_booksuppl_cba
        MAPPED DATA(it_mapped).

    mapped-yi_travel_eug_m = it_mapped-yi_travel_eug_m.


  ENDMETHOD.

  METHOD recalcTotPrice.

    TYPES:BEGIN OF ty_total,
            price TYPE /dmo/total_price,
            curr  TYPE /dmo/currency_code,
          END OF ty_tOTAL.

    DATA:lt_total      TYPE TABLE OF ty_total,
         lv_conv_price TYPE ty_total-price.

    READ ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
    ENTITY YI_TRAVEL_eug_M
    FIELDS ( BookingFee CurrencyCode )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    DELETE lt_travel WHERE CurrencyCode IS INITIAL.

    READ ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
    ENTITY YI_TRAVEL_eug_M BY \_Booking
    FIELDS ( FlightPrice CurrencyCode )
    WITH CORRESPONDING #( lt_travel )
    RESULT DATA(lt_ba_booking).

    READ ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
    ENTITY yi_booking_eug_m BY \_Bookingsuppl
    FIELDS ( Price CurrencyCode )
    WITH CORRESPONDING #( lt_ba_booking )
    RESULT DATA(lt_ba_booksuppl).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
      lt_total = VALUE #( ( price = <ls_travel>-BookingFee curr = <ls_travel>-CurrencyCode ) ).

      LOOP AT lt_ba_booking ASSIGNING FIELD-SYMBOL(<ls_booking>)
                                     USING KEY entity
                                     WHERE TravelId = <ls_travel>-TravelId
                                       AND CurrencyCode IS NOT INITIAL.

        APPEND VALUE #( price = <ls_booking>-FlightPrice curr = <ls_booking>-CurrencyCode )
      TO lt_total.

        LOOP AT lt_ba_booksuppl ASSIGNING FIELD-SYMBOL(<ls_booksuppl>)
                                       USING KEY entity
                                       WHERE TravelId = <ls_booking>-TravelId
                                        AND BookingId = <ls_booking>-BookingId
                                        AND CurrencyCode IS NOT INITIAL.
          APPEND VALUE #( price = <ls_booksuppl>-Price curr = <ls_booksuppl>-CurrencyCode )
            TO lt_total.
        ENDLOOP.

      ENDLOOP.

      LOOP AT lt_total ASSIGNING FIELD-SYMBOL(<ls_total>).

        IF <ls_total>-curr = <ls_travel>-CurrencyCode.
          lv_conv_price = <ls_total>-price.

        ELSE.
          /dmo/cl_flight_amdp=>convert_currency(
            EXPORTING
              iv_amount               = <ls_total>-price
              iv_currency_code_source = <ls_total>-curr
              iv_currency_code_target = <ls_travel>-CurrencyCode
              iv_exchange_rate_date   = cl_abap_context_info=>get_system_date(  )
            IMPORTING
              ev_amount               = lv_conv_price
          ).

        ENDIF.

        <ls_travel>-TotalPrice = <ls_travel>-TotalPrice + lv_conv_price.

      ENDLOOP.

    ENDLOOP.


    MODIFY ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
    ENTITY YI_TRAVEL_eug_M
    UPDATE FIELDS ( TotalPrice )
    WITH CORRESPONDING #( lt_travel ).




  ENDMETHOD.


  METHOD acceptTravel.
    "이 value로 업데이트 하되, loop를 돌면서 ()안의 값을 넘겨준다는 뜻 즉 key를 loop돌면서 key값을 주면서 overalstatus값을 A로 변경
    "이 action은 $self를 result를 넘기는 내용이므로 실제 ui상에서도 변경된 내용이 바로 반영된다.
    MODIFY ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
    ENTITY YI_TRAVEL_eug_M
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky
                                        OverallStatus = 'A' ) ).

    READ ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
    ENTITY YI_TRAVEL_eug_M
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).


    result = VALUE #( FOR ls_result IN lt_result ( %tky = ls_result-%tky
                                                   %param = ls_result ) ).

  ENDMETHOD.

  METHOD rejectTravel.

    MODIFY ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
    ENTITY YI_TRAVEL_eug_M
    UPDATE FIELDS ( OverallStatus )
    WITH VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky
                                        OverallStatus = 'X'  ) ).

    READ ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
    ENTITY YI_TRAVEL_eug_M
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

*loop를 돌면서 result에 넣어주는데, %tky와 %param을 각각 lt_result 값으로 넣어준다.
    result = VALUE #( FOR ls_result IN lt_result ( %tky = ls_result-%tky
                                                  %param = ls_result ) ) .

  ENDMETHOD.

  METHOD get_instance_features.
* feature control내용 지정

    READ ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
    ENTITY YI_TRAVEL_eug_M
    FIELDS ( TravelId OverallStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    result = VALUE #( FOR ls_travel IN lt_travel ( %tky = ls_travel-%tky
               %features-%action-acceptTravel = COND #( WHEN ls_travel-OverallStatus = 'A'
                                                         THEN if_abap_behv=>fc-o-disabled
                                                         ELSE if_abap_behv=>fc-o-enabled  )
               %features-%action-rejectTravel = COND #( WHEN ls_travel-OverallStatus = 'X'
                                                         THEN if_abap_behv=>fc-o-disabled
                                                         ELSE if_abap_behv=>fc-o-enabled  )
               %features-%assoc-_Booking = COND #( WHEN ls_travel-OverallStatus = 'X'
                                                         THEN if_abap_behv=>fc-o-disabled
                                                         ELSE if_abap_behv=>fc-o-enabled  )

              ) ).

  ENDMETHOD.

  METHOD validateCustomer.

    READ ENTITY IN LOCAL MODE YI_TRAVEL_eug_M
    FIELDS ( CustomerId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    DATA:lt_cust TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

    lt_cust = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING customer_id = CustomerId ).
    DELETE lt_cust WHERE customer_id IS INITIAL.


    SELECT FROM /dmo/customer
    FIELDS customer_id
    FOR ALL ENTRIES IN @lt_cust
    WHERE customer_id = @lt_cust-customer_id
    INTO TABLE @DATA(lt_cust_db) .

    IF sy-subrc IS INITIAL.

    ENDIF.

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      IF <ls_travel>-CustomerId IS INITIAL OR
        NOT line_exists( lt_cust_db[ customer_id = <ls_travel>-CustomerId ] ).

        APPEND VALUE #( %tky = <ls_travel>-%tky ) TO failed-yi_travel_eug_m.

        APPEND VALUE #( %tky = <ls_travel>-%tky
                        %msg  = NEW /dmo/cm_flight_messages(
                        textid                =  /dmo/cm_flight_messages=>customer_unkown
                        customer_id           = <ls_travel>-CustomerId
                        severity              = if_abap_behv_message=>severity-error
                       ) )
        TO reported-yi_travel_eug_m.
      ENDIF.

    ENDLOOP.


  ENDMETHOD.

  METHOD validateBookingFee.
  ENDMETHOD.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validateDates.
    READ ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
    ENTITY YI_TRAVEL_eug_M
    FIELDS ( BeginDate EndDate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travels).

    LOOP AT lt_travels INTO DATA(travel).
      IF travel-EndDate < travel-BeginDate.
        APPEND VALUE #( %tky = travel-%tky ) TO failed-yi_travel_eug_m.

        APPEND VALUE #( %tky = travel-%tky
                        %msg = NEW /dmo/cm_flight_messages(
                          textid                = /dmo/cm_flight_messages=>begin_date_bef_end_date
                          travel_id             = travel-TravelId
                          begin_date            = travel-BeginDate
                          end_date              = travel-EndDate
                          severity              = if_abap_behv_message=>severity-error )
                        %element-BeginDate = if_abap_behv=>mk-on
                        %element-EndDate = if_abap_behv=>mk-on
           ) TO reported-yi_travel_eug_m.

      ELSEIF travel-BeginDate < cl_abap_context_info=>get_system_date( ).

        APPEND VALUE #( %tky = travel-%tky ) TO failed-yi_travel_eug_m.

        APPEND VALUE #( %tky = travel-%tky
                        %msg = NEW /dmo/cm_flight_messages(
                          textid       = /dmo/cm_flight_messages=>begin_date_on_or_bef_sysdate
                          begin_date   = travel-BeginDate
                          severity      = if_abap_behv_message=>severity-error )
                        %element-BeginDate = if_abap_behv=>mk-on
                        %element-Enddate = if_abap_behv=>mk-on
         ) TO reported-yi_travel_eug_m.

      ENDIF.
    ENDLOOP.



  ENDMETHOD.

  METHOD validateStatus.

    READ ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
        ENTITY YI_TRAVEL_eug_M
          FIELDS ( OverallStatus )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travels).

    LOOP AT lt_travels INTO DATA(ls_travel).
      CASE ls_travel-OverallStatus.
        WHEN 'O'.  " Open
        WHEN 'X'.  " Cancelled
        WHEN 'A'.  " Accepted

        WHEN OTHERS.
          APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-YI_TRAVEL_eug_M.

          APPEND VALUE #( %tky = ls_travel-%tky
                          %msg = NEW /dmo/cm_flight_messages(
                                     textid = /dmo/cm_flight_messages=>status_invalid
                                     severity = if_abap_behv_message=>severity-error
                                     status = ls_travel-OverallStatus )
                          %element-OverallStatus = if_abap_behv=>mk-on
                        ) TO reported-YI_TRAVEL_eug_M.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD calculateTotalPrice.

    MODIFY ENTITIES OF YI_TRAVEL_eug_M IN LOCAL MODE
    ENTITY YI_TRAVEL_eug_M
    EXECUTE recalcTotPrice
    FROM CORRESPONDING #( keys ).


  ENDMETHOD.

  METHOD get_global_authorizations.


  ENDMETHOD.

ENDCLASS.
