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
    static testmethod void testPopulateDelaySummaryValues() {
        System.debug('In test method testPopulateDelaySummaryValues');
        Opportunity oppTest = CreateObjectTestRecord.createOpportunityTestRecord();
        
        System.debug('Record Type: '+oppTest.Name);
        oppTest.StageName = 'Ready to Invite';
        
        update oppTest;
        
        System.debug('Record Type: '+oppTest.StageName);
        
        
        oppTest.Delay_Reasons__c = 'Seller Not Reachable';
        oppTest.Attempts_Or_Delay_Days__c = '3';
        
        update oppTest;
        System.debug('Delay Days: '+oppTest.Attempts_Or_Delay_Days__c);
        System.debug('seller Not reachable count: '+oppTest.Seller_Not_Reachable__c);
        
        oppTest.Delay_Reasons__c = 'Seller Not Reachable';
        oppTest.Attempts_Or_Delay_Days__c = '2';

        update oppTest;        
        System.debug('seller Not reachable count after 2 update: '+oppTest.Seller_Not_Reachable__c);
        //System.assertEquals(oppTest.Seller_Not_Reachable__c,4);
        
    }
    
    /** 
      * Checks Opportunity records in 'Invited' stage and ready to send them   
      * to SMS system group mail [<email-address>]
    **/
    static testmethod void testInviteMailToSMS() {
        System.debug('In test method testInviteMailToSMS');
        Opportunity oppTest = CreateObjectTestRecord.createOpportunityTestRecord();
        System.debug('Record Type: '+oppTest.Name);
        oppTest.StageName = 'Ready to Invite';
        update oppTest;        
        
        System.debug('Is Invited value before update: '+oppTest.Is_Invited__c);
        oppTest.StageName = 'Invited';
        
        update oppTest;
        System.debug('Is Invited value after update: '+oppTest.Is_Invited__c);
        oppTest.Is_Invited__c = 0;
        update oppTest;
    }
}