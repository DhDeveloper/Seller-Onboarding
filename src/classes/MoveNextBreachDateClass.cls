global class MoveNextBreachDateClass implements Schedulable{
    global void execute(SchedulableContext ctx) {
    	List<Seller_TAT_Swimline__c> sellerTATSwimlineList = null;
    	List<Seller_TAT_Breach__c> finalUpdateSellerList = new List<Seller_TAT_Breach__c> ();
    	List<Holiday> holidaysList = [Select h.ActivityDate From Holiday h];
    	List<Opportunity> oppSellerTATList = [	SELECT	Id, CreatedDate, Invited_Start_Date__c
						                      	FROM 	Opportunity
                                        		WHERE   Id in (	SELECT 	Opportunity__c 
                                        						FROM    Seller_TAT_Breach__c 
                                                            	WHERE 	Estimated_Closure_Date__c < TODAY 
                                                            	AND 	Actual_Closure_Date__c = null)
                                                 AND stageName not in('Live')];
    	
    	List<Seller_TAT_Breach__c> sellerTATBreachList = [SELECT	Id,Opportunity__c,Ideal_Closure_Date__c,
								                                    Actual_Closure_Date__c,Next_Breach_Date__c,
								                                    Estimated_Closure_Date__c,TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c,
								                                    TAT_Stage_Profile_ID__r.TAT_Stage_ID__r.TAT_Stage__c,
								                                    (SELECT Id, Swimline_Start_Date__c, Swimline_End_Date__c 
								                                     FROM 	Seller_TAT_Breach__c.Seller_TAT_Swimline__r)
								                      		FROM    Seller_TAT_Breach__c 
								                      		WHERE  	Opportunity__c IN :oppSellerTATList ORDER BY Name];
    	
    	for(Opportunity opp : oppSellerTATList){
    		Date todayDate = Date.today();
    		Date yesterdayDate = Date.today() - 1;
	    	Date estimatedClosureDate = null;
	    	Date nextBreachDate = null;
	    	Integer timeTakenPerStage = 0;
	    	Integer tatBreachInDays = 0;
    		for(Integer i=0; i<sellerTATBreachList.size() ;i++){
    			if(sellerTATBreachList.get(i).Opportunity__c == opp.Id){
	    			sellerTATSwimlineList = sellerTATBreachList.get(i).Seller_TAT_Swimline__r;
					Integer swimlineDays = 0;
					
					if(sellerTATSwimlineList.size() > 0){
						for(Seller_TAT_Swimline__c swimline : sellerTATSwimlineList){
							if(swimline.Swimline_End_Date__c != null){
								swimlineDays += UtilityClass.daysBetweenExcludingSundaysHolidays(swimline.Swimline_Start_Date__c,swimline.Swimline_End_Date__c,holidaysList)+1;
							}
						}
					}
					if(estimatedClosureDate != null){
						sellerTATBreachList.get(i).Estimated_Closure_Date__c = UtilityClass.addDaysExcludingSundaysHolidays(sellerTATBreachList.get(i-1).Estimated_Closure_Date__c,
		                                                                                                         Integer.valueOf(sellerTATBreachList.get(i).TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c),
		                                                                                                         holidaysList);
						sellerTATBreachList.get(i).Next_Breach_Date__c = UtilityClass.addDaysExcludingSundaysHolidays(sellerTATBreachList.get(i-1).Next_Breach_Date__c ,
		                                                                                                       Integer.valueOf(sellerTATBreachList.get(i).TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c),
		                                                                                                       holidaysList);
					}else{
						if(i == 0 && sellerTATBreachList.get(i).Actual_Closure_Date__c == null && sellerTATBreachList.get(i).Estimated_Closure_Date__c < todayDate ){
							
							sellerTATBreachList.get(i).Estimated_Closure_Date__c = UtilityClass.addDaysExcludingSundaysHolidays(yesterdayDate, 1, holidaysList);
							sellerTATBreachList.get(i).Next_Breach_Date__c = UtilityClass.addDaysExcludingSundaysHolidays(sellerTATBreachList.get(i).Estimated_Closure_Date__c, 1, holidaysList);
							timeTakenPerStage = UtilityClass.daysBetweenExcludingSundaysHolidays(opp.Invited_Start_Date__c, sellerTATBreachList.get(i).Estimated_Closure_Date__c, holidaysList) + 1 - swimlineDays;
							tatBreachInDays = UtilityClass.daysBetweenExcludingSundaysHolidays(opp.Invited_Start_Date__c, sellerTATBreachList.get(i).Estimated_Closure_Date__c, holidaysList) + 1 
												- Integer.valueOf(sellerTATBreachList.get(i).TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c) - swimlineDays;
							
					 		if(timeTakenPerStage >= 0){
								sellerTATBreachList.get(i).Time_Taken_per_Stage__c = timeTakenPerStage;
							}
							
							if(tatBreachInDays >= 0){
								sellerTATBreachList.get(i).TAT_Breach_in_Days__c = tatBreachInDays;
							}
							estimatedClosureDate = sellerTATBreachList.get(i).Estimated_Closure_Date__c;
						}
						if(	i != 0 && sellerTATBreachList.get(i-1).Actual_Closure_Date__c != null && sellerTATBreachList.get(i).Actual_Closure_Date__c == null
						 	&& sellerTATBreachList.get(i).Estimated_Closure_Date__c < todayDate){
						 	
						 	sellerTATBreachList.get(i).Estimated_Closure_Date__c = UtilityClass.addDaysExcludingSundaysHolidays(yesterdayDate, 1, holidaysList);
							sellerTATBreachList.get(i).Next_Breach_Date__c = UtilityClass.addDaysExcludingSundaysHolidays(sellerTATBreachList.get(i).Estimated_Closure_Date__c, 1, holidaysList);
							timeTakenPerStage = UtilityClass.daysBetweenExcludingSundaysHolidays(sellerTATBreachList.get(i-1).Actual_Closure_Date__c, sellerTATBreachList.get(i).Estimated_Closure_Date__c, holidaysList) + 1 - swimlineDays;
							tatBreachInDays = UtilityClass.daysBetweenExcludingSundaysHolidays(sellerTATBreachList.get(i-1).Actual_Closure_Date__c, sellerTATBreachList.get(i).Estimated_Closure_Date__c, holidaysList) + 1 
												- Integer.valueOf(sellerTATBreachList.get(i).TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c) - swimlineDays;	
					 		
					 		if(timeTakenPerStage >= 0){
								sellerTATBreachList.get(i).Time_Taken_per_Stage__c = timeTakenPerStage;
							}
							
							if(tatBreachInDays >= 0){
								sellerTATBreachList.get(i).TAT_Breach_in_Days__c = tatBreachInDays;
							}
							estimatedClosureDate = sellerTATBreachList.get(i).Estimated_Closure_Date__c;
					 	}
					}
    			}
    		}
			//finalUpdateSellerList.addAll(sellerTATBreachList);
    	}
    	update sellerTATBreachList;
    }
}