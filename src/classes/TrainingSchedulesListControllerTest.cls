/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class TrainingSchedulesListControllerTest {

    static testMethod void testListPage() {
    	Opportunity opp = UtilityClassTest.createOpportunityTestRecord();
        TrainingSchedulesListController tslController = new TrainingSchedulesListController(new ApexPages.StandardController(opp));
        tslController.getThisWeekEvents();
    }
}