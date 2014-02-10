/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class MultipleBrandDetailsTest {

    static testMethod void vfPageTest() {
    	List<MultipleBrandDetailsClass.BrandDetailsWrapper>  brandWrapperListTemp = new List<MultipleBrandDetailsClass.BrandDetailsWrapper>();
    	Lead testLead = UtilityClassTest.createLeadTestRecord();
    	PageReference pageRef = Page.MultipleBrandDetailsPage;
        Test.setCurrentPage(pageRef);
        
        MultipleBrandDetailsClass mbc = new MultipleBrandDetailsClass();
        
        MultipleBrandDetailsClass.BrandDetailsWrapper bdw = new MultipleBrandDetailsClass.BrandDetailsWrapper(testLead.Id);
        bdw.brandDetails = new Brand_Details__c();
        bdw.brandDetails.Name = 'Test';
        bdw.brandDetails.Brand_Name__c = 'Test';
        bdw.brandDetails.Brand_Age__c = 20;
        brandWrapperListTemp.add(bdw);
        
        mbc.brandWrapperList = brandWrapperListTemp;
        mbc.saveBrandList();
    }
    
 	static testMethod void cancelButton() {
 		
 		PageReference pageRef = Page.MultipleBrandDetailsPage;
        Test.setCurrentPage(pageRef);
        
        MultipleBrandDetailsClass mbc = new MultipleBrandDetailsClass();
        mbc.cancelButton();
 		
 	}   
 	
 	static testMethod void addButton() {
 		
 		List<MultipleBrandDetailsClass.BrandDetailsWrapper>  brandWrapperListTemp = new List<MultipleBrandDetailsClass.BrandDetailsWrapper>();
    	Lead testLead = UtilityClassTest.createLeadTestRecord();
    	testLead.SuperCategory__c = 'CCC';
    	update testLead;
    	
    	PageReference pageRef = Page.MultipleBrandDetailsPage;
        Test.setCurrentPage(pageRef);
        
		System.currentPageReference().getParameters().put('leadId', testLead.Id);
		System.currentPageReference().getParameters().put('leadName', testLead.Name);
		System.currentPageReference().getParameters().put('supCat', testLead.SuperCategory__c);
        
        MultipleBrandDetailsClass mbc = new MultipleBrandDetailsClass();
        System.debug('Lead Id'+mbc.getLeadId());
        System.debug('Lead Name'+mbc.getLeadName());
        System.debug('Lead SuperCategory'+mbc.getSuperCategory());
        
        MultipleBrandDetailsClass.BrandDetailsWrapper bdw = new MultipleBrandDetailsClass.BrandDetailsWrapper(testLead.Id);
        bdw.brandDetails = new Brand_Details__c();
        bdw.brandDetails.Name = 'Test';
        bdw.brandDetails.Brand_Name__c = 'Test';
        bdw.brandDetails.Brand_Age__c = 20;
        brandWrapperListTemp.add(bdw);
        bdw.brandDetails = new Brand_Details__c();
        bdw.brandDetails.Name = 'Test2';
        bdw.brandDetails.Brand_Name__c = 'Test2';
        bdw.brandDetails.Brand_Age__c = 20;
        brandWrapperListTemp.add(bdw);
        mbc.Add();
 		
 	} 
}