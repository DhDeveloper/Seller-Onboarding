/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class MoveNextBreachDateTest {

     /**
      * Test method to test apex scheduler at 10 AM
    **/
    static testmethod void testScheduleAt10AM() {
        // Schedule runs Monday through Friday at 10 AM        
        String sch = '0 0 10 ? * MON-FRI'; 
        Test.startTest();
		Opportunity oppTest = UtilityClassTest.createOpportunityTestRecord();
        oppTest.StageName = 'Invited';
        update oppTest;
        
        List<Seller_TAT_Breach__c> sellerTATBreachList = [	SELECT 	Id, Opportunity__c, Ideal_Closure_Date__c, Actual_Closure_Date__c,
        															Next_Breach_Date__c, Estimated_Closure_Date__c,
        															Time_Taken_per_Stage__c, TAT_Breach_in_Days__c
        													FROM 	Seller_TAT_Breach__c
        													WHERE	Opportunity__c = :oppTest.Id];
    	
    	System.debug('<--Opportunity Stage Update Start-->');
    	Integer z = 0;
    	for(Seller_TAT_Breach__c stb : sellerTATBreachList){
			System.debug('Id: '+stb.Id+'\n Opportunity Id: '+stb.Opportunity__c+'\n Ideal Closure Date: '+stb.Ideal_Closure_Date__c);
			System.debug('Actual Closure Date: '+stb.Actual_Closure_Date__c+'\n Next Breach Date: '+stb.Next_Breach_Date__c);
			System.debug('Estimated Closure Date: '+stb.Estimated_Closure_Date__c);
			System.debug('Time Taken per Stage: '+stb.Time_Taken_per_Stage__c+'\n TAT Breach in Days: '+stb.TAT_Breach_in_Days__c);
			if(z==0){
				stb.Next_Breach_Date__c = Date.today()-1;
			}z++;
		} 
		update sellerTATBreachList;
        
        MoveNextBreachDateClass moveScheduleTest = new MoveNextBreachDateClass();
        system.schedule('Test Schedule', sch, moveScheduleTest);
      
        Test.stopTest(); 
    }
    
    /**
      * Test method to test apex scheduler at 4 PM
    **/
    static testmethod void testScheduleAt4PM() {
        // Schedule runs Monday through Friday at 4 PM        
        String sch = '0 0 16 ? * MON-FRI'; 
        Test.startTest();
		Opportunity oppTest = UtilityClassTest.createOpportunityTestRecord();
        oppTest.StageName = 'Invited';
        update oppTest;
        
        MoveNextBreachDateClass moveScheduleTest = new MoveNextBreachDateClass();
        system.schedule('Test Schedule', sch, moveScheduleTest);
      
        Test.stopTest(); 
    }
    
    @isTest(SeeAllData=true)
    static void onOppStageChangeTest(){
    	Opportunity opp = UtilityClassTest.createOpportunityTestRecord();
    	opp.Expected_TAT__c = Constants.TAT_13;
        opp.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
        update opp;
        
        opp.StageName = Constants.OPP_STAGE_INVITED;
        update opp;
    	
    	List<Seller_TAT_Breach__c> sellerTATBreachList = [	SELECT 	Id, Opportunity__c, Ideal_Closure_Date__c, Actual_Closure_Date__c,
        															Next_Breach_Date__c, Estimated_Closure_Date__c,
        															Time_Taken_per_Stage__c, TAT_Breach_in_Days__c
        													FROM 	Seller_TAT_Breach__c
        													WHERE	Opportunity__c = :opp.Id];
    	
    	System.debug('<--Opportunity Stage Update Start-->');
    	Integer z = 0;
    	for(Seller_TAT_Breach__c stb : sellerTATBreachList){
			System.debug('Id: '+stb.Id+'\n Opportunity Id: '+stb.Opportunity__c+'\n Ideal Closure Date: '+stb.Ideal_Closure_Date__c);
			System.debug('Actual Closure Date: '+stb.Actual_Closure_Date__c+'\n Next Breach Date: '+stb.Next_Breach_Date__c);
			System.debug('Estimated Closure Date: '+stb.Estimated_Closure_Date__c);
			System.debug('Time Taken per Stage: '+stb.Time_Taken_per_Stage__c+'\n TAT Breach in Days: '+stb.TAT_Breach_in_Days__c);
			if(z==0){
				stb.Next_Breach_Date__c = Date.today()-1;
			}z++;
		} 
		update sellerTATBreachList;
		
		Test.startTest();
		
		Date yestDay = Date.today()-1;
		
		List<Seller_TAT_Breach__c> updateSellerList;
    	List<Holiday> holidaysList = [Select h.ActivityDate From Holiday h];
    	List<Opportunity> oppSellerTATList = [	SELECT	Id,(	SELECT	Id,Opportunity__c,Ideal_Closure_Date__c,
						                                                Actual_Closure_Date__c,Next_Breach_Date__c,
						                                                Estimated_Closure_Date__c,TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c,
						                                                TAT_Stage_Profile_ID__r.TAT_Stage_ID__r.TAT_Stage__c
						                                        FROM    Opportunity.Seller_TAT_Breach__r 
						                                        order by Name) , CreatedDate
						                      	FROM 	Opportunity
                                        		WHERE   Id in  (	SELECT 	Opportunity__c 
                                        						FROM    Seller_TAT_Breach__c 
                                                            	WHERE 	Next_Breach_Date__c = :yestDay)];                                                            
    	
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
      
        Test.stopTest(); 
    }
}
}