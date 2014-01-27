/**
  * This Apex Class is helper class to fetch Web Service or Future calls 
  * required parameters such as End Point URL, User Name and Password
**/
public with sharing class WebServicesDetailsClass {
	
	public List<Flipkart_Applications_Definition__c> appDefinitionsList = null;
	
	/**
	  * This constructor fetch all information of Flipkart Application Definitions 
	  * along with all related End Point URLs 
	**/
	public WebServicesDetailsClass(){
		appDefinitionsList = [SELECT	Application_Name__c, User_Name__c, Password__c, 
										(	SELECT 	End_Point_URL__c, Service_Name__c
											FROM	Flipkart_Applications_Definition__c.Application_End_Point_URL__r)
								FROM	Flipkart_Applications_Definition__c ];
	}
	
	/**
	  * This method retrun map containing OTRS Ticket Create URL, User Name and Password
	  * @ return Map<String,String>
	**/
	public Map<String,String> otrsTicketCreateDetails(){
		Map<String,String> ticketCreateDetails = new Map<String,String>();
		List<Application_End_Point_URL__c> endpointURLList = null;
		
		if(appDefinitionsList.size() > 0){
			for(Flipkart_Applications_Definition__c fad : appDefinitionsList){
				if(fad.Application_Name__c == Constants.APPLICATION_NAME){
					ticketCreateDetails.put(Constants.OTRS_USER_NAME, fad.User_Name__c);
					ticketCreateDetails.put(Constants.OTRS_PASSWORD, fad.Password__c);
					
					endpointURLList = fad.Application_End_Point_URL__r;
					for(Application_End_Point_URL__c aep : endpointURLList){
						if(aep.Service_Name__c == Constants.SERVICE_NAME_TICKET_CREATE){
							ticketCreateDetails.put(Constants.OTRS_TICKET_CREATE_URL, aep.End_Point_URL__c);
						}
					}
					
				}
			}
		}	
		return ticketCreateDetails;
	}

}