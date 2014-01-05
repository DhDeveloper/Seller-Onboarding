public class CalcuateHubFromPincodeForOpportunityTest{

/*
  static testMethod void HubShouldNotBeSetIfHubPincodeMappingNotPresent() {
    Opportunity l = createDummyOpportunity();
    insert l;
    System.assertEquals(l.HubName__c, null);
  }

  static testMethod void whileCreatingAnOppHubMustBeSetIfMappingExists() {
    PincodeHubMapping__c hubMap = new PincodeHubMapping__c(PickupPincode__c = '123400', Name='my hub');
    insert hubMap;

    Opportunity l = createDummyOpportunity();
    l.Pickup_Pincode__c = '123400';
    insert l;

    Opportunity readAgain = [ select Id, HubName__c from Opportunity where Id = :l.Id ];
    System.assertEquals('my hub', readAgain.HubName__c);  
  }

  static testMethod void whileUpdatingAnOppHubMustBetSetIfMappingExists() {
    Opportunity l = createDummyOpportunity();
    insert l;

    Opportunity readAgain = [ select Id, HubName__c from Opportunity where Id = :l.Id ];
    System.assertEquals(null, readAgain.HubName__c);  

    PincodeHubMapping__c hubMap = new PincodeHubMapping__c(PickupPincode__c = '123400', Name='my hub');
    insert hubMap;
    
    l.Pickup_Pincode__c = '123400';
    update l;

    readAgain = [ select Id, HubName__c from Opportunity where Id = :l.Id ];
    System.assertEquals('my hub', readAgain.HubName__c);  
  }


  static Opportunity createDummyOpportunity() {
    Opportunity l = new Opportunity(Name='Foo', StageName='Invited', CloseDate=Date.today());

    return l;
  }
  */
}