/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
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
        oppTest.Expected_TAT__c = Constants.TAT_13;
        oppTest.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
        update oppTest;
        
        oppTest.StageName = Constants.OPP_STAGE_INVITED;
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
        oppTest.Expected_TAT__c = Constants.TAT_13;
        oppTest.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
        update oppTest;
        
        oppTest.StageName = Constants.OPP_STAGE_INVITED;
        update oppTest;
        
        MoveNextBreachDateClass moveScheduleTest = new MoveNextBreachDateClass();
        system.schedule('Test Schedule', sch, moveScheduleTest);
      
        Test.stopTest(); 
    }
    
    static testmethod void onOppStageChangeTest(){
    	List<Holiday> holidaysList = [Select h.ActivityDate From Holiday h];
    	Opportunity opp = UtilityClassTest.createOpportunityTestRecord();
    	opp.Expected_TAT__c = Constants.TAT_13;
        opp.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
        update opp;
        
        opp.StageName = Constants.OPP_STAGE_INVITED;
        update opp;
        
        TATHelperTest.createTATStageProfile18TestData();
    	List<TAT_Stage_Profile__c> TATStageProfileList = [SELECT Id,TAT_Profile_Spec__c,TAT_Profile_ID__r.TAT_Profile__c,
                                                             TAT_Stage_ID__r.Name,TAT_Stage_ID__r.TAT_Stage__c,
                                                             TAT_Profile_ID__r.Name
                                                      FROM TAT_Stage_Profile__c  where active__c = TRUE];
    	
    	List<Seller_TAT_Breach__c> sellerTATList = new List<Seller_TAT_Breach__c>();
        Date actualStartDate = Date.today();	
        Date closureDate = actualStartDate - 1;
        Date nextBreachDate;
        Integer i = 0;
        
        System.debug('TATStageProfileList Size:'+TATStageProfileList.size());
        
        for(TAT_Stage_Profile__c tsp: TATStageProfileList){
            closureDate = UtilityClass.addDaysExcludingSundaysHolidays(closureDate,
                                                                    Integer.valueOf(tsp.TAT_Profile_Spec__c),
                                                                    holidaysList);
            nextBreachDate = UtilityClass.addDaysExcludingSundaysHolidays(closureDate,1,holidaysList);
            Seller_TAT_Breach__c sellerTAT = new Seller_TAT_Breach__c();
            sellerTAT.TAT_Stage_Profile_ID__c = tsp.Id;
            sellerTAT.Opportunity__c = opp.Id;
            sellerTAT.Ideal_Closure_Date__c = closureDate;
            sellerTAT.Next_Breach_Date__c = nextBreachDate;
            if(i==0){
            	sellerTAT.Estimated_Closure_Date__c = Date.today() - 1;
            }else{
	            sellerTAT.Estimated_Closure_Date__c = closureDate;
            }i++;
            sellerTATList.add(sellerTAT);
        }
        insert sellerTATList;
        
        System.debug('sellerTATList Size:'+sellerTATList.size());
        
        if(sellerTATList.size() > 0){
        	for(Seller_TAT_Breach__c s: sellerTATList){
        		System.debug('Estimated Closure Date:'+s.Estimated_Closure_Date__c);
        	}
        }
        
        String sch = '0 0 23 ? * MON-FRI'; 
        Test.startTest();        
        MoveNextBreachDateClass moveScheduleTest = new MoveNextBreachDateClass();
        system.schedule('Test Schedule', sch, moveScheduleTest);
      
        Test.stopTest(); 
    	
	}
	
	static testmethod void onOppStageChangeTest2(){
    	List<Holiday> holidaysList = [Select h.ActivityDate From Holiday h];
    	Opportunity opp = UtilityClassTest.createOpportunityTestRecord();
    	opp.Expected_TAT__c = Constants.TAT_13;
        opp.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
        update opp;
        
        opp.StageName = Constants.OPP_STAGE_INVITED;
        update opp;
        
        TATHelperTest.createTATStageProfile18TestData();
    	List<TAT_Stage_Profile__c> TATStageProfileList = [SELECT Id,TAT_Profile_Spec__c,TAT_Profile_ID__r.TAT_Profile__c,
                                                             TAT_Stage_ID__r.Name,TAT_Stage_ID__r.TAT_Stage__c,
                                                             TAT_Profile_ID__r.Name
                                                      FROM TAT_Stage_Profile__c  where active__c = TRUE];
    	
    	List<Seller_TAT_Breach__c> sellerTATList = new List<Seller_TAT_Breach__c>();
        Date actualStartDate = Date.today();	
        Date closureDate = actualStartDate - 1;
        Date nextBreachDate;
        Integer i = 0;
        
        System.debug('TATStageProfileList Size:'+TATStageProfileList.size());
        
        for(TAT_Stage_Profile__c tsp: TATStageProfileList){
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
        insert sellerTATList;
        
        System.debug('sellerTATList Size:'+sellerTATList.size());
        
        if(sellerTATList.size() > 0){
        	for(Seller_TAT_Breach__c s: sellerTATList){
        		System.debug('Estimated Closure Date:'+s.Estimated_Closure_Date__c);
        		if(i==0){
        			s.Actual_Closure_Date__c = Date.today() - 20 ;
        		}if(i==1){
        			s.Estimated_Closure_Date__c = Date.today() - 1;
        		}i++;
        	}update sellerTATList;
        }
        
        String sch = '0 0 23 ? * MON-FRI'; 
        Test.startTest();        
        MoveNextBreachDateClass moveScheduleTest = new MoveNextBreachDateClass();
        system.schedule('Test Schedule', sch, moveScheduleTest);
      
        Test.stopTest(); 
    	
	}
}