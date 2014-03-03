/**
  * This Apex Test Class before inserting and before updating trigger on Opportunity.  
  * Check the following actions  
  * 1) Test Populating values of Delay Reasons wise delay days count in Delay Summary section
  * 2) Checks Opportunity records in 'Invited' stage and ready to send them   
  *    to SMS system group mail [<email-address>]
**/
@isTest
public class OpportunityBeforeTriggerTest{
    
    /**
      *  Test Populating values of Delay Reasons wise delay days count in Delay Summary section  
    **/
    //@isTest(SeeAllData=true)
    static testMethod void testPopulateDelaySummaryValues() {
        System.debug('In test method testPopulateDelaySummaryValues');
        Opportunity oppTest = UtilityClassTest.createOpportunityTestRecord();
        
        System.debug('Record Type: '+oppTest.Name);
        oppTest.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
        
        update oppTest;
        
        System.debug('Record Type: '+oppTest.StageName);
        
        
        oppTest.Delay_Reasons__c = Constants.DELAY_REASON_SELLER_NOT_REACHABLE;
        oppTest.Attempts_Or_Delay_Days__c = '3';
        
        update oppTest;
        
        oppTest.Delay_Reasons__c = Constants.DELAY_REASON_OTHER;
        oppTest.Attempts_Or_Delay_Days__c = '5';

        update oppTest;      
        
    }
    
    static testMethod void testPopulateDelaySummaryValues2() {
        System.debug('In test method testPopulateDelaySummaryValues');
        Opportunity oppTest = UtilityClassTest.createOpportunityTestRecord();
        
        System.debug('Record Type: '+oppTest.Name);
        oppTest.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
        
        update oppTest;
        
        System.debug('Record Type: '+oppTest.StageName);
        
        oppTest.Delay_Reasons__c = Constants.DELAY_REASON_SELLER_NEED_MORE_TIME;
        oppTest.Attempts_Or_Delay_Days__c = '2';

        update oppTest;   
        
        
        oppTest.Delay_Reasons__c = Constants.DELAY_REASON_BANK_VERIFICATION;
        oppTest.Attempts_Or_Delay_Days__c = '1';

        update oppTest;            
    }
    
    static testMethod void testPopulateDelaySummaryValues3() {
        System.debug('In test method testPopulateDelaySummaryValues');
        Opportunity oppTest = UtilityClassTest.createOpportunityTestRecord();
        
        System.debug('Record Type: '+oppTest.Name);
        oppTest.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
        
        update oppTest;
        
        System.debug('Record Type: '+oppTest.StageName);        
        oppTest.Delay_Reasons__c = Constants.DELAY_REASON_BD_WANTS_MORE_TIME;
        oppTest.Attempts_Or_Delay_Days__c = '2';

        update oppTest;   
        
        oppTest.Delay_Reasons__c = Constants.DELAY_REASON_EKL_LIMITATION;
        oppTest.Attempts_Or_Delay_Days__c = '3';

        update oppTest; 
        
    }
    
    static testMethod void testPopulateDelaySummaryValues4() {
        System.debug('In test method testPopulateDelaySummaryValues');
        Opportunity oppTest = UtilityClassTest.createOpportunityTestRecord();
        
        System.debug('Record Type: '+oppTest.Name);
        oppTest.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
        
        update oppTest;
        
        System.debug('Record Type: '+oppTest.StageName);
        
        oppTest.Delay_Reasons__c = Constants.DELAY_REASON_IMAGE_ISSUE;
        oppTest.Attempts_Or_Delay_Days__c = '4';

        update oppTest; 
        
        oppTest.Delay_Reasons__c = Constants.DELAY_REASON_KYC_VERIFICATION;
        oppTest.Attempts_Or_Delay_Days__c = '5';

        update oppTest; 
        
        oppTest.Delay_Reasons__c = Constants.DELAY_REASON_RESCHEDULING_AGAIN;
        oppTest.Attempts_Or_Delay_Days__c = '2';

        update oppTest; 
        
    }
    
    static testMethod void testPopulateDelaySummaryValues6() {
        System.debug('In test method testPopulateDelaySummaryValues');
        Opportunity oppTest = UtilityClassTest.createOpportunityTestRecord();
        
        System.debug('Record Type: '+oppTest.Name);
        oppTest.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
        
        update oppTest;
                
        oppTest.Delay_Reasons__c = Constants.DELAY_REASON_RESOURCE_PROBLEM;
        oppTest.Attempts_Or_Delay_Days__c = '1';

        update oppTest; 
        
        oppTest.Delay_Reasons__c = Constants.DELAY_REASON_SELLER_NOT_HAPPY;
        oppTest.Attempts_Or_Delay_Days__c = '2';

        update oppTest; 
        
        oppTest.Delay_Reasons__c = Constants.DELAY_REASON_SELLER_OOO;
        oppTest.Attempts_Or_Delay_Days__c = '3';

        update oppTest; 
        
    }
    
    static testMethod void testPopulateDelaySummaryValues7() {
        System.debug('In test method testPopulateDelaySummaryValues');
        Opportunity oppTest = UtilityClassTest.createOpportunityTestRecord();
        
        System.debug('Record Type: '+oppTest.Name);
        oppTest.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
        
        update oppTest;
        
        oppTest.Delay_Reasons__c = Constants.DELAY_REASON_TECH_ISSUE;
        oppTest.Attempts_Or_Delay_Days__c = '5';

        update oppTest; 
        
        oppTest.Delay_Reasons__c = Constants.DELAY_REASON_WAITING_BRAND_APPROVAL;
        oppTest.Attempts_Or_Delay_Days__c = '4';

        update oppTest; 
        
    }
    
    /** 
      * Checks Opportunity records in 'Invited' stage and ready to send them   
      * to SMS system group mail [<email-address>]
    **/
    @isTest(SeeAllData=true)
    static void testInviteMailToSMS() {	
        System.debug('In test method testInviteMailToSMS');
        Opportunity oppTest = UtilityClassTest.createOpportunityTestRecord();
        System.debug('Record Type: '+oppTest.Name);
        oppTest.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
        update oppTest;        
        
        System.debug('Is Invited value before update: '+oppTest.Is_Invited__c);
        oppTest.StageName = Constants.OPP_STAGE_INVITED;
        
        update oppTest;
        System.debug('Is Invited value after update: '+oppTest.Is_Invited__c);
        Test.startTest();
        oppTest.Is_Invited__c = 1;
        update oppTest;
        Test.stopTest();
    }
}