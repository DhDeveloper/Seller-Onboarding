global class MoveNextBreachDateClass implements Schedulable{
    global void execute(SchedulableContext ctx) {
    	List<Seller_TAT_Breach__c> updateSellerList;
    	List<Holiday> holidaysList = [Select h.ActivityDate From Holiday h];
    	List<Opportunity> oppSellerTATList = [	SELECT	Id,(	SELECT	Id,Opportunity__c,Ideal_Closure_Date__c,
						                                                Actual_Closure_Date__c,Next_Breach_Date__c,
						                                                Estimated_Closure_Date__c,TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c,
						                                                TAT_Stage_Profile_ID__r.TAT_Stage_ID__r.TAT_Stage__c
						                                        FROM    Opportunity.Seller_TAT_Breach__r 
						                                        order by Name) , CreatedDate
						                      	FROM 	Opportunity
                                        		WHERE   Id in (	SELECT 	Opportunity__c 
                                        						FROM    Seller_TAT_Breach__c 
                                                            	WHERE 	Next_Breach_Date__c = YESTERDAY)];                                                            
    	
    	for(Opportunity tempOpp: oppSellerTATList){
			updateSellerList = tempOpp.Seller_TAT_Breach__r;
    		
    		for(Integer i=0; i<updateSellerList.size() ;i++){
    			Date nextBreachDateTemp = null;  
        
                // Updates Next_Breach_Date,Estimated_Closure_Date on all Opportunity related 
                // Seller_TAT_Breach Object records if Actual_Closure_Date differs from Ideal_Closure_Date 
                if(i!=0 && updateSellerList.get(i-1).Actual_Closure_Date__c != null){
                    if(updateSellerList.get(i-1).Actual_Closure_Date__c != updateSellerList.get(i-1).Ideal_Closure_Date__c){
                        nextBreachDateTemp = UtilityClass.addDaysExcludingSundaysHolidays(updateSellerList.get(i-1).Actual_Closure_Date__c ,
                                                                                          Integer.valueOf(updateSellerList.get(i).TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c)+1,
                                                                                          holidaysList);
                    }
                } 
                updateSellerList = OpportunityHelperClass.recalculateNextBreachAndEstimatedClosureDates(i, nextBreachDateTemp, tempOpp, updateSellerList, holidaysList);			
    		}
        }
    }
}