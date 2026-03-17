CLASS lhc_yi_booksuppl_eug_m DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateCurrencyCode FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_booksuppl_eug_m~validateCurrencyCode.

    METHODS validatePrice FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_booksuppl_eug_m~validatePrice.

    METHODS validateSupplement FOR VALIDATE ON SAVE
      IMPORTING keys FOR yi_booksuppl_eug_m~validateSupplement.
    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR yi_booksuppl_eug_m~calculateTotalPrice.

ENDCLASS.

CLASS lhc_yi_booksuppl_eug_m IMPLEMENTATION.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validatePrice.
  ENDMETHOD.

  METHOD validateSupplement.
  ENDMETHOD.

  METHOD calculateTotalPrice.

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
