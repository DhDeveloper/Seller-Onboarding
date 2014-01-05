trigger UpdateHubFromPincodeForOpportunity on Opportunity (before Update, before Insert) {
  /*for (Opportunity op : Trigger.new) {
    String pincode = op.Pickup_Pincode__c;
    if (pincode != null) {
      List<PincodeHubMapping__c> hubs = [SELECT Id, Name FROM PincodeHubMapping__c WHERE PickupPincode__c = :pincode LIMIT 1];   
      if (hubs != null && hubs.size() == 1)  {
        op.HubName__c = hubs[0].Name;
      }
    }
  } */
}