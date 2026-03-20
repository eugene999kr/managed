sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'managed',
            componentId: 'YC_BOOKING_EUG_MObjectPage',
            contextPath: '/YC_TRAVEL_EUG_M/_Booking'
        },
        CustomPageDefinitions
    );
});