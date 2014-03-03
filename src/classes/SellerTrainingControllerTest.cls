/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class SellerTrainingControllerTest {

    static testMethod void testMyPage() {
        Opportunity opp = UtilityClassTest.createOpportunityTestRecord();
        DateTime dt = Date.today();
        opp.Training1__c = Constants.TRAINING_SCHEDULED;
        opp.Training_Start_Date_Time__c = dt;
        opp.Training_End_Date_Time__c = dt.addHours(2);
        update opp;
        
        SellerTrainingController controller = new SellerTrainingController(new ApexPages.StandardController(opp));
        
        opp.Training_T1_Date_VF__c = Date.today();
        
        controller.startHoursList = '14';
        controller.startHoursT2List = 'HH';
        controller.populateEndHours();
        controller.startMinsList = '25';
        controller.startMinsT2List = 'MM';
        controller.populateEndMins();
        
        controller.saveTraining();
        //controller.getThisWeekEvents();
        
        controller.completedTraining = true;
        controller.saveTraining();
    }
    
    static testMethod void testMyPage2() {
        Opportunity opp = UtilityClassTest.createOpportunityTestRecord();
        DateTime dt = Date.today();
        opp.Training1__c = Constants.TRAINING_SCHEDULED;
        opp.Training_Start_Date_Time__c = dt;
        opp.Training_End_Date_Time__c = dt.addHours(2);
        
        opp.Training2_Policy_Payments__c = Constants.TRAINING_SCHEDULED;
        opp.Training2_Start_Date_Time__c = dt.addHours(4);
        opp.Training2_End_Date_Time__c = dt.addHours(6);
        update opp;
        
        SellerTrainingController controller = new SellerTrainingController(new ApexPages.StandardController(opp));
        
        opp.Training_T1_Date_VF__c = Date.today();        
        opp.Training_T2_Date_VF__c = Date.today();
        
        controller.startHoursList = '14';
        controller.startHoursT2List = '20';
        controller.populateEndHours();
        controller.startMinsList = '25';
        controller.startMinsT2List = '20';
        controller.populateEndMins();
        
        controller.saveTraining();
        //controller.getThisWeekEvents();
        
        controller.cancelTraining = true;
        controller.cancelTraining2 = true;
        controller.saveTraining();
    }
    
    static testMethod void testMyPage3() {
        Opportunity opp = UtilityClassTest.createOpportunityTestRecord();
        SellerTrainingController controller = new SellerTrainingController(new ApexPages.StandardController(opp));
        try{
            controller.saveTraining();
        }catch(Exception e){
            System.debug('Error:'+e.getMessage());
        }
        
        try{
            opp.Training_T1_Date_VF__c = Date.today();
            controller.startHoursList = 'HH';
            controller.saveTraining();
        }catch(Exception e){
            System.debug('Error:'+e.getMessage());
        }
        
        try{
            opp.Training_T1_Date_VF__c = Date.today();
            controller.startHoursList = '11';
            controller.saveTraining();
        }catch(Exception e){
            System.debug('Error:'+e.getMessage());
        }
        
        try{
            opp.Training_T1_Date_VF__c = Date.today();
            controller.startHoursList = '11';
            controller.startMinsList = '12';
            controller.saveTraining();
        }catch(Exception e){
            System.debug('Error:'+e.getMessage());
        }
        
        try{
            opp.Training_T1_Date_VF__c = Date.today();
            controller.startHoursList = '11';
            controller.startHoursT2List = 'HH';
            controller.populateEndHours();
            controller.startMinsList = '12';
            controller.saveTraining();
        }catch(Exception e){
            System.debug('Error:'+e.getMessage());
        }
        
        try{
            opp.Training_T1_Date_VF__c = Date.today();
            controller.startHoursList = '11';
            controller.startHoursT2List = 'HH';
            controller.populateEndHours();
            controller.startMinsList = '12';
            controller.saveTraining();
        }catch(Exception e){
            System.debug('Error:'+e.getMessage());
        }
        
        try{
            opp.Training_T1_Date_VF__c = Date.today();
            controller.startHoursList = '11';
            controller.startHoursT2List = 'HH';
            controller.populateEndHours();
            controller.startMinsList = '12';
            controller.startMinsT2List = 'HH';
            controller.populateEndMins();
            controller.saveTraining();
        }catch(Exception e){
            System.debug('Error:'+e.getMessage());
        }
    }
}