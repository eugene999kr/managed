@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'yrdy'
@Metadata.allowExtensions: true
define root view entity YC_TRAVEL_EUG_M
  provider contract transactional_query
  as projection on YI_TRAVEL_eug_M
{
  key TravelId,
      @ObjectModel.text.element: [ 'AgencyName' ] //이것은 abap layer로 metadata ext에 넣을 수 없음 이렇게 하면 text필드와 id 필드가 하나로 보여지게 된다.
      AgencyId,
      _Agency.Name       as AgencyName,
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _Customer.LastName as CustomerName,
      BeginDate,
      EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      CurrencyCode,
      Description,
      @ObjectModel.text.element: [ 'OverallStatusText' ]
      OverallStatus,
      _Status._Text.Text as OverallStatusText : localized,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      /* Associations */
      _Agency,
      _Booking : redirected to composition child YC_BOOKING_EUG_M,
      _Currency,
      _Customer,
      _Status
}
