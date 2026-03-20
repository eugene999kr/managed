sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"managed/test/integration/pages/YC_TRAVEL_EUG_MList",
	"managed/test/integration/pages/YC_TRAVEL_EUG_MObjectPage",
	"managed/test/integration/pages/YC_BOOKING_EUG_MObjectPage"
], function (JourneyRunner, YC_TRAVEL_EUG_MList, YC_TRAVEL_EUG_MObjectPage, YC_BOOKING_EUG_MObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('managed') + '/test/flp.html#app-preview',
        pages: {
			onTheYC_TRAVEL_EUG_MList: YC_TRAVEL_EUG_MList,
			onTheYC_TRAVEL_EUG_MObjectPage: YC_TRAVEL_EUG_MObjectPage,
			onTheYC_BOOKING_EUG_MObjectPage: YC_BOOKING_EUG_MObjectPage
        },
        async: true
    });

    return runner;
});

