/**
  * This Apex Trigger executes before updating records on Seller_TAT_Breach__c
  * The following actions occur
  * 1) Calculate TAT Breach in days and populate on the respective field
**/
trigger CalculateTATBreachTrigger on Seller_TAT_Breach__c (before update) {
    if(Trigger.isUpdate){
        Map<Id,Seller_TAT_Breach__c> oldMap = Trigger.oldMap;
        List<Holiday> holidaysList = [Select h.ActivityDate From Holiday h];
        
        for(Seller_TAT_Breach__c stb: Trigger.new){
            Seller_TAT_Breach__c oldSTB = oldMap.get(stb.Id);
            if(oldSTB.Actual_Closure_Date__c == null && stb.Actual_Closure_Date__c != null){
                if(stb.Actual_Closure_Date__c >= oldSTB.Next_Breach_Date__c ){
                    stb.TAT_Breach_in_Days__c = UtilityClass.daysBetweenExcludingSundaysHolidays(   oldSTB.Next_Breach_Date__c,
                                                                                                    stb.Actual_Closure_Date__c,
                                                                                                    holidaysList
                                                                                                ) + 1;
                }else{
                    stb.TAT_Breach_in_Days__c = 0;
                }
            }
        }
    }
}