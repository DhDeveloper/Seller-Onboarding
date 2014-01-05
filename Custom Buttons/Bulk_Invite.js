{!REQUIRESCRIPT("/soap/ajax/29.0/connection.js")}
try{
  var oppRecords = {!GETRECORDIDS($ObjectType.Opportunity)};
  var updateOppRecords = [];
  var invalidRecordCount = 0;

  if(oppRecords[0] == null) { 
    alert("Please select at least one record to update"); 
  }else{ 
     var sName = sforce.connection.retrieve("StageName", "Opportunity", [oppRecords]);
     for (var i=0; i<oppRecords.length; i++) {
       if(sName[i].StageName == "Invited"){
         invalidRecordCount++;
       }
       var oppSObject = new sforce.SObject("Opportunity");
       oppSObject.id = oppRecords[i];
 
       // make the field change
       oppSObject.StageName = "Invited";
       
       updateOppRecords.push(oppSObject);
     }
     
     if(invalidRecordCount == 0){
       // save the change
       var result = sforce.connection.update(updateOppRecords);
       //alert(result[0].success);
       alert(result.length+" record(s) updated successfully");
       //refresh the page
       window.location.reload();
     }else{
        alert("Please select valid records to update");
     }
   }
}catch(er){
  alert("Error: "+er);
}