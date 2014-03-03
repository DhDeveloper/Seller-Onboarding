public class SellerTrainingController {
    public Opportunity opp;
    public Date    trainingDate = null;
    public Date    training2Date = null;
    
    public String startHoursList{public get; public set;}
    public String startMinsList{public get; public set;}
    public String endHoursList{public get; public set;}
    public String endMinsList{public get; public set;}
    
    public String startHoursT2List{public get; public set;}
    public String startMinsT2List{public get; public set;}
    public String endHoursT2List{public get; public set;}
    public String endMinsT2List{public get; public set;}
    
    public List<SelectOption> startHours{get;set;}
    public List<SelectOption> startMins{get;set;}
    public List<SelectOption> endHours{get;set;}
    public list<SelectOption> endMins{get;set;}
    
    public boolean isSaved{get; set;} 
    public boolean cancelTraining{public get;public set;}
    public boolean completedTraining{get;set;}
    
    public boolean cancelTraining2{public get;public set;}
    public boolean completedTraining2{get;set;}
    
    public String training1;
    public String training2;
    
    
    public SellerTrainingController(ApexPages.StandardController controller) {
        opp = (Opportunity)controller.getRecord();
        
        //isSaved = false;
        onLoadPage(opp.Id);
        
        startHours = getHours();
        startMins = getMins();
        endHours = getHours();
        endMins = getMins();
    }
    
    public void onLoadPage(ID oppId){
        Opportunity o = [   SELECT  Training1__c, Training_Start_Date_Time__c, Training_End_Date_Time__c,
                                    Training2_Policy_Payments__c, Training2_Start_Date_Time__c, Training2_End_Date_Time__c
                            FROM    Opportunity 
                            WHERE   Id =:oppId];
        
        training1 = o.Training1__c;
        training2 = o.Training2_Policy_Payments__c;
        
        if(training1 != Constants.TRAINING_NOT_DONE){
            trainingDate = o.Training_Start_Date_Time__c.date();
            opp.Training_T1_Date_VF__c = o.Training_Start_Date_Time__c.date();
            startHoursList = o.Training_Start_Date_Time__c.hour()+'';
            endHoursList = o.Training_End_Date_Time__c.hour()+'';
            
            Integer startMins = o.Training_Start_Date_Time__c.minute();
            Integer endMins = o.Training_End_Date_Time__c.minute();     
            
            startMinsList = (startMins <10) ? '0'+startMins : ''+startMins;
            endMinsList = (endMins <10) ? '0'+endMins : ''+endMins;
            
            if(training1 == Constants.TRAINING_CANCELLED){
                cancelTraining = true;
            }else if(training1 == Constants.TRAINING_COMPLETED){
                completedTraining = true;
            }
        }
        
        if(training2 != null && training2 != Constants.TRAINING_NOT_DONE){
            training2Date = o.Training2_Start_Date_Time__c.date();
            opp.Training_T2_Date_VF__c = o.Training2_Start_Date_Time__c.date();
            startHoursT2List = o.Training2_Start_Date_Time__c.hour()+'';
            endHoursT2List = o.Training2_End_Date_Time__c.hour()+'';
            
            Integer startMins = o.Training2_Start_Date_Time__c.minute();
            Integer endMins = o.Training2_End_Date_Time__c.minute();     
            
            startMinsT2List = (startMins <10) ? '0'+startMins : ''+startMins;
            endMinsT2List = (endMins <10) ? '0'+endMins : ''+endMins;
            
            if(training2 == Constants.TRAINING_CANCELLED){
                cancelTraining2 = true;
            }else if(training2 == Constants.TRAINING_COMPLETED){
                completedTraining2 = true;
            }
        }
    }
    
    public List<SelectOption> getHours() {
        List<SelectOption> hours = new List<SelectOption>();
        hours.add(new SelectOption('HH', 'HH'));
        for (Integer h=8;h<21;h++){
            hours.add(new SelectOption(h+'', h+''));
        }
        return hours;
    }
    
    public List<SelectOption> getMins() {
        List<SelectOption> mins = new List<SelectOption>();
        mins.add(new SelectOption('MM', 'MM'));
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
        if(startHoursList != 'HH'){
            endHoursList = (Integer.ValueOf(startHoursList) +1)+'';
            cancelTraining = false;
        }else{
            endHoursList = startHoursList;
        }
        
        if(startHoursT2List != 'HH'){
            endHoursT2List = (Integer.ValueOf(startHoursT2List) +1)+'';
            cancelTraining2 = false;
        }else{
            endHoursT2List = startHoursT2List;
        }
        
        return null;        
    }
    
    public PageReference populateEndMins() {
        if(startMinsList != 'MM'){
            endMinsList = startMinsList;
            cancelTraining = false;
        }else{
            endMinsList = startMinsList;
        }
        
        if(startMinsT2List != 'MM'){
            endMinsT2List = startMinsT2List;
            cancelTraining2 = false;
        }else{
            endMinsT2List = startMinsT2List;
        }
        
        return null;        
    }
    
    /*public List<Event> getThisWeekEvents(){
        List<Event> eventList = [   SELECT  Id, StartDateTime, EndDateTime, Subject, Owner.Name, whatId                                           
                                    From    Event
                                    WHERE   OwnerId = :UserInfo.getUserId()
                                    AND     StartDateTime >= THIS_WEEK ];
        return eventList;
    }*/
    
    public PageReference saveTraining() {
        try{
            trainingDate = opp.Training_T1_Date_VF__c;
            training2Date = opp.Training_T2_Date_VF__c;
            
            if(trainingDate == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Training1 Start Date'));
            }else if(startHoursList == 'HH'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Training1 Start Time hours'));
            }else if(startMinsList == 'MM'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Training1 Start Time mins'));
            }else if(endHoursList == 'HH'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Training1 End Time hours'));
            }else if(endMinsList == 'MM'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Training1 End Time mins'));
            }else if(training2Date != null  && (startHoursT2List == 'HH' || startMinsT2List == 'MM' || endHoursT2List == 'HH' || endMinsT2List == 'MM')){
                if(startHoursT2List == 'HH'){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Training2 Start Time hours'));
                }else if(startMinsT2List == 'MM'){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Training2 Start Time mins'));
                }else if(endHoursT2List == 'HH'){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Training2 End Time hours'));
                }else if(endMinsT2List == 'MM'){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Training2 End Time mins'));
                }
            }else if(training2Date == null && (startHoursT2List != 'HH' || startMinsT2List != 'MM' || endHoursT2List != 'HH' || endMinsT2List != 'MM')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Provided partial data in Training2 (Policy + Payments) section to create schedule'));
            }else{
                
                String startDateTimeString = trainingDate.year()+'-'+trainingDate.month()+'-'+trainingDate.day()+' '+startHoursList+':'+startMinsList+':00';
                String endDateTimeString = trainingDate.year()+'-'+trainingDate.month()+'-'+trainingDate.day()+' '+endHoursList+':'+endMinsList+':00';
                
                Datetime startDateTime = datetime.valueOf(startDateTimeString);
                Datetime endDateTime = datetime.valueOf(endDateTimeString); 
                
               /* List<Event> eventList = [ select  Id, StartDateTime, EndDateTime, Subject, Owner.Name 
                                From    Event
                                WHERE   OwnerId = :UserInfo.getUserId() 
                                AND     ((StartDateTime >= :startDateTime AND StartDateTime <= :endDateTime) 
                                OR      (EndDateTime >= :startDateTime AND EndDateTime <= :endDateTime ))];  
                                
                System.debug('eventList size:'+eventList.size());
                
                Integer eventListSize = eventList.size();
                
                if(eventListSize > 0){
                    //for(Event e: eventList){
                        //System.debug('Id:'+e.Id+' StartDateTime:'+e.StartDateTime+' EndDateTime:'+e.EndDateTime+' Subject:'+e.Subject+' owner:'+e.Owner.Name);
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Schedule Overlap with existing'));
                    //}
                }else{  */                      
                opp.Training_Start_Date_Time__c = startDateTime;
                opp.Training_End_Date_Time__c = endDateTime;
                
                if(cancelTraining == true){
                    opp.Training1__c = Constants.TRAINING_CANCELLED;
                }else if(completedTraining == true){
                    opp.Training1__c = Constants.TRAINING_COMPLETED;
                }else{
                    if(training1 == Constants.TRAINING_NOT_DONE){
                        opp.Training1__c = Constants.TRAINING_SCHEDULED;
                    }
                }
                
                if(training2Date != null){
                    String startDateTime2String = training2Date.year()+'-'+training2Date.month()+'-'+training2Date.day()+' '+startHoursT2List+':'+startMinsT2List+':00';
                    String endDateTime2String = training2Date.year()+'-'+training2Date.month()+'-'+training2Date.day()+' '+endHoursT2List+':'+endMinsT2List+':00';
                    
                    Datetime startDateTime2 = datetime.valueOf(startDateTime2String);
                    Datetime endDateTime2 = datetime.valueOf(endDateTime2String);        
                    
                    opp.Training2_Start_Date_Time__c = startDateTime2;
                    opp.Training2_End_Date_Time__c = endDateTime2;
                    
                    if(cancelTraining2 == true){
                        opp.Training2_Policy_Payments__c = Constants.TRAINING_CANCELLED;
                    }else if(completedTraining2 == true){
                        opp.Training2_Policy_Payments__c = Constants.TRAINING_COMPLETED;
                    }else{
                        if(training2 == null || training2 == Constants.TRAINING_NOT_DONE){
                            opp.Training2_Policy_Payments__c = Constants.TRAINING_SCHEDULED;
                        }
                    }
                }
                
                update opp;
                isSaved = true;
                
            }
        }catch(Exception e){
            ApexPages.addMessages(e);
        }
        
        return null;
    }
}