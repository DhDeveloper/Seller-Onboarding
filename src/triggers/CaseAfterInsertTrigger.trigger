/**
  * This Apex Trigger will execute on every new case record creation and
  * creates new ticket in OTRS system through future call and 
  * updates same Salesforce Case Object with Ticket Id, Ticket Number
**/
trigger CaseAfterInsertTrigger on Case (after insert) {
	List<String> serializedCaseList = new List<String>();

	List<Case> caseList = [	SELECT 	Id,  Issue_Type__c, Type, Status, 
									Priority, Owner.email, Opportunity__r.Seller_Registration_Email__c,
									Origin, Subject, Description
							FROM 	Case 
							Where	Id in :Trigger.new];
	
	/* Return OTRS Ticket Create details from Flipkart_Applications_Definition__c, Application_End_Point_URL__c Objects 
	*/
	Map<String,String> otrsTicketCreateDetails = new WebServicesDetailsClass().otrsTicketCreateDetails();
	
	for(Case c:caseList){
		serializedCaseList.add(JSON.serialize(new CaseHelperClass(	c.Id, c.Issue_Type__c, c.Type, c.Status, c.Priority, 
																	c.Opportunity__r.Seller_Registration_Email__c, 
																	c.Owner.email, c.Origin, c.Subject, c.Description)));
	}
	
	if(otrsTicketCreateDetails.size() > 0){
		/* Future Call to create ticket in OTRS system and update ticket id on Salesforce Case Object
		   Warning: DML governor limit not considered. May cause error if tried to upload bulk data 
		*/
		OTRSControllerClass.createOTRSTicket(	serializedCaseList, 
												otrsTicketCreateDetails.get(Constants.OTRS_TICKET_CREATE_URL), 
												otrsTicketCreateDetails.get(Constants.OTRS_USER_NAME), 
												otrsTicketCreateDetails.get(Constants.OTRS_PASSWORD));
	}
}