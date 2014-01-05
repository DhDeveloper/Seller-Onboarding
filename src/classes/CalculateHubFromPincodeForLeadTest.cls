public class CalculateHubFromPincodeForLeadTest{
/*  
  static testMethod void HubShouldNotBeSetIfHubPincodeMappingNotPresent() {
        Lead l = createDummyLead();
        insert l;
        System.assertEquals(l.HubName__c, null);
  }
    
  static testMethod void whileCreatingALeadHubMustBeSetIfMappingExists() {
    PincodeHubMapping__c hubMap = new PincodeHubMapping__c(PickupPincode__c = '123400', Name='my hub');
    insert hubMap;
      
    Lead l = createDummyLead();
    insert l;

    Lead readAgain = [ select Id, HubName__c from Lead where Id = :l.Id ];
    System.assertEquals('my hub', readAgain.HubName__c);  
  }
    
  static testMethod void whileUpdatingALeadHubMustBetSetIfMappingExists() {
      Lead l = createDummyLead();
      insert l;
      
     Lead readAgain = [ select Id, HubName__c from Lead where Id = :l.Id ];
     System.assertEquals(null, readAgain.HubName__c);  
      
     PincodeHubMapping__c hubMap = new PincodeHubMapping__c(PickupPincode__c = '123400', Name='my hub');
     insert hubMap;
      
     update l;
     
     readAgain = [ select Id, HubName__c from Lead where Id = :l.Id ];
     System.assertEquals('my hub', readAgain.HubName__c);  
  }
    
    static testMethod void shouldStripHubName() {
     PincodeHubMapping__c hubMap = new PincodeHubMapping__c(PickupPincode__c = '123401', Name='my hub ');
     insert hubMap;
     
     Lead lead = createDummyLead();
     lead.PickupPincode__c = '123401';
     insert lead;
       
     Lead readAgain = [ select Id, HubName__c from Lead where Id = :lead.Id ];   
     System.assertEquals('my hub', readAgain.HubName__c);     
     
 
    }

  static Lead createDummyLead() {
    Group g1 = new Group(Name='group name', type='Queue');
    insert g1;
    QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Lead');

    User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    System.runAs(thisUser) {
      insert q1;
    }  


    Lead l = new Lead(LastName='Foo', Status='Open', Company='foo', PickupPincode__c = '123400',
    OwnerId = g1.Id);

    return l;
  }
  */
}