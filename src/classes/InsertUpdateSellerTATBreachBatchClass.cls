global class InsertUpdateSellerTATBreachBatchClass implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext BC){
                        
        String query = 'SELECT  Id,Expected_TAT__c,Invited_Start_Date__c,Pending_min_SKU_Date__c,'+
        'Pending_min_Listings_Date__c,Pending_Seller_Approval_Date__c,Pending_Stock_Update_Date__c,Go_Live_Checklist_Date__c,Live_Date__c '+
        'FROM Opportunity where stageName not in(\'Candidate\',\'Ready to Onboard\',\'Ready to Invite\') and Invited_Start_Date__c != null ';                     
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Opportunity> oppList = new List<Opportunity>();
        List<Seller_TAT_Breach__c> updateSellList = new List<Seller_TAT_Breach__c>();
        List<Seller_TAT_Breach__c> sellerTATList = new List<Seller_TAT_Breach__c>();
        List<Seller_TAT_Breach__c> finalUpdateSellerList = new List<Seller_TAT_Breach__c> ();
        
        List<Holiday> holidaysList = [Select h.ActivityDate From Holiday h];
        List<TAT_Stage_Profile__c> TATStageProfileList = [SELECT Id,TAT_Profile_Spec__c,TAT_Profile_ID__r.TAT_Profile__c,
                                                             TAT_Stage_ID__r.Name,TAT_Stage_ID__r.TAT_Stage__c,
                                                             TAT_Profile_ID__r.Name
                                                      FROM TAT_Stage_Profile__c  where active__c = TRUE];

        List<TAT_Profile__c> tatProfileList = [SELECT Id, TAT_Profile__c FROM TAT_Profile__c];
        
        ID TAT_Profile_13_ID = null;
        ID TAT_Profile_18_ID = null;
        ID finalTATProfileId = null;
        
        for(TAT_Profile__c tat:tatProfileList){
            if((tat.TAT_Profile__c).contains(Constants.TAT_13)){
                TAT_Profile_13_ID = tat.Id;
            }else if((tat.TAT_Profile__c).contains(Constants.TAT_18)){
                TAT_Profile_18_ID = tat.Id;
            }
        }
        
        for(sObject s : scope){
            Opportunity opp = (Opportunity)s;
            updateSellList = [SELECT  Id,Opportunity__c,Ideal_Closure_Date__c,
                                            Actual_Closure_Date__c,Next_Breach_Date__c,
                                            Estimated_Closure_Date__c,TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c,
                                            TAT_Stage_Profile_ID__r.TAT_Stage_ID__r.TAT_Stage__c
                              FROM    Seller_TAT_Breach__c where  Opportunity__c = :opp.Id order by Name];
            
            if(updateSellList.size() == 0){
            	if(opp.Expected_TAT__c != null){
	                if(opp.Expected_TAT__c == Constants.TAT_13 || opp.Expected_TAT__c == Constants.TAT_15){
	                    finalTATProfileId = TAT_Profile_13_ID;
	                }else if(opp.Expected_TAT__c == Constants.TAT_18 || opp.Expected_TAT__c == Constants.TAT_25){
	                    finalTATProfileId = TAT_Profile_18_ID;
	                }
	            }
                Date actualStartDate = opp.Invited_Start_Date__c;
                Date closureDate = actualStartDate - 1;
                Date nextBreachDate;
                
                for(TAT_Stage_Profile__c tsp: TATStageProfileList){
                    if(tsp.TAT_Profile_ID__c == finalTATProfileId ){
                        System.debug('Should Create');
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
                if(sellerTATList.size() > 0){
		            insert sellerTATList;
		        }
            }
            
	        
            List<Seller_TAT_Breach__c> updateSellerList= [SELECT  Id,Opportunity__c,Ideal_Closure_Date__c,
		                                            Actual_Closure_Date__c,Next_Breach_Date__c,
		                                            Estimated_Closure_Date__c,TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c,
		                                            TAT_Stage_Profile_ID__r.TAT_Stage_ID__r.TAT_Stage__c
		                              FROM    Seller_TAT_Breach__c where  Opportunity__c = :opp.Id order by Name];
            
            
            if(updateSellerList.size()> 0){
    		for(Integer i=0; i<updateSellerList.size() ;i++){
    			Date nextBreachDateTemp = null; 
    			
    			String stageNameTAT = updateSellerList.get(i).TAT_Stage_Profile_ID__r.TAT_Stage_ID__r.TAT_Stage__c; 
        		
        		//Existing Data Considerations while uploading through data loader
               	if(stageNameTAT == Constants.OPP_STAGE_INVITED && opp.Pending_min_SKU_Date__c != null ){
               		updateSellerList.get(i).Actual_Closure_Date__c = opp.Pending_min_SKU_Date__c;
               	}else if(stageNameTAT == Constants.OPP_STAGE_MIN_SKU_CREATION && opp.Pending_min_Listings_Date__c != null ){
               		updateSellerList.get(i).Actual_Closure_Date__c = opp.Pending_min_Listings_Date__c;
               	}else if(stageNameTAT == Constants.OPP_STAGE_MIN_LISTINGS && opp.Pending_Seller_Approval_Date__c != null ){
               		updateSellerList.get(i).Actual_Closure_Date__c = opp.Pending_Seller_Approval_Date__c;
               	}else if(stageNameTAT == Constants.OPP_STAGE_SELLER_APPROVAL && opp.Pending_Stock_Update_Date__c != null ){
               		updateSellerList.get(i).Actual_Closure_Date__c = opp.Pending_Stock_Update_Date__c;
               	}else if(stageNameTAT == Constants.OPP_STAGE_STOCK_UPDATE && opp.Go_Live_Checklist_Date__c != null ){
               		updateSellerList.get(i).Actual_Closure_Date__c = opp.Go_Live_Checklist_Date__c;
               	}else if ((stageNameTAT == Constants.OPP_STAGE_LIVE || stageNameTAT == Constants.OPP_STAGE_GO_LIVE_CHECKLIST ) && opp.Live_Date__c != null){
               		updateSellerList.get(i).Actual_Closure_Date__c = opp.Live_Date__c;
               	}
                
                // Updates Next_Breach_Date,Estimated_Closure_Date on all Opportunity related 
                // Seller_TAT_Breach Object records if Actual_Closure_Date differs from Ideal_Closure_Date 
                if(i!=0 && updateSellerList.get(i-1).Actual_Closure_Date__c != null){
                    if(updateSellerList.get(i-1).Actual_Closure_Date__c != updateSellerList.get(i-1).Ideal_Closure_Date__c){
                        nextBreachDateTemp = UtilityClass.addDaysExcludingSundaysHolidays(updateSellerList.get(i-1).Actual_Closure_Date__c ,
                                                                                          Integer.valueOf(updateSellerList.get(i).TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c)+1,
                                                                                          holidaysList);
                    }
                } 
                updateSellerList = OpportunityHelperClass.recalculateNextBreachAndEstimatedClosureDates(i, nextBreachDateTemp, opp, updateSellerList, holidaysList);			
    		}
    		finalUpdateSellerList.addAll(updateSellerList);
            
        }
         update finalUpdateSellerList;
        }
	        
    }

    global void finish(Database.BatchableContext BC){
    
    }
}