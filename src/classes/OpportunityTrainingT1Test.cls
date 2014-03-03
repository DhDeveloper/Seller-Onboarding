@isTest
public class OpportunityTrainingT1Test{
	@isTest(SeeAllData=true)
    static void oppUpdateTraining1SchedulesTest() {
        Opportunity opp = UtilityClassTest.createOpportunityTestRecord();
        opp.Expected_TAT__c = Constants.TAT_18;
        opp.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
    	update opp;
        opp.StageName = Constants.OPP_STAGE_INVITED;
    	update opp;
        
        System.debug('======$$$$$++++'+opp.SS_Owner__c);
        
        try{
            opp.Training1__c = Constants.TRAINING_NOT_DONE;
            opp.Training_Start_Date_Time__c = Date.today();
            opp.Training_End_Date_Time__c = Date.today();
            update opp;
            System.debug('No Validation Rule ');
        }catch(Exception e){
            System.debug('T1 Try One');
            System.debug('Exception: '+ e.getMessage());  
        }
    	
    	opp.Training1__c = Constants.TRAINING_SCHEDULED;
    	opp.Training_Start_Date_Time__c = Date.today();
    	opp.Training_End_Date_Time__c = Date.today();
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
		
		List<Event> eventList = [	SELECT 	Id, StartDateTime, EndDateTime, Subject 
									FROM 	Event 
									WHERE 	WhatId = :opp.Id ];        													
        
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
		
		System.debug('<--Event List Start-->');
		for(Event e : eventList){
			System.debug('Id: '+e.Id+'\n StartDateTime: '+e.StartDateTime+'\n EndDateTime: '+e.EndDateTime);
			System.debug('Subject: '+e.Subject);
		}        											
		System.debug('<--Event List End-->');
        
        try{
            opp.Training_Start_Date_Time__c = Date.today()+3;
            opp.Training_End_Date_Time__c = Date.today()+3;
            update opp;
            System.debug('No Validation Rule ');
        }catch(Exception e){
            System.debug('T1 Try Two');
            System.debug('Exception: '+ e.getMessage());  
        }
		
        /*try{
            opp.Training2_Policy_Payments__c = Constants.TRAINING_SCHEDULED;
            update opp;
            System.debug('No Validation Rule ');
        }catch(Exception e){
            System.debug('T1 Try Two');
            System.debug('Exception: '+ e.getMessage());  
        }*/
        
		opp.Training1__c = Constants.TRAINING_RESCHEDULE;
    	opp.Training_Start_Date_Time__c = Date.today()+1;
    	opp.Training_End_Date_Time__c = Date.today()+1;
    	update opp;
    	
        sellerTATBreachList = [	SELECT 	Id, Opportunity__c, Ideal_Closure_Date__c, Actual_Closure_Date__c,
										Next_Breach_Date__c, Estimated_Closure_Date__c,
										Time_Taken_per_Stage__c, TAT_Breach_in_Days__c
								FROM 	Seller_TAT_Breach__c
								WHERE	Opportunity__c = :opp.Id];
        
        sellerTATSwimlineList = [	SELECT 	Id, Seller_TAT_Breach_ID__c, TAT_Swimline_ID__c,
											Swimline_Start_Date__c, Swimline_End_Date__c, Comments__c
									FROM	Seller_TAT_Swimline__c
									WHERE 	Seller_TAT_Breach_ID__c IN :sellerTATBreachList];
		
		eventList = [	SELECT 	Id, StartDateTime, EndDateTime, Subject 
								FROM 	Event 
								WHERE 	WhatId = :opp.Id ];        													
        
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
		
		System.debug('<--Event List Start-->');
		for(Event e : eventList){
			System.debug('Id: '+e.Id+'\n StartDateTime: '+e.StartDateTime+'\n EndDateTime: '+e.EndDateTime);
			System.debug('Subject: '+e.Subject);
		}        											
		System.debug('<--Event List End-->');
		
		opp.Training1__c = Constants.TRAINING_RESCHEDULE;
    	opp.Training_Start_Date_Time__c = Date.today()+3;
    	opp.Training_End_Date_Time__c = Date.today()+3;
    	update opp;
    	
        sellerTATBreachList = [	SELECT 	Id, Opportunity__c, Ideal_Closure_Date__c, Actual_Closure_Date__c,
										Next_Breach_Date__c, Estimated_Closure_Date__c,
										Time_Taken_per_Stage__c, TAT_Breach_in_Days__c
								FROM 	Seller_TAT_Breach__c
								WHERE	Opportunity__c = :opp.Id];
        
        sellerTATSwimlineList = [	SELECT 	Id, Seller_TAT_Breach_ID__c, TAT_Swimline_ID__c,
											Swimline_Start_Date__c, Swimline_End_Date__c, Comments__c
									FROM	Seller_TAT_Swimline__c
									WHERE 	Seller_TAT_Breach_ID__c IN :sellerTATBreachList];
		
		eventList = [	SELECT 	Id, StartDateTime, EndDateTime, Subject 
								FROM 	Event 
								WHERE 	WhatId = :opp.Id ];        													
        
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
		
		System.debug('<--Event List Start-->');
		for(Event e : eventList){
			System.debug('Id: '+e.Id+'\n StartDateTime: '+e.StartDateTime+'\n EndDateTime: '+e.EndDateTime);
			System.debug('Subject: '+e.Subject);
		}        											
		System.debug('<--Event List End-->');
        
        try{
            opp.Training1__c = Constants.TRAINING_RESCHEDULE;
            opp.Training_Start_Date_Time__c = null;
            opp.Training_End_Date_Time__c = null;
            update opp;
            System.debug('No Validation Rule 2');
        }catch(Exception e){
            System.debug('T1 Try Four');
            System.debug('Exception: '+ e.getMessage());            
        }
        
    }
}