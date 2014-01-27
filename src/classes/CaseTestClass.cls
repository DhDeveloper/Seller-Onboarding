/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CaseTestClass {

    @isTest(SeeAllData=true)
    static void createCaseRecord() {
    	Opportunity opp = UtilityClassTest.createOpportunityTestRecord();
        Case caseRecord = new Case();
        caseRecord.Opportunity__c = opp.Id;
        caseRecord.Issue_Type__c = 'Any other CMS';
        caseRecord.Priority = 'Normal';
        caseRecord.Status = 'new';
        caseRecord.Origin = 'Salesforce';
        caseRecord.Subject = 'Test Subject Line';
        caseRecord.Description = 'Test Description Line';
        
        Test.startTest();
        insert caseRecord;
        Test.stopTest();
        
        System.debug('Ticket ID: '+caseRecord.OTRS_Ticket_ID__c);
        System.debug('Ticket Number: '+caseRecord.OTRS_Ticket_Number__c);
        System.debug('Link: '+caseRecord.OTRS_Ticket_Link__c);
    }
}