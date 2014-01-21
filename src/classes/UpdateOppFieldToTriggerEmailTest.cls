/**
  * This Apex Test Class is to test 'UpdateOppFieldToTriggerEmail' Apex Class
  * at various intervals of time 
**/
@isTest
class UpdateOppFieldToTriggerEmailTest {

    /**
      * Test method to update Opportunity field and
      * schedule job at 6 PM
    **/
    @isTest(SeeAllData=true)
    static void testOppFieldUpdate() {
        System.debug('In testOppFieldUpdate test method');
        Opportunity oppTest = UtilityClassTest.createOpportunityTestRecord();
        oppTest.StageName = 'Invited';
        update oppTest;
        
        Test.startTest();
        List<Opportunity> oppList = [SELECT Id FROM Opportunity WHERE StageName = 'Invited' AND Is_Invited__c = 0];
        for(Opportunity opp :oppList){
            opp.Is_Invited__c = 1;
            System.debug('Is Invited: '+opp.Is_Invited__c);
        }
        update oppList;
        Test.stopTest(); 
    }
    
    /**
      * Test method to test apex scheduler at 10 AM
    **/
    static testmethod void testScheduleAt10AM() {
        // Schedule runs Monday through Friday at 10 AM        
        String sch = '0 0 10 ? * MON-FRI'; 
        Test.startTest();
		Opportunity oppTest = UtilityClassTest.createOpportunityTestRecord();
        oppTest.StageName = 'Invited';
        update oppTest;
        
        UpdateOppFieldToTriggerEmailClass testSchedule = new UpdateOppFieldToTriggerEmailClass();
        system.schedule('Test Schedule', sch, testSchedule);
      
        Test.stopTest(); 
    }
    
    /**
      * Test method to test apex scheduler at 4 PM
    **/
    static testmethod void testScheduleAt4PM() {
        // Schedule runs Monday through Friday at 4 PM        
        String sch = '0 0 16 ? * MON-FRI'; 
        Test.startTest();
		Opportunity oppTest = UtilityClassTest.createOpportunityTestRecord();
        oppTest.StageName = 'Invited';
        update oppTest;
        
        UpdateOppFieldToTriggerEmailClass testSchedule = new UpdateOppFieldToTriggerEmailClass();
        system.schedule('Test Schedule', sch, testSchedule);
      
        Test.stopTest(); 
    }
}