{!REQUIRESCRIPT("/soap/ajax/29.0/connection.js")} 
{!REQUIRESCRIPT("/soap/ajax/29.0/apex.js")} 
try{
    var updateOppRecords = [];
    var oppSObject = new sforce.SObject("Opportunity"); 
    oppSObject.id = '{!Opportunity.Id}'; 
    oppSObject.Is_Invited__c = '{!Opportunity.Is_Invited__c}'; 
    oppSObject.StageName = '{!Opportunity.StageName}'; 

    if( oppSObject.StageName == 'Ready to Invite' ||
        oppSObject.StageName == 'Invited'){
        if( oppSObject.Is_Invited__c == 2 ||
            oppSObject.Is_Invited__c == 3){
            alert('This opportunity record already sent to SMS system');
        }else{
            // make the field change to send email invite to SMS
            oppSObject.StageName = 'Invited'; 
            oppSObject.Is_Invited__c = 3; 

            updateOppRecords.push(oppSObject);
            sforce.connection.update(updateOppRecords);
            window.location.reload();
        }
    }else{
         alert('Opportunity stage should be in \'Ready to Invite\' to Invite');
    }
}catch(e){
    alert('Error: '+e);
}