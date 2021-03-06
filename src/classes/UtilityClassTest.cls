/**
  * This Apex Test Class is to create and return
  * test records for Lead, Account, Opportunity Objects
**/
@isTest
public class UtilityClassTest{

    /**
      * This method creates and returns Lead test record
      * @return test Lead Object
    **/
    public static Lead createLeadTestRecord(){
        //Test Account creation
        Lead leadTest = new Lead(   Company='Test Lead',
                                    FirstName='John',
                                    LastName='June',
                                    Temp_Region__c = 'Goa',
                                    Temp_Pickup_Pincode__c = 100
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
    @isTest(SeeAllData=true)
    public static Opportunity createOpportunityTestRecord(){
		Profile profileSSAM = [SELECT Id FROM Profile WHERE Name='SS AM']; 
        UserRole userRole = [SELECT Id FROM UserRole WHERE Name='SS Agent'];
        
        User userSSAM = [SELECT Id FROM User WHERE UserRoleId = :userRole.Id AND ProfileId = :profileSSAM.Id AND IsActive = true  LIMIT 1];
        
        Account testAccount = createAccountTestRecord();
        
        PincodeHubMapping__c pin = new PincodeHubMapping__c(Name = '1020301', Hub_Name__c = 'Test Hub');
        insert pin;
        
        System.debug('Pin Id:'+ pin.Id);
        
        Opportunity testOpportunity = new Opportunity(  Name = 'Test Opportunity',
                                                        AccountId = testAccount.Id,
                                                        StageName = Constants.OPP_STAGE_CANDIDATE,
                                                        CloseDate = date.parse('01/10/2014'),
                                                        Seller_Registration_Email__c = 'test@testmail.com',
                                                        Pickup_Area_Pincode__c = pin.Id,
                                                        SS_Owner__c = userSSAM.Id
                                                      );
        insert testOpportunity;
        
        System.debug('PickupPincode:'+testOpportunity.Pickup_Area_Pincode__c);
        
        System.runAs(userWithBDOMProfile()) {
	        testOpportunity.StageName = Constants.OPP_STAGE_READY_TO_ONBOARD;
	        update testOpportunity;
        }
        
        return testOpportunity;
    }
    
    /**
      * This method creates and returns User with BD On-boarding Manager Profile
      * @return user
    **/
    public static User userWithBDOMProfile(){
    	Profile profileBDOM = [SELECT Id FROM Profile WHERE Name='BD On-boarding Manager']; 
        User userBDOM = new User(   Alias = 'BDOM', Email='userWithBDOMProfile@flipkart.com',LastName='Test BD OM',
                                    ProfileId = profileBDOM.Id, UserName='userWithBDOMProfile@flipkart.com',
                                    EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', TimeZoneSidKey='Asia/Kolkata');
        insert userBDOM;
        
        return userBDOM;
    }
}