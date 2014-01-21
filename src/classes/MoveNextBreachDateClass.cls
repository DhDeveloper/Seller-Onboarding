global class MoveNextBreachDateClass implements Schedulable{
    global void execute(SchedulableContext ctx) {
    	List<Seller_TAT_Breach__c> sellerTATBreachList = [ SELECT  Id,Opportunity__c,Ideal_Closure_Date__c,
                                                                    Actual_Closure_Date__c,Next_Breach_Date__c,
                                                                    Estimated_Closure_Date__c,TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c,
                                                                    TAT_Stage_Profile_ID__r.TAT_Stage_ID__r.TAT_Stage__c
                                                            FROM    Seller_TAT_Breach__c 
                                                            WHERE Next_Breach_Date__c = YESTERDAY];
    }
}