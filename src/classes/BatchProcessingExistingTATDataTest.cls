/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
public class BatchProcessingExistingTATDataTest {

    static testMethod void batchProcessingTestOne() {
        Test.startTest();
        BatchProcessingExistingTATDataClass batch = new BatchProcessingExistingTATDataClass();
        Database.executeBatch(batch,50);
        Test.stopTest();
    } 
    
    static testMethod void batchProcessingTester(){
    	List<Holiday> holidaysList = [Select h.ActivityDate From Holiday h];
    	Opportunity opp = UtilityClassTest.createOpportunityTestRecord();
        opp.Expected_TAT__c = Constants.TAT_13;
        opp.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
        update opp;
        
        opp.StageName = Constants.OPP_STAGE_INVITED;
        update opp;
        
    	TATHelperTest.createTATStageProfile18TestData();
    	List<TAT_Stage_Profile__c> TATStageProfileList = [SELECT Id,TAT_Profile_Spec__c,TAT_Profile_ID__r.TAT_Profile__c,
                                                             TAT_Stage_ID__r.Name,TAT_Stage_ID__r.TAT_Stage__c,
                                                             TAT_Profile_ID__r.Name
                                                      FROM TAT_Stage_Profile__c  where active__c = TRUE];
    	
    	List<Seller_TAT_Breach__c> sellerTATList = new List<Seller_TAT_Breach__c>();
        Date actualStartDate = Date.parse('20/08/2013');	
        Date closureDate = actualStartDate - 1;
        Date nextBreachDate;
        
        for(TAT_Stage_Profile__c tsp: TATStageProfileList){
        	System.debug('In TAT Stage Profile loop');
            closureDate = UtilityClass.addDaysExcludingSundaysHolidays(closureDate,
                                                                    Integer.valueOf(tsp.TAT_Profile_Spec__c),
                                                                    holidaysList);
            nextBreachDate = UtilityClass.addDaysExcludingSundaysHolidays(closureDate,1,holidaysList);
            Seller_TAT_Breach__c sellerTAT = new Seller_TAT_Breach__c();
            sellerTAT.TAT_Stage_Profile_ID__c = tsp.Id;
            sellerTAT.Opportunity__c = opp.Id;
            sellerTAT.Ideal_Closure_Date__c = closureDate;
            sellerTAT.Next_Breach_Date__c = nextBreachDate;
            sellerTAT.Estimated_Closure_Date__c = closureDate;
            sellerTATList.add(sellerTAT);
        }
        insert sellerTATList;
        
        Test.startTest();
        BatchProcessingExistingTATDataClass batch = new BatchProcessingExistingTATDataClass();
        Database.executeBatch(batch,50);
        Test.stopTest();
    }   
}