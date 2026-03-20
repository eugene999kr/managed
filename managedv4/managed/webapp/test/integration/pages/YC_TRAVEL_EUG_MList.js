sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'managed',
            componentId: 'YC_TRAVEL_EUG_MList',
            contextPath: '/YC_TRAVEL_EUG_M'
        },
        CustomPageDefinitions
    );
});