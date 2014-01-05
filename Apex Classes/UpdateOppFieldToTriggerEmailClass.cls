/**
  * This Apex Class implements Schedulable interface
  * and has scheduled to update set of Opportunity records
  * 'Is Invited' field to 1 at 10:00 and 16:00 on weekdays. 
  * By this update a trigger will execute and send mail to 
  * SMS system with invited list
**/
global class UpdateOppFieldToTriggerEmailClass implements Schedulable{
    global void execute(SchedulableContext ctx) {
        List<Opportunity> oppList = [SELECT Id FROM Opportunity WHERE StageName = 'Invited' AND Is_Invited__c = 0];
        for(Opportunity opp :oppList){
            opp.Is_Invited__c = 1;
        }
         update oppList;
    }
}