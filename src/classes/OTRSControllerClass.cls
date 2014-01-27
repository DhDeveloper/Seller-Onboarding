/**
  * This Apex Class contains OTRS future calls methods
  * 1) Creating ticket on remote system OTRS and updating the ticket id on salesforce
  * 2) Get and update ticket details of OTRS system to salesforce
**/
global class OTRSControllerClass {
	
	/**
	  * This method called from CaseAfterInsertTrigger when new case created.
	  * Create ticket on OTRS system and update Ticket Id on respective Salesforce Case record
	  * @Param serializedCaseList
	  * @Param otrsTicketCreateURL
	  * @Param otrsUserName
	  * @Param otrsPassword
	**/
	@future(callout=true)
	public static void createOTRSTicket(List<String> serializedCaseList, String otrsTicketCreateURL, String otrsUserName, String otrsPassword){
		String loginXMLAttributes = null;
        String inputXML = null;
        
        List<Case> caseList = new List<Case>();
		
		Httprequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(otrsTicketCreateURL);
        request.setHeader('Content-Type', Constants.CONTENT_TYPE_XML);
        
        Map<Id,String> finalXMLMap = OTRSHandlerClass.createOTRSTicketFromCase(serializedCaseList);
        
        Map<Id,String> updateCaseMap = new Map<Id,String>();
        
        if(finalXMLMap.size()>0){
	        for(String caseId: finalXMLMap.keyset()){
	        	loginXMLAttributes = OTRSHandlerClass.loginXMLAttributes(otrsUserName, otrsPassword);
	        	inputXML = OTRSHandlerClass.constructOTRSTicketCreateInputXML(loginXMLAttributes+finalXMLMap.get(caseId));
		       /* request.setBody(inputXML);
		        
		        Http http = new Http();
		        HttpResponse response = http.send(request);
		        
		        XmlStreamReader reader = response.getXmlStreamReader();
		        String resp = response.getBody();  */
		        System.debug('======================================================>>>>>>>>>>>>>>>>>>>>>inputXML: '+inputXML);
		       	// System.debug('======================================================>>>>>>>>>>>>>>>>>>>>>resp: '+resp);
				caseList.add(OTRSHandlerClass.outputXMLParser(Constants.outputXML, caseId));
				
	        }
	        update caseList;
        }
	}
	
	@future(callout=true)
	public static void getOTRSTicket(String otrsTicketCreateURL, String otrsUserName, String otrsPassword, String otrsTicketId, String caseId){
		List<Case> caseList = new List<Case>();
		Httprequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(otrsTicketCreateURL);
        request.setHeader('Content-Type', Constants.CONTENT_TYPE_XML);
        
        String loginXMLAttributes = OTRSHandlerClass.loginXMLAttributes(otrsUserName, otrsPassword);
        String getInputXML = '<TicketGet>'+otrsTicketId+'</TicketGet>';
        String inputXML = OTRSHandlerClass.constructOTRSTicketGETInputXML(loginXMLAttributes+getInputXML);
       /* request.setBody(inputXML);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        XmlStreamReader reader = response.getXmlStreamReader();
        String resp = response.getBody();  */
        System.debug('======================================================>>>>>>>>>>>>>>>>>>>>>inputXML: '+inputXML);
        
        caseList.add(OTRSHandlerClass.outputXMLParser(Constants.outputXML, caseId));
		update caseList;
	}
}