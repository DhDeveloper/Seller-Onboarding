/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class updateHubOnInsertTriggerTest {

    static testMethod void HubUploadTest() {
    	
    	Profile profileBDAM = [SELECT Id FROM Profile WHERE Name='BD AM']; 
        User userBDAM = new User(   Alias = 'BDAM', Email='userBDAM@flipkart.com',LastName='Test SM', 
                                    ProfileId = profileBDAM.Id, UserName='userBDAM@flipkart.com',
                                    EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', TimeZoneSidKey='Asia/Kolkata');
                                    
    	List<Lead> leadTest = new List<Lead>();
        
        PincodeHubMapping__c pin = new PincodeHubMapping__c();
        pin.Name = '112';
        pin.Hub_Name__c = 'Test Hub';
        insert pin;
        
    	leadTest.add(new Lead(Company='Test1',FirstName='Test1',LastName='Test1', Temp_Region__c = 'Goa', PickupPincode__c='111',Pickup_Pincode__c = pin.Id));
    	leadTest.add(new Lead(Company='Test2',FirstName='Test2',LastName='Test2', Temp_Region__c = 'Goa', PickupPincode__c='111',Pickup_Pincode__c = pin.Id));
    	leadTest.add(new Lead(Company='Test3',FirstName='Test3',LastName='Test3', Temp_Region__c = 'Goa', PickupPincode__c='222',Pickup_Pincode__c = pin.Id));
    	leadTest.add(new Lead(Company='Test4',FirstName='Test4',LastName='Test4', Temp_Region__c = 'Goa', PickupPincode__c='111',Pickup_Pincode__c = pin.Id));
    	insert leadTest;
    	
    	Lead l = new Lead(Company='Test5',FirstName='Test5',LastName='Test5', Temp_Region__c = 'Goa', PickupPincode__c='111', Status= 'Open',Pickup_Pincode__c = pin.Id);
    	l.Seller_Registration_Email__c = 'AAA@test.com';
    	l.SuperCategory__c = 'BGM'; 
		l.VAT_Status__c = 'Not Needed'; 
		l.Are_templates_open__c = TRUE;
		l.Are_Brands_Approved__c = TRUE; 
		l.Phone = '2222';
		l.Approver_Action__c ='Approved';
    	
    	insert l;
    	
    	/*Database.LeadConvert lc = new database.LeadConvert();
		lc.setLeadId(l.id);
		lc.setDoNotCreateOpportunity(true);
		lc.setOwnerId(userBDAM.Id);
		lc.setConvertedStatus('Converted');
		
		Database.LeadConvertResult lcr = Database.convertLead(lc);
		System.assert(lcr.isSuccess());*/
    	
    	Account testAccount = new Account(Name = 'Test Account');        
        insert testAccount;
        
        PincodeHubMapping__c pin111 = new PincodeHubMapping__c(Name = '111', Hub_Name__c = 'Test Hub');
        insert pin111;
        
        PincodeHubMapping__c pin222 = new PincodeHubMapping__c(Name = '222', Hub_Name__c = 'Test Hub');
        insert pin222;
        
    	List<Opportunity> oppList = new List<Opportunity>();
    	oppList.add(new Opportunity(  Name = 'Test1',AccountId = testAccount.Id,StageName = 'Candidate',CloseDate = date.parse('01/10/2014'), Pickup_Pincode__c='111',
                                                        Seller_Registration_Email__c = 'test@testmail.com',
                                                        Pickup_Area_Pincode__c = pin111.Id ));
    	oppList.add(new Opportunity(  Name = 'Test2',AccountId = testAccount.Id,StageName = 'Candidate',CloseDate = date.parse('01/10/2014'), Pickup_Pincode__c='111',
                                                        Seller_Registration_Email__c = 'test@testmail.com',
                                                        Pickup_Area_Pincode__c = pin111.Id ));
    	oppList.add(new Opportunity(  Name = 'Test3',AccountId = testAccount.Id,StageName = 'Candidate',CloseDate = date.parse('01/10/2014'), Pickup_Pincode__c='222',
                                                        Seller_Registration_Email__c = 'test@testmail.com',
                                                        Pickup_Area_Pincode__c = pin222.Id ));
    	oppList.add(new Opportunity(  Name = 'Test4',AccountId = testAccount.Id,StageName = 'Candidate',CloseDate = date.parse('01/10/2014'), Pickup_Pincode__c='111',
                                                        Seller_Registration_Email__c = 'test@testmail.com',
                                                        Pickup_Area_Pincode__c = pin111.Id ));
    	oppList.add(new Opportunity(  Name = 'Test5',AccountId = testAccount.Id,StageName = 'Candidate',CloseDate = date.parse('01/10/2014'), Pickup_Pincode__c='111',
                                                        Seller_Registration_Email__c = 'test@testmail.com',
                                                        Pickup_Area_Pincode__c = pin111.Id ));
    	insert oppList;
    	
    	PincodeHubMapping__c pin1 = new PincodeHubMapping__c();
    	pin1.Name = '111';pin1.Hub_Name__c = 'ABD';
    	insert pin1;
    	
    	List<Lead> leadPrintList = [	SELECT Id,Name, PickupPincode__c,Pickup_Pincode__c,Hub_Name__c 
							FROM Lead ];
	
		List<Opportunity> oppPrintList = [	SELECT Id,Name, Pickup_Pincode__c,Pickup_Area_Pincode__c, Hub_Name__c
									FROM Opportunity];
    	
    	for(Lead lead : leadPrintList){
    		System.debug('1-Lead Name'+lead.Name);
    		System.debug('1-lead.Pickup_Pincode__c'+lead.Pickup_Pincode__c);
    		System.debug('1-lead.Hub_Name__c'+lead.Hub_Name__c);
    	}
    	
    	for(Opportunity opp : oppPrintList){
    		System.debug('1- Opp Name'+opp.Name);
    		System.debug('1-opp.Pickup_Area_Pincode__c'+opp.Pickup_Area_Pincode__c);
    		System.debug('1-opp.Hub_Name__c'+opp.Hub_Name__c);
    	}
    	
    	PincodeHubMapping__c pin11 = new PincodeHubMapping__c();
    	pin11.Name = '222';pin11.Hub_Name__c = 'XYZ';
    	insert pin11;
    	
    	List<Lead> leadPrintList2 = [	SELECT Id,Name, PickupPincode__c,Pickup_Pincode__c,Hub_Name__c 
							FROM Lead ];
	
		List<Opportunity> oppPrintList2 = [	SELECT Id,Name, Pickup_Pincode__c,Pickup_Area_Pincode__c, Hub_Name__c
									FROM Opportunity];
    	
    	for(Lead lead : leadPrintList2){
    		System.debug('2-Lead Name'+lead.Name);
    		System.debug('2-lead.Pickup_Pincode__c'+lead.Pickup_Pincode__c);
    		System.debug('2-lead.Hub_Name__c'+lead.Hub_Name__c);
    	}
    	
    	for(Opportunity opp : oppPrintList2){
    		System.debug('2- Opp Name'+opp.Name);
    		System.debug('2-opp.Pickup_Area_Pincode__c'+opp.Pickup_Area_Pincode__c);
    		System.debug('2-opp.Hub_Name__c'+opp.Hub_Name__c);
    	}
    }
}