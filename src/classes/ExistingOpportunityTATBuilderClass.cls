global class ExistingOpportunityTATBuilderClass implements Schedulable{
    global void execute(SchedulableContext ctx) {
        List<Opportunity> oppList = [	SELECT 	Id, StageName,Expected_TAT__c   
        								FROM	Opportunity
        								WHERE	StageName NOT IN ('Candidate', 'Ready to Onboard', 'Ready to Invite', 'Live')];        															
		        															
        List<Seller_TAT_Breach__c> sellerTATBreachList = [	SELECT	Id, Opportunity__c
        													FROM	Seller_TAT_Breach__c];
		
		List<Seller_TAT_Breach__c> sellerTATList = new List<Seller_TAT_Breach__c> ();
        List<Holiday> holidaysList = [Select h.ActivityDate From Holiday h];        													
        													
		List<TAT_Stage_Profile__c> TATStageProfileList = [SELECT Id,TAT_Profile_Spec__c,TAT_Profile_ID__r.TAT_Profile__c,
                                                             TAT_Stage_ID__r.Name,TAT_Stage_ID__r.TAT_Stage__c,
                                                             TAT_Profile_ID__r.Name
                                                      FROM TAT_Stage_Profile__c  where active__c = TRUE];        													
        													
        List<Opportunity> oppTATList = new List<Opportunity>();
        
        for(Opportunity opp : oppList){
        	Integer tatCounter = 0;
        	for(Seller_TAT_Breach__c stb : sellerTATBreachList ){
        		if(opp.Id == stb.Opportunity__c){
        			tatCounter++;
        		}
        	}
        	if(tatCounter == 0){
        		oppTATList.add(opp);		
        	}
        }						
        
        if(oppTATList.size() > 0){
        	List<TAT_Profile__c> tatProfileList = [SELECT Id, TAT_Profile__c FROM TAT_Profile__c];
		
			ID TAT_Profile_13_ID = null;
			ID TAT_Profile_18_ID = null;
			
			for(TAT_Profile__c tat:tatProfileList){
				if((tat.TAT_Profile__c).contains(Constants.TAT_13)){
					TAT_Profile_13_ID = tat.Id;
				}else if((tat.TAT_Profile__c).contains(Constants.TAT_18)){
					TAT_Profile_18_ID = tat.Id;
				}
			}
			
        	for(Opportunity opp : oppTATList){
        		Date actualStartDate = Date.today();//
	            Date closureDate = actualStartDate - 1;
	            Date nextBreachDate;
	            
        		ID TAT_Profile_ID = null;
        		
        		if(opp.Expected_TAT__c != null){
					if(opp.Expected_TAT__c == Constants.TAT_13 || opp.Expected_TAT__c == Constants.TAT_15){
						TAT_Profile_ID = TAT_Profile_13_ID;
					}else if(opp.Expected_TAT__c == Constants.TAT_18 || opp.Expected_TAT__c == Constants.TAT_25){
						TAT_Profile_ID = TAT_Profile_18_ID;
					}
	        		
	        		for(TAT_Stage_Profile__c tsp: TATStageProfileList){
	        			if(tsp.TAT_Profile_ID__c == TAT_Profile_ID ){
			                closureDate = UtilityClass.addDaysExcludingSundaysHolidays(closureDate,
			                                                                        Integer.valueOf(tsp.TAT_Profile_Spec__c),
			                                                                        holidaysList);
			                nextBreachDate = UtilityClass.addDaysExcludingSundaysHolidays(closureDate,1,holidaysList);
			                Seller_TAT_Breach__c sellerTAT = new Seller_TAT_Breach__c();
			                sellerTAT.TAT_Stage_Profile_ID__c = tsp.Id;
			                sellerTAT.Opportunity__c = opp.Id;
			                sellerTAT.Ideal_Closure_Date__c = closureDate;
			                sellerTAT.Next_Breach_Date__c = nextBreachDate;
			                sellerTAT.Estimated_Closure_Date__c = closureDate;
			                sellerTATList.add(sellerTAT);
		            	}
	        		}
        		}
        	}
            insert sellerTATList;
        }
    }
}