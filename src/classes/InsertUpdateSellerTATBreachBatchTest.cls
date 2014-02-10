/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class InsertUpdateSellerTATBreachBatchTest {

   @isTest(seeAllData=false)
    static void myUnitTest() {
    	
    	 Opportunity opp = UtilityClassTest.createOpportunityTestRecord();
        opp.Expected_TAT__c = Constants.TAT_13;
        opp.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
        update opp;
        
        opp.StageName = Constants.OPP_STAGE_INVITED;
        update opp;
        // TO DO: implement unit test
        Test.startTest();
        InsertUpdateSellerTATBreachBatchClass stbClass = new InsertUpdateSellerTATBreachBatchClass();
        Database.executeBatch(stbClass,50);
        Test.stopTest();
    }
    
    @isTest(seeAllData=false)
    static void myUnitTest2() {
    	
    	 Account testAccount = new Account(Name = 'Test Account');        
        insert testAccount;
        
        PincodeHubMapping__c pin = new PincodeHubMapping__c(Name = '1020301', Hub_Name__c = 'Test Hub');
        insert pin;
        
        Opportunity opp = new Opportunity(  Name = 'Test Opportunity',
                                                        AccountId = testAccount.Id,
                                                        StageName = Constants.OPP_STAGE_CANDIDATE,
                                                        CloseDate = date.parse('01/10/2014'),
                                                        Seller_Registration_Email__c = 'test@testmail.com',
                                                        Pickup_Area_Pincode__c = pin.Id //,
                                                        //TAT_Profile__c = tatProfile.Id
                                                      );
        insert opp;
        System.runAs(UtilityClassTest.userWithBDOMProfile()) {
	        opp.StageName = Constants.OPP_STAGE_READY_TO_ONBOARD;
	        update opp;
        }
        
        opp.Expected_TAT__c = Constants.TAT_13;
        opp.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
        update opp;
        
        opp.StageName = Constants.OPP_STAGE_INVITED;
        update opp;
        
        opp.StageName = Constants.OPP_STAGE_MIN_SKU_CREATION;
        update opp;
        
        // TO DO: implement unit test
        Test.startTest();
        InsertUpdateSellerTATBreachBatchClass stbClass = new InsertUpdateSellerTATBreachBatchClass();
        Database.executeBatch(stbClass,50);
        Test.stopTest();
    }
    
    @isTest(seeAllData=true)
    static List<TAT_Stage__c> getTATStageInfo(){
    	
    	List<TAT_Stage__c> tatStageList = [SELECT Id, TAT_Stage__c, Active__c FROM TAT_Stage__c ORDER BY Id];
    	
    	return tatStageList;
    	
    }
    
    @isTest(seeAllData=true)
    static List<TAT_Profile__c> getTATProfileInfo(){
    	List<TAT_Profile__c> tatProfileList = [SELECT Id, TAT_Profile__c, Active__c FROM TAT_Profile__c ORDER BY Id];
    	
    	return tatProfileList;
    }
    
     @isTest(seeAllData=true)
    static List<TAT_Stage_Profile__c> getTATStageProfileInfo(){
    	List<TAT_Stage_Profile__c> TATStageProfileList = [SELECT Id,TAT_Profile_Spec__c,TAT_Profile_ID__r.TAT_Profile__c,
                                                             TAT_Stage_ID__r.Name,TAT_Stage_ID__r.TAT_Stage__c,
                                                             TAT_Profile_ID__r.Name
                                                      FROM TAT_Stage_Profile__c  where active__c = TRUE];
    	
    	return TATStageProfileList;
    }
    
    
}