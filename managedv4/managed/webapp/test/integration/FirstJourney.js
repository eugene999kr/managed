sap.ui.define([
    "sap/ui/test/opaQunit",
    "./pages/JourneyRunner"
], function (opaTest, runner) {
    "use strict";

    function journey() {
        QUnit.module("First journey");

        opaTest("Start application", function (Given, When, Then) {
            Given.iStartMyApp();

            Then.onTheYC_TRAVEL_EUG_MList.iSeeThisPage();
            Then.onTheYC_TRAVEL_EUG_MList.onFilterBar().iCheckFilterField("Agency ID");
            Then.onTheYC_TRAVEL_EUG_MList.onFilterBar().iCheckFilterField("Customer ID");
            Then.onTheYC_TRAVEL_EUG_MList.onFilterBar().iCheckFilterField("Overall Status");
            Then.onTheYC_TRAVEL_EUG_MList.onTable().iCheckColumns(7, {"TravelId":{"header":"Travel ID"},"AgencyId":{"header":"Agency ID"},"CustomerId":{"header":"Customer ID"},"BeginDate":{"header":"Starting Date"},"EndDate":{"header":"End Date"},"TotalPrice":{"header":"Total Price"},"OverallStatus":{"header":"Overall Status"}});

        });


        opaTest("Navigate to ObjectPage", function (Given, When, Then) {
            // Note: this test will fail if the ListReport page doesn't show any data
            
            When.onTheYC_TRAVEL_EUG_MList.onFilterBar().iExecuteSearch();
            
            Then.onTheYC_TRAVEL_EUG_MList.onTable().iCheckRows();

            When.onTheYC_TRAVEL_EUG_MList.onTable().iPressRow(0);
            Then.onTheYC_TRAVEL_EUG_MObjectPage.iSeeThisPage();

        });

        opaTest("Teardown", function (Given, When, Then) { 
            // Cleanup
            Given.iTearDownMyApp();
        });
    }

    runner.run([journey]);
});