/**
  * This Apex Class is helper class to OTRSControllerClass
**/
public with sharing class OTRSHandlerClass {
		
	public static String constructOTRSTicketCreateInputXML(String inputXMLString){
		String inputXML = Constants.SOAP_HEADER + Constants.TICKET_CREATE_HEADER + inputXMLString + Constants.TICKET_CREATE_FOOTER + Constants.SOAP_FOOTER;
 
        return inputXML;
	}
	
	public static String constructOTRSTicketGetInputXML(String inputXMLString){
		String inputXML = Constants.SOAP_HEADER + Constants.TICKET_GET_HEADER + inputXMLString + Constants.TICKET_GET_FOOTER + Constants.SOAP_FOOTER;
 
        return inputXML;
	}
	
	public static Map<Id,String> createOTRSTicketFromCase(List<String> serializedCaseList){
		Map<Id,String> finalList = new Map<Id,String>();
		CaseHelperClass caseHelper = null;
		Map<String,String> inputXMLMap = null; 
		
		for(String caseObj : serializedCaseList){
			caseHelper = (CaseHelperClass)JSON.deserialize(caseObj, CaseHelperClass.class);
			inputXMLMap = new Map<String,String>();
			
			String queue = caseHelper.issueType != null ? Constants.QUEUE_NAMES_MAP.get(caseHelper.issueType) : '';
			
			inputXMLMap.put(Constants.OTRS_ATTRIBUTE_TITLE,'[SF | Seller On-boarding | '+caseHelper.sellerRegEmail+' | '+caseHelper.subject+']');
			inputXMLMap.put(Constants.OTRS_ATTRIBUTE_QUEUE, queue);
			inputXMLMap.put(Constants.OTRS_ATTRIBUTE_TYPE, Constants.OTRS_ATTRIBUTE_TYPE_VALUE);
			inputXMLMap.put(Constants.OTRS_ATTRIBUTE_STATE,caseHelper.Status);
			inputXMLMap.put(Constants.OTRS_ATTRIBUTE_PRIORITY,caseHelper.Priority);
			inputXMLMap.put(Constants.OTRS_ATTRIBUTE_CUSTOMERUSER,caseHelper.Email);
			
			String subStructureOne = constructSubPartsXML(inputXMLMap, Constants.OTRS_ATTRIBUTE_TICKET);
			
			inputXMLMap = new Map<String,String>();
			
			inputXMLMap.put(Constants.OTRS_ATTRIBUTE_ARTICLETYPE,caseHelper.origin);
			inputXMLMap.put(Constants.OTRS_ATTRIBUTE_SENDERTYPE, Constants.OTRS_ATTRIBUTE_SENDERTYPE_VALUE);
			inputXMLMap.put(Constants.OTRS_ATTRIBUTE_FROM,caseHelper.email);
			inputXMLMap.put(Constants.OTRS_ATTRIBUTE_SUBJECT,caseHelper.subject);
			inputXMLMap.put(Constants.OTRS_ATTRIBUTE_BODY,caseHelper.Description);
			inputXMLMap.put(Constants.OTRS_ATTRIBUTE_CONTENTTYPE, Constants.OTRS_ATTRIBUTE_CONTENTTYPE_VALUE);
			
			String subStructureTwo = constructSubPartsXML(inputXMLMap, Constants.OTRS_ATTRIBUTE_ARTICLE);
			
			finalList.put(caseHelper.caseId,subStructureOne+subStructureTwo);
		}		
		return finalList;
	}
	
	public static String loginXMLAttributes(String otrsUserName, String otrsPassword){
		String loginXMLAttributes = '';
		
        loginXMLAttributes += '<'+Constants.OTRS_ATTRIBUTE_LOGIN+'>';
        loginXMLAttributes += otrsUserName;
        loginXMLAttributes += '<'+Constants.OTRS_ATTRIBUTE_LOGIN+'>';
        
        loginXMLAttributes += '<'+Constants.OTRS_ATTRIBUTE_PASSWORD+'>';
        loginXMLAttributes += otrsPassword;
        loginXMLAttributes += '<'+Constants.OTRS_ATTRIBUTE_PASSWORD+'>';
	      
		return loginXMLAttributes;
	}
	
	public static String constructSubPartsXML(Map<String,String> inputXMLMap, String subAttribute){
		String inputXML = '<'+subAttribute+'>';
		
		if(inputXMLMap.size()>0){
	        for(String attribute: inputXMLMap.keyset()){
	            inputXML += '<'+attribute+'>';
	            inputXML += inputXMLMap.get(attribute);
	            inputXML += '</'+attribute+'>';
	      	}
		}
	      
     	inputXML += '</'+subAttribute+'>';
	      
		return inputXML;
	}
	
	public static Case outputXMLParser(String outputXML, String caseId){
		String xmlString = Constants.outputXML;
		XmlStreamReader reader = new XmlStreamReader(xmlString);
		
		Case caseObj = new Case();
		caseObj.Id = caseId;
		
		while(reader.hasNext()) {
	         if (reader.getEventType() == XmlTag.START_ELEMENT) {
	         	
	         	if('TicketId' == reader.getLocalName()){
	         		caseObj.OTRS_Ticket_ID__c = OTRSHandlerClass.getAttributeValue(reader);
	         	}
	         	
	         	if('TicketNumber' == reader.getLocalName()){
	         		caseObj.OTRS_Ticket_Number__c = OTRSHandlerClass.getAttributeValue(reader);
	         	}
	         	
	         	/* Following locales only available in getOTRS call*/
	         	if('Queue' == reader.getLocalName()){
	         		caseObj.Issue_Type__c = OTRSHandlerClass.getAttributeValue(reader);
	         	}
	         	
	         	if('State' == reader.getLocalName()){
	         		caseObj.Status = OTRSHandlerClass.getAttributeValue(reader);
	         	}
	         }
	        reader.next();
	     }
	     
	     return caseObj;
	}
	
	public static String getAttributeValue(XmlStreamReader reader){
		String attributeValue = null;
		
		while(reader.hasNext()) {
	        if (reader.getEventType() == XmlTag.END_ELEMENT) {
	           break;
	        } else if (reader.getEventType() == XmlTag.CHARACTERS) {
	           attributeValue = reader.getText();
	        }
	        reader.next();
	     }
	     
	     return attributeValue;
	}
}