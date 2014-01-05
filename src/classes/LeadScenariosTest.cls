/**
  * This Test Class covers the following scenarios
  * 1) On lead record Status changed to Parked, 
  *    validation rule check and Workflow execution
**/
@isTest
class LeadScenariosTest{
    
    /**
      * On lead record Status changed to Parked, 
      * validation rule check and Workflow execution
    **/
    static testmethod void leadParkingScenarioTest(){
        Lead leadTest = CreateObjectRecordsTest.createLeadTestRecord();
        leadTest.Status = 'In Evaluation';
        update leadTest;
        System.debug('RecordType: '+leadTest.RecordTypeId);
        
        leadTest.Status = 'Parked';
        leadTest.Reason_For_Parking__c = 'Other';
        leadTest.RevisitAfterDate__c = date.parse('01/10/2014');
        
        update leadTest;
    }
    
    public static testMethod void leadApprovalProcessTest() { 
        Profile profileBDAM = [SELECT Id FROM Profile WHERE Name='BD AM']; 
        User userBDAM = new User(   Alias = 'BDAM', Email='userBDAM@flipkart.com',LastName='Test SM', 
                                    ProfileId = profileBDAM.Id, UserName='userBDAM@flipkart.com',
                                    EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', TimeZoneSidKey='Asia/Kolkata');
       
        Profile profileBDOM = [SELECT Id FROM Profile WHERE Name='BD On-boarding Manager']; 
        User userBDOM = new User(   Alias = 'BDOM', Email='userBDOM@flipkart.com',LastName='Test OM',
                                    ProfileId = profileBDOM.Id, UserName='userBDOM@flipkart.com',
                                    EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', TimeZoneSidKey='Asia/Kolkata');
        insert userBDAM;
        
        //Test to Submit for Approval by BD AM
        Lead leadTest = CreateObjectRecordsTest.createLeadTestRecord();     
        leadTest.OwnerId = userBDAM.Id;
        System.runAs(userBDAM) {
            // The following code runs as user BD AM to Submit for approval lead record
            System.debug('Current User: ' +UserInfo.getUserName());
            System.debug('Current Profile: ' +UserInfo.getProfileId()); 
            System.debug('lead Owner: '+leadTest.OwnerId+'- userBDAM: '+userBDAM.Id);
            
            leadTest.Approval_State__c = 1;
            update leadTest;
            System.runAs(userBDOM) {
                // The following code runs as user BD Senior Manager to Approve lead record. 
                System.debug('Current User: ' +UserInfo.getUserName());
                System.debug('Current Profile: ' +UserInfo.getProfileId()); 
                
                leadTest.Approval_State__c = 2;
                update leadTest;
            }
        }
        
        //Test to Resubmit of Approval Process
        Lead leadTest1 = CreateObjectRecordsTest.createLeadTestRecord();     
        leadTest.OwnerId = userBDAM.Id;
        System.runAs(userBDAM) {
            // The following code runs as user BD AM to Submit for approval lead record
            System.debug('Current User: ' +UserInfo.getUserName());
            System.debug('Current Profile: ' +UserInfo.getProfileId()); 
            System.debug('lead Owner: '+leadTest1.OwnerId+'- userBDAM: '+userBDAM.Id);
            
            leadTest1.Approval_State__c = 1;
            update leadTest1;
            System.runAs(userBDOM) {
                // The following code runs as user BD Onboarding Manager 
                // Specify BD AM to Resubmit lead record. 
                System.debug('Current User: ' +UserInfo.getUserName());
                System.debug('Current Profile: ' +UserInfo.getProfileId()); 
                
                leadTest1.Approver_Action__c = 'Resubmit';
                leadTest1.Approver_Comments__c = 'Test Comments';
                update leadTest1;
                System.debug('Approval State: '+leadTest1.Approval_State__c);
            }
            //Following Code test Dropping lead record by BD OM
            leadTest1.Approval_State__c = 1;
            update leadTest1;
            
            System.runAs(userBDOM) {
                // The following code runs as user BD Onboarding Manager 
                // and lead record mark as Dropped. 
                System.debug('Current User: ' +UserInfo.getUserName());
                System.debug('Current Profile: ' +UserInfo.getProfileId()); 
                
                leadTest1.Approver_Action__c = 'Dropped';
                leadTest1.Reason_for_Dropping__c = 'Seller Not Reachable';
                update leadTest1;
                System.debug('Approval State: '+leadTest1.Approval_State__c);
            }
        }
        
        //Test to Submit for Approval by BD AM
        Lead leadTest2 = CreateObjectRecordsTest.createLeadTestRecord();     
        leadTest2.OwnerId = userBDAM.Id;
        System.runAs(userBDAM) {
            // The following code runs as user BD AM to Submit for approval lead record
            System.debug('Current User: ' +UserInfo.getUserName());
            System.debug('Current Profile: ' +UserInfo.getProfileId()); 
            System.debug('lead Owner: '+leadTest2.OwnerId+'- userBDAM: '+userBDAM.Id);
            
            leadTest2.Approval_State__c = 1;
            update leadTest2;
            System.runAs(userBDOM) {
                // The following code runs as user BD Onboarding Manager to Approve lead record. 
                System.debug('Current User: ' +UserInfo.getUserName());
                System.debug('Current Profile: ' +UserInfo.getProfileId()); 
                
                leadTest2.Approver_Action__c = 'Parked';
                leadTest2.Reason_For_Parking__c = 'Other';
                leadTest2.RevisitAfterDate__c = date.parse('01/06/2014');
                update leadTest2;
                System.debug('Approval State: '+leadTest2.Approval_State__c);
            }
        }
   }
}