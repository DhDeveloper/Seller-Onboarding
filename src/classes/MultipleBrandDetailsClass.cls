public class MultipleBrandDetailsClass {
    public List<BrandDetailsWrapper>  brandWrapperList{get;set;}
    public String leadId;
    public String superCategory;
    
    public String getLeadId(){
        leadId = ApexPages.currentPage().getParameters().get('leadId');
        
        return leadId;
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
        for (Integer i=0; i<5; i++){
            brandWrapperList.add(new BrandDetailsWrapper(leadId));
        }
    }

    public PageReference saveBrandList() {
        List<Brand_Details__c> brandDetailsList = new List<Brand_Details__c>();
        
        for (BrandDetailsWrapper brandWrap: brandWrapperList){
            brandDetailsList.add(brandWrap.brandDetails);
        }
           
        insert brandDetailsList; 
        
        return null;
    }
    
    public class BrandDetailsWrapper{
        public Brand_Details__c  brandDetails{get; private set;}
       
        public BrandDetailsWrapper(String leadId){
            brandDetails = new Brand_Details__c();
            //brandDetails.Lead__c = leadId;
        }
     }

}