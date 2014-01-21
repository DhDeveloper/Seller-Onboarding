/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class OpportunityScenariosTest {
	
	@isTest(SeeAllData=true)
    static void sellerTATBreachInsertTest() {
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
		for(Seller_TAT_Breach__c stb : sellerTATBreachList){
			System.debug('Id: '+stb.Id+'\n Opportunity Id: '+stb.Opportunity__c+'\n Ideal Closure Date: '+stb.Ideal_Closure_Date__c);
			System.debug('Actual Closure Date: '+stb.Actual_Closure_Date__c+'\n Next Breach Date: '+stb.Next_Breach_Date__c);
			System.debug('Estimated Closure Date: '+stb.Estimated_Closure_Date__c);
			System.debug('Time Taken per Stage: '+stb.Time_Taken_per_Stage__c+'\n TAT Breach in Days: '+stb.TAT_Breach_in_Days__c);
		}
        
        opp.Expected_TAT__c = Constants.TAT_13;
        update opp;
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
    	for(Seller_TAT_Breach__c stb : sellerTATBreachList){
			System.debug('Id: '+stb.Id+'\n Opportunity Id: '+stb.Opportunity__c+'\n Ideal Closure Date: '+stb.Ideal_Closure_Date__c);
			System.debug('Actual Closure Date: '+stb.Actual_Closure_Date__c+'\n Next Breach Date: '+stb.Next_Breach_Date__c);
			System.debug('Estimated Closure Date: '+stb.Estimated_Closure_Date__c);
			System.debug('Time Taken per Stage: '+stb.Time_Taken_per_Stage__c+'\n TAT Breach in Days: '+stb.TAT_Breach_in_Days__c);
		} 
		System.debug('<--Opportunity Stage Update End-->');
		
		opp.Seller_Id__c = 'Test Seller';
		update opp;
		
		sellerTATBreachList = [	SELECT 	Id, Opportunity__c, Ideal_Closure_Date__c, Actual_Closure_Date__c,
										Next_Breach_Date__c, Estimated_Closure_Date__c,
										Time_Taken_per_Stage__c, TAT_Breach_in_Days__c
								FROM 	Seller_TAT_Breach__c
								WHERE	Opportunity__c = :opp.Id];
		
		System.debug('<--Opportunity Seller Id Update Start-->');
		for(Seller_TAT_Breach__c stb : sellerTATBreachList){
			System.debug('Id: '+stb.Id+'\n Opportunity Id: '+stb.Opportunity__c+'\n Ideal Closure Date: '+stb.Ideal_Closure_Date__c);
			System.debug('Actual Closure Date: '+stb.Actual_Closure_Date__c+'\n Next Breach Date: '+stb.Next_Breach_Date__c);
			System.debug('Estimated Closure Date: '+stb.Estimated_Closure_Date__c);
			System.debug('Time Taken per Stage: '+stb.Time_Taken_per_Stage__c+'\n TAT Breach in Days: '+stb.TAT_Breach_in_Days__c);
		} 
		System.debug('<--Opportunity Seller Id Update End-->');
    }
    
    @isTest(SeeAllData=true)
    static void oppUpdateBDActionDrop() {
        Opportunity opp = UtilityClassTest.createOpportunityTestRecord();
        opp.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
    	update opp;
    	
    	opp.StageName = 'Invited';
    	update opp;
    	
        opp.BD_Action__c = Constants.BD_ACTION_DROP ;
        opp.BD_Comments__c = 'No response from seller';
        update opp;
        
        List<Seller_TAT_Breach__c> sellerTATBreachList = [	SELECT 	Id, Opportunity__c, Ideal_Closure_Date__c, Actual_Closure_Date__c,
        															Next_Breach_Date__c, Estimated_Closure_Date__c,
        															Time_Taken_per_Stage__c, TAT_Breach_in_Days__c
        													FROM 	Seller_TAT_Breach__c
        													WHERE	Opportunity__c = :opp.Id];
        
        List<Seller_TAT_Swimline__c> sellerTATSwimlineList = [	SELECT 	Id, Seller_TAT_Breach_ID__c, TAT_Swimline_ID__c,
        															Swimline_Start_Date__c, Swimline_End_Date__c, Comments__c
        													FROM	Seller_TAT_Swimline__c
        													WHERE 	Seller_TAT_Breach_ID__c IN :sellerTATBreachList];
        
        System.debug('<--Opportunity BD Actions Update Start-->');
		for(Seller_TAT_Breach__c stb : sellerTATBreachList){
			System.debug('Id: '+stb.Id+'\n Opportunity Id: '+stb.Opportunity__c+'\n Ideal Closure Date: '+stb.Ideal_Closure_Date__c);
			System.debug('Actual Closure Date: '+stb.Actual_Closure_Date__c+'\n Next Breach Date: '+stb.Next_Breach_Date__c);
			System.debug('Estimated Closure Date: '+stb.Estimated_Closure_Date__c);
			System.debug('Time Taken per Stage: '+stb.Time_Taken_per_Stage__c+'\n TAT Breach in Days: '+stb.TAT_Breach_in_Days__c);
		}        											
		System.debug('<--Opportunity BD Actions Update End-->');
		
		System.debug('<--Seller TAT Swimline Start-->');
		for(Seller_TAT_Swimline__c stb : sellerTATSwimlineList){
			System.debug('Id: '+stb.Id+'\n Seller TAT Breach ID: '+stb.Seller_TAT_Breach_ID__c+'\n TAT Swimline ID: '+stb.TAT_Swimline_ID__c);
			System.debug('Swimline Start Date: '+stb.Swimline_Start_Date__c+'\n Swimline End Date: '+stb.Swimline_End_Date__c);
			System.debug('Comments: '+stb.Comments__c);
		}        											
		System.debug('<--Seller TAT Swimline End-->');
    }
    
    @isTest(SeeAllData=true)
    static void oppUpdateBDActionPause() {
        Opportunity opp = UtilityClassTest.createOpportunityTestRecord();
        opp.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
    	update opp;
    	
    	opp.StageName = 'Invited';
    	update opp;
    	
        opp.BD_Action__c = Constants.BD_ACTION_PAUSE;
        opp.BD_Comments__c = 'No response from seller';
        opp.Revisit_Date__c = Date.today() + 4;
        update opp;
        
        List<Seller_TAT_Breach__c> sellerTATBreachList = [	SELECT 	Id, Opportunity__c, Ideal_Closure_Date__c, Actual_Closure_Date__c,
        															Next_Breach_Date__c, Estimated_Closure_Date__c,
        															Time_Taken_per_Stage__c, TAT_Breach_in_Days__c
        													FROM 	Seller_TAT_Breach__c
        													WHERE	Opportunity__c = :opp.Id];
        
        List<Seller_TAT_Swimline__c> sellerTATSwimlineList = [	SELECT 	Id, Seller_TAT_Breach_ID__c, TAT_Swimline_ID__c,
        															Swimline_Start_Date__c, Swimline_End_Date__c, Comments__c
        													FROM	Seller_TAT_Swimline__c
        													WHERE 	Seller_TAT_Breach_ID__c IN :sellerTATBreachList];
        
        System.debug('<--Opportunity BD Actions Update Start-->');
		for(Seller_TAT_Breach__c stb : sellerTATBreachList){
			System.debug('Id: '+stb.Id+'\n Opportunity Id: '+stb.Opportunity__c+'\n Ideal Closure Date: '+stb.Ideal_Closure_Date__c);
			System.debug('Actual Closure Date: '+stb.Actual_Closure_Date__c+'\n Next Breach Date: '+stb.Next_Breach_Date__c);
			System.debug('Estimated Closure Date: '+stb.Estimated_Closure_Date__c);
			System.debug('Time Taken per Stage: '+stb.Time_Taken_per_Stage__c+'\n TAT Breach in Days: '+stb.TAT_Breach_in_Days__c);
		}        											
		System.debug('<--Opportunity BD Actions Update End-->');
		
		System.debug('<--Seller TAT Swimline Start-->');
		for(Seller_TAT_Swimline__c stb : sellerTATSwimlineList){
			System.debug('Id: '+stb.Id+'\n Seller TAT Breach ID: '+stb.Seller_TAT_Breach_ID__c+'\n TAT Swimline ID: '+stb.TAT_Swimline_ID__c);
			System.debug('Swimline Start Date: '+stb.Swimline_Start_Date__c+'\n Swimline End Date: '+stb.Swimline_End_Date__c);
			System.debug('Comments: '+stb.Comments__c);
		}        											
		System.debug('<--Seller TAT Swimline End-->');
    }
    
 	@isTest(SeeAllData=true)
    static void oppUpdateDelayReason() {
        Opportunity opp = UtilityClassTest.createOpportunityTestRecord();
        opp.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
    	update opp;
    	
    	opp.StageName = 'Invited';
    	update opp;
    	
        opp.Delay_Reasons__c = Constants.DELAY_REASON_SELLER_NOT_REACHABLE;
        opp.Attempts_Or_Delay_Days__c = '2';
        opp.Delay_Description__c = 'Attempted 2 times this day';
        update opp;
        
        List<Seller_TAT_Breach__c> sellerTATBreachList = [	SELECT 	Id, Opportunity__c, Ideal_Closure_Date__c, Actual_Closure_Date__c,
        															Next_Breach_Date__c, Estimated_Closure_Date__c,
        															Time_Taken_per_Stage__c, TAT_Breach_in_Days__c
        													FROM 	Seller_TAT_Breach__c
        													WHERE	Opportunity__c = :opp.Id];
        
        List<Seller_TAT_Swimline__c> sellerTATSwimlineList = [	SELECT 	Id, Seller_TAT_Breach_ID__c, TAT_Swimline_ID__c,
        															Swimline_Start_Date__c, Swimline_End_Date__c, Comments__c
        													FROM	Seller_TAT_Swimline__c
        													WHERE 	Seller_TAT_Breach_ID__c IN :sellerTATBreachList];
        
        System.debug('<--Opportunity Delay Actions Update Start-->');
		for(Seller_TAT_Breach__c stb : sellerTATBreachList){
			System.debug('Id: '+stb.Id+'\n Opportunity Id: '+stb.Opportunity__c+'\n Ideal Closure Date: '+stb.Ideal_Closure_Date__c);
			System.debug('Actual Closure Date: '+stb.Actual_Closure_Date__c+'\n Next Breach Date: '+stb.Next_Breach_Date__c);
			System.debug('Estimated Closure Date: '+stb.Estimated_Closure_Date__c);
			System.debug('Time Taken per Stage: '+stb.Time_Taken_per_Stage__c+'\n TAT Breach in Days: '+stb.TAT_Breach_in_Days__c);
		}        											
		System.debug('<--Opportunity Delay Actions Update End-->');
		
		System.debug('<--Seller TAT Swimline Start-->');
		for(Seller_TAT_Swimline__c stb : sellerTATSwimlineList){
			System.debug('Id: '+stb.Id+'\n Seller TAT Breach ID: '+stb.Seller_TAT_Breach_ID__c+'\n TAT Swimline ID: '+stb.TAT_Swimline_ID__c);
			System.debug('Swimline Start Date: '+stb.Swimline_Start_Date__c+'\n Swimline End Date: '+stb.Swimline_End_Date__c);
			System.debug('Comments: '+stb.Comments__c);
		}        											
		System.debug('<--Seller TAT Swimline End-->');
		
		opp.Delay_Reasons__c = Constants.DELAY_REASON_SELLER_NEED_MORE_TIME;
        opp.Attempts_Or_Delay_Days__c = '2';
        opp.Delay_Description__c = 'Need More Time';
        update opp;
        
        System.debug(Constants.DELAY_REASON_SELLER_NOT_REACHABLE+' - '+opp.Seller_Not_Reachable__c);
        System.debug(Constants.DELAY_REASON_SELLER_NEED_MORE_TIME+' - '+opp.Seller_Need_More_Time__c);
        System.debug(Constants.DELAY_REASON_OTHER+' - '+opp.Others__c);
        
        sellerTATBreachList = [	SELECT 	Id, Opportunity__c, Ideal_Closure_Date__c, Actual_Closure_Date__c,
        															Next_Breach_Date__c, Estimated_Closure_Date__c,
        															Time_Taken_per_Stage__c, TAT_Breach_in_Days__c
        													FROM 	Seller_TAT_Breach__c
        													WHERE	Opportunity__c = :opp.Id];
        
        sellerTATSwimlineList = [	SELECT 	Id, Seller_TAT_Breach_ID__c, TAT_Swimline_ID__c,
        															Swimline_Start_Date__c, Swimline_End_Date__c, Comments__c
        													FROM	Seller_TAT_Swimline__c
        													WHERE 	Seller_TAT_Breach_ID__c IN :sellerTATBreachList];
        
        System.debug('<--Opportunity Delay Actions Update Start-->');
		for(Seller_TAT_Breach__c stb : sellerTATBreachList){
			System.debug('Id: '+stb.Id+'\n Opportunity Id: '+stb.Opportunity__c+'\n Ideal Closure Date: '+stb.Ideal_Closure_Date__c);
			System.debug('Actual Closure Date: '+stb.Actual_Closure_Date__c+'\n Next Breach Date: '+stb.Next_Breach_Date__c);
			System.debug('Estimated Closure Date: '+stb.Estimated_Closure_Date__c);
			System.debug('Time Taken per Stage: '+stb.Time_Taken_per_Stage__c+'\n TAT Breach in Days: '+stb.TAT_Breach_in_Days__c);
		}        											
		System.debug('<--Opportunity Delay Actions Update End-->');
		
		System.debug('<--Seller TAT Swimline Start-->');
		for(Seller_TAT_Swimline__c stb : sellerTATSwimlineList){
			System.debug('Id: '+stb.Id+'\n Seller TAT Breach ID: '+stb.Seller_TAT_Breach_ID__c+'\n TAT Swimline ID: '+stb.TAT_Swimline_ID__c);
			System.debug('Swimline Start Date: '+stb.Swimline_Start_Date__c+'\n Swimline End Date: '+stb.Swimline_End_Date__c);
			System.debug('Comments: '+stb.Comments__c);
		}        											
		System.debug('<--Seller TAT Swimline End-->');
		
		
		opp.Delay_Reasons__c = Constants.DELAY_REASON_OTHER;
        opp.Attempts_Or_Delay_Days__c = '3';
        opp.Delay_Description__c = 'Not Interested now';
        update opp;
        
        System.debug(Constants.DELAY_REASON_SELLER_NOT_REACHABLE+' - '+opp.Seller_Not_Reachable__c);
        System.debug(Constants.DELAY_REASON_SELLER_NEED_MORE_TIME+' - '+opp.Seller_Need_More_Time__c);
        System.debug(Constants.DELAY_REASON_OTHER+' - '+opp.Others__c);
        
        sellerTATBreachList = [	SELECT 	Id, Opportunity__c, Ideal_Closure_Date__c, Actual_Closure_Date__c,
        															Next_Breach_Date__c, Estimated_Closure_Date__c,
        															Time_Taken_per_Stage__c, TAT_Breach_in_Days__c
        													FROM 	Seller_TAT_Breach__c
        													WHERE	Opportunity__c = :opp.Id];
        
        sellerTATSwimlineList = [	SELECT 	Id, Seller_TAT_Breach_ID__c, TAT_Swimline_ID__c,
        															Swimline_Start_Date__c, Swimline_End_Date__c, Comments__c
        													FROM	Seller_TAT_Swimline__c
        													WHERE 	Seller_TAT_Breach_ID__c IN :sellerTATBreachList];
        
        System.debug('<--Opportunity Delay Actions Update Start-->');
		for(Seller_TAT_Breach__c stb : sellerTATBreachList){
			System.debug('Id: '+stb.Id+'\n Opportunity Id: '+stb.Opportunity__c+'\n Ideal Closure Date: '+stb.Ideal_Closure_Date__c);
			System.debug('Actual Closure Date: '+stb.Actual_Closure_Date__c+'\n Next Breach Date: '+stb.Next_Breach_Date__c);
			System.debug('Estimated Closure Date: '+stb.Estimated_Closure_Date__c);
			System.debug('Time Taken per Stage: '+stb.Time_Taken_per_Stage__c+'\n TAT Breach in Days: '+stb.TAT_Breach_in_Days__c);
		}        											
		System.debug('<--Opportunity Delay Actions Update End-->');
		
		System.debug('<--Seller TAT Swimline Start-->');
		for(Seller_TAT_Swimline__c stb : sellerTATSwimlineList){
			System.debug('Id: '+stb.Id+'\n Seller TAT Breach ID: '+stb.Seller_TAT_Breach_ID__c+'\n TAT Swimline ID: '+stb.TAT_Swimline_ID__c);
			System.debug('Swimline Start Date: '+stb.Swimline_Start_Date__c+'\n Swimline End Date: '+stb.Swimline_End_Date__c);
			System.debug('Comments: '+stb.Comments__c);
		}        											
		System.debug('<--Seller TAT Swimline End-->');
    } 
    
    @isTest(SeeAllData=true)
    static void sellerTATBreachCalculateTest() {
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
		for(Seller_TAT_Breach__c stb : sellerTATBreachList){
			
            stb.Actual_Closure_Date__c = Date.today()+20;
		}
        
    }
}