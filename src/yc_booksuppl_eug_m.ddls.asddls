@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'test'
@Metadata.allowExtensions: true //meta data exet를 사용하려면 이게 있어야한다.
define view entity YC_BOOKSUPPL_EUG_M
  as projection on yi_booksuppl_eug_m
{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      @ObjectModel.text.element: [ 'SupplementDesc' ]
      SupplementId,
      _SupplementText.Description as SupplementDesc : localized,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      CurrencyCode,
      LastChangedAt,
      /* Associations */
      _Travel  : redirected to YC_TRAVEL_EUG_M, //직접적인 parent는 아니지만 BO의 일부라는것을 알려줌
      _Booking : redirected to parent YC_BOOKING_EUG_M,
      _SupplementText,
      _Supplment
}
