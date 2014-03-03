public class SavePageController {
    public Opportunity opp;
    public Date    trainingDate{ get; set; }
    public String startHoursList{public get; public set;}
    public String startMinsList{public get; public set;}
    public String endHoursList{public get; public set;}
    public String endMinsList{public get; public set;}
    public List<SelectOption> startHours{get;set;}
    public List<SelectOption> startMins{get;set;}
    public List<SelectOption> endHours{get;set;}
    public list<SelectOption> endMins{get;set;}
    
    public boolean isSaved{get; set;} 
    
    
    public SavePageController(ApexPages.StandardController controller) {
        opp = (Opportunity)controller.getRecord();
        isSaved = false;
        onLoadPage(opp.Id);
        startHours = getHours();
        startMins = getMins();
        endHours = getHours();
        endMins = getMins();
    }
    
    public void onLoadPage(ID oppId){
    	Opportunity o = [SELECT Training_Start_Date_Time__c, Training_End_Date_Time__c FROM Opportunity WHERE Id =:oppId];
    	
    	trainingDate = o.Training_Start_Date_Time__c.date();
    	startHoursList = o.Training_Start_Date_Time__c.hour()+'';
    	endHoursList = o.Training_End_Date_Time__c.hour()+'';
    	
    	Integer startMins = o.Training_Start_Date_Time__c.minute();
    	Integer endMins = o.Training_End_Date_Time__c.minute();   	
    	
    	if (startMins <10){
	    	startMinsList = '0'+startMins;
    	}else{
    		startMinsList = ''+startMins;
    	}
    	
    	if (endMins <10){
	    	endMinsList = '0'+endMins;
    	}else{
    		endMinsList = ''+endMins;
    	}
    	
    }
    
    public List<SelectOption> getHours() {
        List<SelectOption> hours = new List<SelectOption>();
        for (Integer h=9;h<19;h++){
            hours.add(new SelectOption(h+'', h+''));
        }
        return hours;
    }
    
    public List<SelectOption> getMins() {
        List<SelectOption> mins = new List<SelectOption>();
        for (Integer m=0;m<60;m++){
            String mm = '';
            if(m<10){
                mm = '0'+m;                
            }else{
                mm = m+'';
            }
            mins.add(new SelectOption(mm, mm));
        }
        return mins;
    }
    
    public PageReference populateEndHours() {
        endHoursList = (Integer.ValueOf(startHoursList) +1)+'';
        return null;        
    }
    
    public PageReference populateEndMins() {
        endMinsList = startMinsList;
        return null;        
    }
    
    public PageReference saveTraining() {
    
        try{
            String startDateTimeString = trainingDate.year()+'-'+trainingDate.month()+'-'+trainingDate.day()+' '+startHoursList+':'+startMinsList+':00';
            String endDateTimeString = trainingDate.year()+'-'+trainingDate.month()+'-'+trainingDate.day()+' '+endHoursList+':'+endMinsList+':00';
            
            Datetime startDateTime = datetime.valueOf(startDateTimeString);
            Datetime endDateTime = datetime.valueOf(endDateTimeString);        
            
            opp.Training_Start_Date_Time__c = startDateTime;
            opp.Training_End_Date_Time__c = endDateTime;
            opp.Training1__c = 'Scheduled';
            update opp;
            isSaved = true;
        }catch(Exception e){
            ApexPages.addMessages(e);
        }
        
        
        return null;
    }

}