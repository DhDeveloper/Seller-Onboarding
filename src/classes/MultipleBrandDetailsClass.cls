/**
  * This Apex class used for visualforce page MultipleBrandDetailsPage.
  * Add new row and Save All records functionality defined in this class.
**/
public class MultipleBrandDetailsClass {
    public List<BrandDetailsWrapper>  brandWrapperList{get;set;}
    public String leadId;
    public String leadName;
    public String superCategory;
    
    public String getLeadId(){
        leadId = ApexPages.currentPage().getParameters().get('leadId');
        return leadId;
    }
    
    public String getLeadName(){
        leadName = ApexPages.currentPage().getParameters().get('leadName');
        return leadName;
    }
    
    public String getSuperCategory(){
        superCategory = ApexPages.currentPage().getParameters().get('supCat');
        return superCategory;
    }

    public void Add() {
        for (Integer i=0; i<1; i++){
           brandWrapperList.add(new BrandDetailsWrapper(leadId));
        }
    }

    public MultipleBrandDetailsClass() {
        brandWrapperList= new List<BrandDetailsWrapper>();
        for (Integer i=0; i<2; i++){
            brandWrapperList.add(new BrandDetailsWrapper(leadId));
        }
    }

    public PageReference saveBrandList() {
        List<Brand_Details__c> brandDetailsList = new List<Brand_Details__c>();
        
        for (BrandDetailsWrapper brandWrap: brandWrapperList){
            brandWrap.brandDetails.Lead__c = leadId;
            brandWrap.brandDetails.Super_Category__c = superCategory;
            brandDetailsList.add(brandWrap.brandDetails);
        }
           
        insert brandDetailsList; 
        
        return  new PageReference('/'+leadId);
    }
    
    public PageReference cancelButton() {
        return  new PageReference('/'+leadId);
    }
    
    public class BrandDetailsWrapper{
        public Brand_Details__c  brandDetails{get; set;}
       
        public BrandDetailsWrapper(String leadIdInput){
            brandDetails = new Brand_Details__c();
            //brandDetails.Lead__c = leadId;
        }
     }

}