@isTest
public class ConvertLeadStatusToInEvalTriggerTest{
	static testMethod void ownerQueueStatusOpenToOwnerUser() {
        
      Group g1 = new Group(Name='group name', type='Queue');
      insert g1;
      QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Lead');

      User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
      System.runAs(thisUser) {
        insert q1;
      }  
        
        
      test.startTest();   
        Lead l = new Lead(LastName='Foo', Status='Open', Company='foo',
                                    Temp_Region__c = 'Goa',
                                    Temp_Pickup_Pincode__c = 100, 
                          OwnerId=g1.Id);
      insert l;
                System.assertEquals('Open', l.Status);
        l.OwnerId = thisUser.Id;
        update l;
    test.stopTest();
        Lead readAgain = [ select Status from Lead where Id = :l.Id ];
    System.assertEquals('In Evaluation', readAgain.Status);
    }
}