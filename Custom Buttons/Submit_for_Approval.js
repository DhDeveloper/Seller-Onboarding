{!REQUIRESCRIPT("/soap/ajax/29.0/connection.js")} 
{!REQUIRESCRIPT("/soap/ajax/29.0/apex.js")} 
try{
    var updateLeadRecords = []; 
    var leadSObject = new sforce.SObject("Lead");
    leadSObject.id = '{!Lead.Id}'; 
    leadSObject.Approval_State__c = '{!Lead.Approval_State__c}'; 

    if(leadSObject.Approval_State__c == 1){
        alert('This Lead record already submitted for approval');
    }else if(leadSObject.Approval_State__c == 2){
        alert('This Lead record already approved by approver');
    }else if(leadSObject.Approval_State__c == 4){
        alert('This Lead record is in Dropped state and cannot be submitted for approval');
    }else if(leadSObject.Approval_State__c == 5){
        alert('This Lead record is in Parked state and cannot be submitted for approval');
    }else{
        // make the field change to approve 
        leadSObject.Approval_State__c = 1; 
        updateLeadRecords.push(leadSObject); 
        sforce.connection.update(updateLeadRecords); 
        window.location.reload();
    }
}catch(e){
    alert("Error: "+e); 
}