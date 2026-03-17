CLASS ycl_modify_practice1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YCL_MODIFY_PRACTICE1 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA:lt_book TYPE TABLE FOR CREATE YI_TRAVEL_eug_M\_Booking.

*    MODIFY ENTITY YI_TRAVEL_eug_M
*    CREATE FROM VALUE #( ( %cid = 'cid1'
*                           %data-BeginDate = '20260212'
*                           %control-BeginDate = if_abap_behv=>mk-on ) )
*
*     CREATE BY \_Booking
*     FROM VALUE #( ( %cid_ref = 'cid1'
*                     %target = VALUE #( ( %cid = 'cid11'
*                                          %data-BookingDate = '20260213'
*                                          %control-BookingDate = if_abap_behv=>mk-on ) )
*                  ) )
*    FAILED FINAL(it_failed)
*    MAPPED FINAL(it_mapped)
*    REPORTED FINAL(it_result).
*
*    IF it_failed IS NOT INITIAL.
*      out->write( it_failed ).
*    ELSE.
*      COMMIT ENTITIES.
*    ENDIF.


  MODIFY ENTITY YI_TRAVEL_eug_M
   crEATE aUTO FILL CID wITH vALUE #( ( %data-BeginDate = '20250214'
                                        %control-BeginDate = if_abap_behv=>mk-on ) )

    FAILED FINAL(it_failed)
    MAPPED FINAL(it_mapped)
    REPORTED FINAL(it_result).

    IF it_failed IS NOT INITIAL.
      out->write( it_failed ).
    ELSE.
      COMMIT ENTITIES.  "이렇게 해야 실제 table에 저장된다.
    ENDIF.

   MODIFY ENTITIES OF YI_TRAVEL_eug_M
     entity YI_TRAVEL_eug_M
     upDATE seT FIELDS WITH vALUE #( ( %key-TravelId = '1111'
                                       BeginDate = '20250101' ) )

*   MODIFY ENTITIES OF YI_TRAVEL_eug_M
*     entity YI_TRAVEL_eug_M
*     upDATE  FIELDS ( BeginDate ) WITH vALUE #( ( %key-TravelId = '1111'
*                                       BeginDate = '20250101' ) )

*   MODIFY ENTITIES OF YI_TRAVEL_eug_M
     entity YI_TRAVEL_eug_M
     delete fROM vALUE #( ( %key-TravelId = '1111' ) ).



   moDIFY entity yi_booking_eug_m
   deLETE FROM vALUE #( ( %key-TravelId = '1111'
                          %key-BookingId = '10' ) )
    FAILED dATA(it_failed1)
    MAPPED dATA(it_mapped1)
    REPORTED daTA(it_result1) .

    IF it_failed1 IS NOT INITIAL.
      out->write( it_failed1 ).
    ELSE.
      COMMIT ENTITIES.  "이렇게 해야 실제 table에 저장된다.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
