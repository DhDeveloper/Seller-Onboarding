/**
  * This Apex Test Class is to create and return
  * test records for Lead, Account, Opportunity Objects
**/
@isTest
public class CreateObjectRecordsTest{

    /**
      * This method creates and returns Lead test record
      * @return test Lead Object
    **/
    public static Lead createLeadTestRecord(){
        //Test Account creation
        Lead leadTest = new Lead(   Company='Test Lead',
                                    FirstName='John',
                                    LastName='June'
                                );        
        insert leadTest;
        return leadTest;
    }

    /**
      * This method creates and returns Account test record
      * @return test Account Object
    **/
    public static Account createAccountTestRecord(){
        //Test Account creation
        Account testAccount = new Account(Name = 'Test Account');        
        insert testAccount;
        return testAccount;
    }
    
    /**
      * This method creates and returns Opportunity test record
      * with 'Candidate For Onboarding' stage and Close date as 10-Jan-2014
      * @return test Opportunity Object
    **/
    public static Opportunity createOpportunityTestRecord(){
        Account testAccount = createAccountTestRecord();
        Opportunity testOpportunity = new Opportunity(  Name = 'Test Opportunity',
                                                        AccountId = testAccount.Id,
                                                        StageName = 'Candidate For Onboarding',
                                                        CloseDate = date.parse('01/10/2014')
                                                      );
        insert testOpportunity;
        return testOpportunity;
    }
}