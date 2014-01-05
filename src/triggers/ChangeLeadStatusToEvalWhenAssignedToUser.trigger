trigger ChangeLeadStatusToEvalWhenAssignedToUser on Lead (before Update) {
	 
  for (Lead lead: Trigger.new) {
  System.debug('1 ChangeLeadStatusToEvalWhenAssignedToUser OldUserId:' + Trigger.oldMap.get(lead.Id).OwnerId);
    System.debug('2 ChangeLeadStatusToEvalWhenAssignedToUser NewUserId:' + Trigger.newMap.get(lead.Id).OwnerId);
      
    boolean wasAQueue =  String.valueOf(Trigger.oldMap.get(lead.Id).OwnerId).substring(0, 3) != '005';
    boolean isNowAUser = String.valueOf(Trigger.newMap.get(lead.Id).OwnerId).substring(0, 3) == '005';

    System.debug('3 ChangeLeadStatusToEvalWhenAssignedToUser WasAQueue? ' + wasAQueue + ' now user?' + isNowAUser);
      
     if (Trigger.oldMap.get(lead.Id).Status == 'Open' &&
         wasAQueue && 
         isNowAUser)
   {
            lead.Status = 'In Evaluation';
         }
      System.debug('4 ChangeLeadStatusToEvalWhenAssignedToUser Lead Status:' + lead.Status);
  }
  

}