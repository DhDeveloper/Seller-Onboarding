trigger HubCodeUpdateOneRunTrigger on PincodeHubMapping__c (after insert) {
    
    List<String> pinCodeStringList = new List<String>();
    List<Lead> updateLeadList = new List<Lead>();
    List<Opportunity> updateOppList = new List<Opportunity>();
    
    for(PincodeHubMapping__c pin : Trigger.new){
        pinCodeStringList.add(pin.Name);
    }
    
    List<Lead> leadList = [ SELECT Id,PickupPincode__c,Pickup_Pincode__c,Hub_Name__c,IsConverted 
                            FROM Lead 
                            WHERE PickupPincode__c IN :pinCodeStringList ];
    
    List<Opportunity> oppList = [   SELECT Id,Pickup_Pincode__c,Pickup_Area_Pincode__c, Hub_Name__c
                                    FROM Opportunity WHERE Pickup_Pincode__c IN :pinCodeStringList ];
                                    
    for(PincodeHubMapping__c pin : Trigger.new){
        for(Lead lead : leadList){
            if(!(lead.IsConverted) &&  lead.PickupPincode__c == pin.Name ){
                lead.Pickup_Pincode__c = pin.Id;
                //lead.Hub_Name__c = pin.Hub_Name__c;
                updateLeadList.add(lead);
            }
        }
        for(Opportunity opp : oppList){
            if(opp.Pickup_Pincode__c == pin.Name ){
                opp.Pickup_Area_Pincode__c = pin.Id;
                opp.Hub_Name__c = pin.Hub_Name__c;
                updateOppList.add(opp);
            }
        }
    }   
    
    update updateLeadList;
    update updateOppList;           

}