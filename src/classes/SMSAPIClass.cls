global class SMSAPIClass {
	
	@future(callout=true)
	public static void SendBulkInvitesToSellers(String jsonString){
		
		/*Httprequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(jsonString);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        String resp = response.getBody(); 
        //System.debug('resp: '+resp);*/
        
        String resp = '{"Seller":[{"sfdcId":"006O0000003wHsNIAU","sellerEmail": "seller@seller.com","status": "sent"},{"sfdcId":"006O0000003wHsXIAU","sellerEmail": "seller1@seller.com","status": "sent"}]}';
        
        JSONParser parser = JSON.createParser(resp);
       	String oppId = null;
       	Set<ID> oppIdSet = new Set<ID>();
       	
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'sfdcId')) {
                parser.nextToken();
                oppId = parser.getText();
            }
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'status')) {
                parser.nextToken();
                if(parser.getText() == 'sent'){
                	oppIdSet.add(oppId);
                	oppId = null;
                }
            }
        }
        
        List<Opportunity> oppList = [SELECT Id, Name, StageName, Is_Invited__c FROM Opportunity WHERE Id in :oppIdSet];
        
        for(Opportunity opp:oppList){
        	opp.StageName = Constants.OPP_STAGE_INVITED;
        	opp.Is_Invited__c = 0;
        	System.debug('Opp Name'+opp.Name);
        }
        
        update oppList;
	}
	
	webservice static void getBulkInvitedOpportunityIDs(ID[] oppIds){
		
		List<Opportunity> oppList = [	SELECT 	Id,Seller_Name__c,Seller_Registration_Email__c,Owner.email, Owner.name
										FROM	Opportunity
										WHERE	Id in :oppIds];
		
		JSONGenerator jsonGenerator = JSON.createGenerator(true);
		
		//Root JSON Object start
		//jsonGenerator.writeStartObject();
		jsonGenerator.writeString('Sellers Data');
		jsonGenerator.writeStartArray();
		for(Opportunity opp:oppList){
			jsonGenerator.writeStartObject();
				jsonGenerator.writeStringField('sfdcId',opp.Id);
				jsonGenerator.writeStringField('sellerEmail', opp.Seller_Registration_Email__c!= null?opp.Seller_Registration_Email__c:'');
				jsonGenerator.writeStringField('sellerName', opp.Seller_Name__c != null?opp.Seller_Name__c:'');
				jsonGenerator.writeStringField('managerEmail', opp.Owner.email!= null?opp.Owner.email:'');
				jsonGenerator.writeStringField('managerName', opp.Owner.name!= null?opp.Owner.name:'');
				jsonGenerator.writeFieldName('ccList');
					jsonGenerator.writeStartArray();
			        	jsonGenerator.writeStartObject();
				        	jsonGenerator.writeStringField('email', opp.Owner.email!= null?opp.Owner.email:'');
							jsonGenerator.writeStringField('name', opp.Owner.name!= null?opp.Owner.name:'');
			        	jsonGenerator.writeEndObject();
					jsonGenerator.writeEndArray();
			jsonGenerator.writeEndObject();
		}
		jsonGenerator.writeEndArray();
		
		//Root JSON Object end
		//jsonGenerator.writeEndObject();
		
		String jsonString = jsonGenerator.getAsString();
		
		SendBulkInvitesToSellers(jsonString);
	}

}