@isTest
public class CalcTATBreachTest{
  @isTest(SeeAllData=true)
    static void sellerTATBreachInsertTest() {
        Opportunity opp = UtilityClassTest.createOpportunityTestRecord();
        opp.Expected_TAT__c = Constants.TAT_13;
        opp.StageName = Constants.OPP_STAGE_READY_TO_INVITE;
        update opp;
        
        opp.StageName = Constants.OPP_STAGE_INVITED;
        update opp;
        
        List<Seller_TAT_Breach__c> sellerTATBreachList = [  SELECT   Id, Opportunity__c, Ideal_Closure_Date__c, Actual_Closure_Date__c,
                                      Next_Breach_Date__c, Estimated_Closure_Date__c,
                                      Time_Taken_per_Stage__c, TAT_Breach_in_Days__c
                                  FROM   Seller_TAT_Breach__c
                                  WHERE  Opportunity__c = :opp.Id];
    	Integer i = 0;
        for(Seller_TAT_Breach__c stb : sellerTATBreachList){
	      System.debug('Id: '+stb.Id+'\n Opportunity Id: '+stb.Opportunity__c+'\n Ideal Closure Date: '+stb.Ideal_Closure_Date__c);
	      System.debug('Actual Closure Date: '+stb.Actual_Closure_Date__c+'\n Next Breach Date: '+stb.Next_Breach_Date__c);
	      System.debug('Estimated Closure Date: '+stb.Estimated_Closure_Date__c);
	      System.debug('Time Taken per Stage: '+stb.Time_Taken_per_Stage__c+'\n TAT Breach in Days: '+stb.TAT_Breach_in_Days__c);
          if(i == 0){
	        stb.Actual_Closure_Date__c = Date.today()+15;
	        i++;
          }
	    }
        update sellerTATBreachList;
    }
}