/**
  * This Apex Class is helper class for Opportunity actions
**/
public class OpportunityHelperClass {
	
	/**
	  * This method returns TAT_Swimline__c Object Id
	  * @Param bdAction [1-In Progress, 2-Dropped, 3-Paused, 4-Training T1, 5-Training T2, 6-Training T3]
	  * @Param List<TAT_Swimline__c> -- Contains all TAT Swimline Records
	  * @return ID
	**/
	public static ID returnTATSwimlineID(Integer bdAction, List<TAT_Swimline__c> tatSwimlineList){
    	Map<Integer,String> tatSwimlineMapping = tatSwimlineMapping(tatSwimlineList);
    	ID tatSwimlineId = tatSwimlineMapping.get(bdAction);
    	return tatSwimlineId;
    }
    
    /**
      * This method returns Map collection of Integer to all TAT_Swimline__c Object Id
      * @Param List<TAT_Swimline__c> -- Contains all TAT Swimline Records
      * return Map<Integer,ID>
    **/
    public static Map<Integer,ID> tatSwimlineMapping(List<TAT_Swimline__c> tatSwimlineList){
    	Integer mapNumber = 0;
    	Map<Integer,ID> tatSwimlineMapping = new Map<Integer,String>();

    	// Temporary Mapping file and values would be
    	// 1-In Progress, 2-Dropped, 3-Paused, 4-Training T1, 5-Training T2, 6-Training T3
    	for(TAT_Swimline__c ts : tatSwimlineList){
    		tatSwimlineMapping.put(mapNumber,ts.Id);
    		mapNumber++;
    	}
    	return tatSwimlineMapping;
    }
    
    /**
      * This method recalculates Next Breach Dates and Estimated Closure Dates on change of Actual Closure Date
      * @Param i 					-- represnts Seller_TAT_Breach__c row
      * @Param nextBreachDateTemp 	-- Date for further calculation operations
      * @Param updateSellerList		-- List<Seller_TAT_Breach__c> of all records based on Opportunity
      * @Param holidaysList			-- List of all organizations holidays
      * @return List<Seller_TAT_Breach__c> -- final list to update Seller_TAT_Breach__c records
    **/
    public static List<Seller_TAT_Breach__c> recalculateNextBreachAndEstimatedClosureDates(	Integer i, 
    																						Date nextBreachDateTemp,
    																						Opportunity opp,
    																						List<Seller_TAT_Breach__c> updateSellerList,  
    																						List<Holiday> holidaysList){
    	if(updateSellerList.get(i).Actual_Closure_Date__c != null){
        	if(updateSellerList.get(i).Actual_Closure_Date__c != updateSellerList.get(i).Ideal_Closure_Date__c){
                updateSellerList.get(i).Estimated_Closure_Date__c = updateSellerList.get(i).Actual_Closure_Date__c;
                
                if(i != 0){
                    updateSellerList.get(i).Time_Taken_per_Stage__c = UtilityClass.daysBetweenExcludingSundaysHolidays(	updateSellerList.get(i-1).Actual_Closure_Date__c, 
                    																									updateSellerList.get(i).Actual_Closure_Date__c, 
                    																									holidaysList);
                }else{
                    // tempDate used to calculate Time taken to cross Invited Stage in data upload scenario
                    // for remaining scenarios it is consider Opportunity Last Modified Date -- Not exact calculation
                    Date tempDate;
                    
                    if(opp.Invited_Start_Date__c != null){
                    	tempDate = opp.Invited_Start_Date__c;
                    }else{
                    	tempDate = (opp.LastModifiedDate).date();
                    }
                    
                    updateSellerList.get(i).Time_Taken_per_Stage__c = UtilityClass.daysBetweenExcludingSundaysHolidays(	tempDate, 
                    																									updateSellerList.get(i).Actual_Closure_Date__c, 
                    																									holidaysList);
                }
            }
        }else{
            if(i != 0){
                if(nextBreachDateTemp == null){
                    updateSellerList.get(i).Next_Breach_Date__c = UtilityClass.addDaysExcludingSundaysHolidays(updateSellerList.get(i-1).Next_Breach_Date__c ,
                                                                                                               Integer.valueOf(updateSellerList.get(i).TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c),
                                                                                                               holidaysList);
                }else{
                    updateSellerList.get(i).Next_Breach_Date__c = nextBreachDateTemp;
                }
                updateSellerList.get(i).Estimated_Closure_Date__c = UtilityClass.addDaysExcludingSundaysHolidays(updateSellerList.get(i-1).Estimated_Closure_Date__c,
                                                                                                                 Integer.valueOf(updateSellerList.get(i).TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c),
                                                                                                                 holidaysList);
            }
        }
        
        return updateSellerList;
    }
    
    /**
      * This method recalculates Next Breach Dates and Estimated Closure Dates on basis of BD Actions and Training Reschedules
      * @Param i 					-- represnts Seller_TAT_Breach__c row
      * @Param actualDays			-- Actual Days need to calculate Next Breach Date
      * @Param endDateTemp 			-- Swimlinw End Date for further calculation operations
      * @Param updateSellerList		-- List<Seller_TAT_Breach__c> of all records based on Swimline Changes
      * @Param holidaysList			-- List of all organizations holidays
      * @return List<Seller_TAT_Breach__c> -- final list to update Seller_TAT_Breach__c records
    **/
    public static List<Seller_TAT_Breach__c> recalcNextBreachAndEstimatedClosureDates(	Integer i, 
    																					Integer actualDays,
    																					Date endDateTemp,
    																					Opportunity opp,
    																					List<Seller_TAT_Breach__c> updateSellerList,  
    																					List<Holiday> holidaysList){
        if(endDateTemp == null){
	        //To avoid Opportunity first stage record enter
	        if(i != 0){
            	updateSellerList.get(i).Next_Breach_Date__c = UtilityClass.addDaysExcludingSundaysHolidays(updateSellerList.get(i-1).Next_Breach_Date__c ,
	                                                                                                       Integer.valueOf(updateSellerList.get(i).TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c),
	                                                                                                       holidaysList);
				updateSellerList.get(i).Estimated_Closure_Date__c = UtilityClass.addDaysExcludingSundaysHolidays(updateSellerList.get(i-1).Estimated_Closure_Date__c,
	             	                                                                                             Integer.valueOf(updateSellerList.get(i).TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c),
	                                                                                                             holidaysList);
	        }                                                                                                                                                                                                                        
        }else{
            updateSellerList.get(i).Next_Breach_Date__c = UtilityClass.addDaysExcludingSundaysHolidays(endDateTemp, actualDays+1, holidaysList);
			updateSellerList.get(i).Estimated_Closure_Date__c = UtilityClass.addDaysExcludingSundaysHolidays(endDateTemp, actualDays, holidaysList);                                                                                                           
        }                                                                                                                
        
        return updateSellerList;
    }
}