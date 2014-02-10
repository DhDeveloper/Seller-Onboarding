/**
  * This Apex Trigger executes before updating records on Seller_TAT_Breach__c
  * The following actions occur
  * 1) Calculate TAT Breach in days and populate on the respective field
**/
trigger CalculateTATBreachTrigger on Seller_TAT_Breach__c (before update) {
    if(Trigger.isUpdate){
        Map<Id,Seller_TAT_Breach__c> oldMap = Trigger.oldMap;
        List<Holiday> holidaysList = [Select h.ActivityDate From Holiday h];
        
        List<Seller_TAT_Swimline__c> sellerTATSwimlineList = [	SELECT 	Id, Seller_TAT_Breach_ID__c, Swimline_Start_Date__c, Swimline_End_Date__c 
		                                     					FROM 	Seller_TAT_Swimline__c
		                                     					WHERE	Seller_TAT_Breach_ID__c IN :Trigger.new];
        
        for(Seller_TAT_Breach__c stb: Trigger.new){
			Integer swimlineDays = 0;
			
			if(sellerTATSwimlineList.size() > 0){
				for(Seller_TAT_Swimline__c swimline : sellerTATSwimlineList){
					if(swimline.Seller_TAT_Breach_ID__c == stb.Id && swimline.Swimline_End_Date__c != null){
						swimlineDays += UtilityClass.daysBetweenExcludingSundaysHolidays(swimline.Swimline_Start_Date__c,swimline.Swimline_End_Date__c,holidaysList)+1;
					}
				}
			}
			
            Seller_TAT_Breach__c oldSTB = oldMap.get(stb.Id);
            if(oldSTB.Actual_Closure_Date__c == null && stb.Actual_Closure_Date__c != null){
                if(stb.Actual_Closure_Date__c >= oldSTB.Next_Breach_Date__c ){
                    stb.TAT_Breach_in_Days__c = UtilityClass.daysBetweenExcludingSundaysHolidays(   oldSTB.Next_Breach_Date__c,
                                                                                                    stb.Actual_Closure_Date__c,
                                                                                                    holidaysList
                                                                                                ) + 1 - swimlineDays;
                }else{
                    stb.TAT_Breach_in_Days__c = 0;
                }
            }
        }
    }
}