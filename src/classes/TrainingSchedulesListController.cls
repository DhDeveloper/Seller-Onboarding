public class TrainingSchedulesListController {

    public TrainingSchedulesListController(ApexPages.StandardController controller) {

    }
    
    public List<Event> getThisWeekEvents(){
        List<Event> eventList = [   SELECT  Id, StartDateTime, EndDateTime, Subject, Owner.Name, whatId                                           
                                    From    Event
                                    WHERE   OwnerId = :UserInfo.getUserId()
                                    AND     StartDateTime >= TODAY ];
        if(eventList.size() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No records to display'));
        }
        
        return eventList;
    }

}