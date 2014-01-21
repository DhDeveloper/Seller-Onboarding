/**
  * This Apex Test Class is Temporary test class
**/
@isTest
public class CreateObjectRecordsTest{
	@isTest(SeeAllData=true)
	static void testMe(){
		List<TAT_Stage__c> tatStageList = [SELECT Id,TAT_Stage__c from TAT_Stage__c  order by Id];
		
		for(TAT_Stage__c tat: tatStageList){
			System.debug('-->'+tat.TAT_Stage__c);
		}
	}
	
	public static void createTATStageRecords(){
    	List<TAT_Stage__c> tatStageList = new List<TAT_Stage__c>();
    	List<String> tatStageNames = new List<String>{ 'Candidate For Onboarding', 'Ready to Invite',
    													'Invited', 'Registered', 'Pending Minimum Upload',
    													'Pending Minimum Listing', 'Pending Seller Approval (PSA)',
    													'Pending Seller Update (PSU)', 'Go Live Check-list (GLC)',
    													'Live'};
    	for(Integer i=0; i<10;i++){
    		TAT_Stage__c tatStage = new TAT_Stage__c();
    		tatStage.TAT_Stage__c = tatStageNames[i];
    		tatStageList.add(tatStage);
    	}
    	insert tatStageList;
    }
    
    @isTest(SeeAllData=true)
    static void UtilityClassTest(){
    	List<Holiday> holidaysList = [Select h.ActivityDate From Holiday h];
    	Date oDate = UtilityClass.addDaysExcludingSundaysHolidays(date.parse('01/01/2014'), 6, holidaysList);
    	System.debug('oDate'+oDate);
    	oDate = UtilityClass.addDaysExcludingSundaysHolidays(date.parse('24/12/2014'), 6, holidaysList);
    	System.debug('oDate'+oDate);
    	
    	Integer days = UtilityClass.daysBetweenExcludingSundaysHolidays(date.parse('01/01/2014'), date.parse('14/01/2014'), holidaysList);
    	System.debug('days:'+days);
    	System.debug(UtilityClass.isHoliday(date.parse('01/01/2014'), holidaysList));
    	System.debug(UtilityClass.isSunday(date.parse('03/01/2014')));
    }
    
    static testMethod void SampleTest(){
    	 Test.startTest();
    	OTRSCallClass.callOTRSTest();
    	 Test.stopTest();
    }
}