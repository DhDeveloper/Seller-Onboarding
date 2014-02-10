global class SellerTATBreachBatchUpdateClass implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext BC){
                        
        String query = '    SELECT  Id,Invited_Start_Date__c FROM Opportunity';                     
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Opportunity> oppList = new List<Opportunity>();
        List<Seller_TAT_Breach__c> updateSellerList = new List<Seller_TAT_Breach__c>();
        List<Seller_TAT_Breach__c> sellerTATBreachList = new List<Seller_TAT_Breach__c>();
        
        List<Holiday> holidaysList = [Select h.ActivityDate From Holiday h];

        for(sObject s : scope){
            Opportunity opp = (Opportunity)s;
            updateSellerList = [SELECT  Id,Opportunity__c,Ideal_Closure_Date__c,
                                            Actual_Closure_Date__c,Next_Breach_Date__c,
                                            Estimated_Closure_Date__c,TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c,
                                            TAT_Stage_Profile_ID__r.TAT_Stage_ID__r.TAT_Stage__c
                              FROM    Seller_TAT_Breach__c where  Opportunity__c = :opp.Id order by Name];
            
            for(Integer i=0; i<updateSellerList.size() ;i++){
                if(updateSellerList.get(i).Actual_Closure_Date__c != null){
                    //if(updateSellerList.get(i).Actual_Closure_Date__c != updateSellerList.get(i).Ideal_Closure_Date__c){
                        
                        if(i != 0){
                            updateSellerList.get(i).Time_Taken_per_Stage__c = UtilityClass.daysBetweenExcludingSundaysHolidays( updateSellerList.get(i-1).Actual_Closure_Date__c, 
                                                                                                                                updateSellerList.get(i).Actual_Closure_Date__c, 
                                                                                                                                holidaysList);
                        }else{
                            Date tempDate = null;
                            
                            if(opp.Invited_Start_Date__c != null){
                                tempDate = opp.Invited_Start_Date__c;
                            }
                            
                            if(tempDate != null)
                            updateSellerList.get(i).Time_Taken_per_Stage__c = UtilityClass.daysBetweenExcludingSundaysHolidays( tempDate, 
                                                                                                                                updateSellerList.get(i).Actual_Closure_Date__c, 
                                                                                                                                holidaysList);
                        }
                    //}
                    
                    if(updateSellerList.get(i).Actual_Closure_Date__c != null){
                        if(updateSellerList.get(i).Actual_Closure_Date__c >= updateSellerList.get(i).Next_Breach_Date__c ){
                            updateSellerList.get(i).TAT_Breach_in_Days__c = UtilityClass.daysBetweenExcludingSundaysHolidays(   updateSellerList.get(i).Next_Breach_Date__c,
                                                                                                            updateSellerList.get(i).Actual_Closure_Date__c,
                                                                                                            holidaysList
                                                                                                        ) + 1;
                        }else{
                            updateSellerList.get(i).TAT_Breach_in_Days__c = 0;
                        }
                    }
                }
            }
            sellerTATBreachList.addAll(updateSellerList);
        }
    
        update sellerTATBreachList;
    }

    global void finish(Database.BatchableContext BC){
    
    }
}