@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'test'
@Metadata.allowExtensions: true //meta data exet를 사용하려면 이게 있어야한다.
define view entity YC_BOOKING_EUG_M
  as projection on yi_booking_eug_m
{
  key TravelId,
  key BookingId,
      BookingDate,
      @ObjectModel.text.element: [ 'CustomerName' ] //이것은 abap layer로 metadata ext에 넣을 수 없음 이렇게 하면 text필드와 id 필드가 하나로 보여지게 된다.
      CustomerId,
      _Customer.LastName         as CustomerName,  // @ObjectModel.text 를 쓰려면  text field를 추가하고 그이름을 지정해야한다.
      @ObjectModel.text.element: [ 'CarrierName' ]
      CarrierId,
      _Carrier.Name              as CarrierName,
      ConnectionId,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,
      @ObjectModel.text.element: [ 'BookingStatusText' ]
      BookingStatus,
      _Booking_Status._Text.Text as BookingStatusText : localized,
      LastChangedAt,
      /* Associations */
      _Bookingsuppl : redirected to composition child YC_BOOKSUPPL_EUG_M,
      _Booking_Status,

      _Carrier,
      _Connection,
      _Customer,
      _Travel       : redirected to parent YC_TRAVEL_EUG_M
}
