/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
public class TATHelperTest {

    public static void createTATStageTestData(){
    	List<TAT_Stage__c> tatStageList = new List<TAT_Stage__c>();
    	tatStageList.add(new TAT_Stage__c(TAT_Stage__c = 'Candidate', Active__c = false));
    	tatStageList.add(new TAT_Stage__c(TAT_Stage__c = 'Ready to Onboard', Active__c = false));
    	tatStageList.add(new TAT_Stage__c(TAT_Stage__c = 'Ready to Invite', Active__c = false));
    	tatStageList.add(new TAT_Stage__c(TAT_Stage__c = 'Invited', Active__c = true));
    	tatStageList.add(new TAT_Stage__c(TAT_Stage__c = 'Pending min SKU creation', Active__c = true));
    	tatStageList.add(new TAT_Stage__c(TAT_Stage__c = 'Pending min Listings', Active__c = true));
    	tatStageList.add(new TAT_Stage__c(TAT_Stage__c = 'Pending Seller Approval', Active__c = true));
    	tatStageList.add(new TAT_Stage__c(TAT_Stage__c = 'Pending Stock Update', Active__c = true));
    	tatStageList.add(new TAT_Stage__c(TAT_Stage__c = 'Go Live Checklist', Active__c = true));
    	tatStageList.add(new TAT_Stage__c(TAT_Stage__c = 'Live', Active__c = true));
    	
    	insert tatStageList;
    }
    
    public static void createTATProfileTestData(){
    	List<TAT_Profile__c> tatProfileList = new List<TAT_Profile__c>();
    	tatProfileList.add(new TAT_Profile__c(TAT_Profile__c = '13 Days', Active__c = true));
    	tatProfileList.add(new TAT_Profile__c(TAT_Profile__c = '18 days', Active__c = true));
    	
    	insert tatProfileList;
    }
    
    public static void createTATSwimlineTestData(){
    	List<TAT_Swimline__c> tatSwimlineList = new List<TAT_Swimline__c>();
    	tatSwimlineList.add(new TAT_Swimline__c(TAT_Stage_Swimline__c = 'In Progress', Active__c = true));
    	tatSwimlineList.add(new TAT_Swimline__c(TAT_Stage_Swimline__c = 'Drop', Active__c = true));
    	tatSwimlineList.add(new TAT_Swimline__c(TAT_Stage_Swimline__c = 'Parked', Active__c = true));
    	tatSwimlineList.add(new TAT_Swimline__c(TAT_Stage_Swimline__c = 'Training1 (Listings)', Active__c = true));
    	tatSwimlineList.add(new TAT_Swimline__c(TAT_Stage_Swimline__c = 'Training2 (Policy + Payments)', Active__c = true));
    	tatSwimlineList.add(new TAT_Swimline__c(TAT_Stage_Swimline__c = 'Training3 (OM Returns Disputes)', Active__c = true));
    	
    	insert tatSwimlineList;
    }
    
    public static void createTATStageProfile13TestData(){
    	List<TAT_Stage_Profile__c> tatStageProfileList = new List<TAT_Stage_Profile__c>();
    	TATHelperTest.createTATStageTestData();
    	TATHelperTest.createTATProfileTestData();
    	List<TAT_Stage__c> tatStageList = [SELECT Id, TAT_Stage__c FROM TAT_Stage__c WHERE Active__c = true ORDER BY Name];
    	List<TAT_Profile__c> tatProfileList = [SELECT Id FROM TAT_Profile__c WHERE TAT_Profile__c = '13 Days'];
    	ID tatProfile13ID = null;
    	
    	for(TAT_Profile__c profile : tatProfileList){
    		tatProfile13ID = profile.Id;
    	}
    	
    	Integer i = 2;
    	for(TAT_Stage__c stage : tatStageList){
    		TAT_Stage_Profile__c tatStageProfile = new TAT_Stage_Profile__c();
    		tatStageProfile.TAT_Stage_ID__c = stage.Id;
    		tatStageProfile.TAT_Profile_ID__c = tatProfile13ID;
    		tatStageProfile.TAT_Profile_Spec__c = i;
    		tatStageProfileList.add(tatStageProfile);
    	}
    	insert tatStageProfileList;
    }
    
    public static void createTATStageProfile18TestData(){
    	List<TAT_Stage_Profile__c> tatStageProfileList = new List<TAT_Stage_Profile__c>();
    	TATHelperTest.createTATStageTestData();
    	TATHelperTest.createTATProfileTestData();
    	List<TAT_Stage__c> tatStageList = [SELECT Id, TAT_Stage__c FROM TAT_Stage__c WHERE Active__c = true ORDER BY Name];
    	List<TAT_Profile__c> tatProfileList = [SELECT Id FROM TAT_Profile__c WHERE TAT_Profile__c = '18 Days'];
    	ID tatProfile18ID = null;
    	
    	for(TAT_Profile__c profile : tatProfileList){
    		tatProfile18ID = profile.Id;
    	}
    	
    	Integer i = 3;
    	for(TAT_Stage__c stage : tatStageList){
    		TAT_Stage_Profile__c tatStageProfile = new TAT_Stage_Profile__c();
    		tatStageProfile.TAT_Stage_ID__c = stage.Id;
    		tatStageProfile.TAT_Profile_ID__c = tatProfile18ID;
    		tatStageProfile.TAT_Profile_Spec__c = i;
    		tatStageProfile.Active__c = true;
    		tatStageProfileList.add(tatStageProfile);
    	}
    	insert tatStageProfileList;
    }
}