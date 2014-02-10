public class MultipleSelectTryClass {
    public List<BrandDetailsWrapper>  brandWrapperList{get;set;}
    public String leadId;
    public String leadName;
    public String superCategory;
    
    public String[] dynamicParentSelect {public get; public set;}
    public String[] dynamicChildSelect {get;set;}
    
    Map<String, Verticals_Selling__c> verticals = Verticals_Selling__c.getAll(); 
    Map<String, sub_category__c> allSubs = sub_category__c.getAll();
    
    List<String> verticalNames = new List<String>();
    List<String> subNames = new List<String>();    
    
    
    Map<String, List<String>> parentChildRel = new Map<String, List<String>>();
	List<String> subDetails = new List<String>();
    
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

    public MultipleSelectTryClass() {
    	System.debug('Constructor');
    	verticalNames.addAll(verticals.keySet());
        verticalNames.sort();
        
        subNames.addAll(allSubs.keySet());
        subNames.sort();
         
    	
    	for(String v:verticalNames){
    		Verticals_Selling__c vertical = verticals.get(v);
    		for(String s: subNames){
    			sub_category__c sub = allSubs.get(s);
    			if(vertical.Vertical_Seller_ID__c == sub.Vertical_Seller_ID__c ){
    				subDetails.add(sub.Subcategories_Selling_in__c);
    			}
    		}
    		parentChildRel.put(vertical.Verticals_Selling_Name__c,subDetails);
    	}
    	
        brandWrapperList= new List<BrandDetailsWrapper>();
        for (Integer i=0; i<2; i++){
            brandWrapperList.add(new BrandDetailsWrapper(leadId));
        }
    }
    
    public PageReference refreshList(){
    	/*Map<String, List<String>> parentChildRel = new Map<String, List<String>>();
    	List<String> subDetails = new List<String>(); 
    	
    	for(String v:verticalNames){
    		Verticals_Selling__c vertical = verticals.get(v);
    		for(String s: subNames){
    			sub_category__c sub = allSubs.get(s);
    			if(vertical.Vertical_Seller_ID__c == sub.Vertical_Seller_ID__c ){
    				subDetails.add(sub.Subcategories_Selling_in__c);
    			}
    		}
    		parentChildRel.put(vertical.Verticals_Selling_Name__c,subDetails);
    	}*/
    	return null;
    }
    
    
    public List<SelectOption> getDynamicParentOptions() {
        List<SelectOption> options = new List<SelectOption>();
        System.debug('Called Parent');
        if(verticalNames.size()>0){
        	for (String verticalName : verticalNames) {
	            Verticals_Selling__c vertical = verticals.get(verticalName);
	            options.add(new SelectOption(vertical.Verticals_Selling_Name__c, vertical.Verticals_Selling_Name__c));
	        }	
        }
        
        return options;
    }
    
    public List<SelectOption> getDynamicChildOptions() {
        List<SelectOption> options = new List<SelectOption>();
        System.debug('Called Child'+dynamicParentSelect);
        
        if ( dynamicParentSelect != null && dynamicParentSelect.size() > 0 ) {
        	System.debug('In DynamicParent Select'+dynamicParentSelect.size());
            Set<String> possibleOpts = new Set<String>();
            for ( String val : dynamicParentSelect ){
                possibleOpts.addAll(parentChildRel.get(val));
            }
            for ( String s : possibleOpts )
                options.add(new SelectOption(s, s));
        }else{
        	System.debug('Else In DynamicParent Select');
	        for (String subName : subNames) {
	            sub_category__c sub = allSubs.get(subName);
	            options.add(new SelectOption(sub.Subcategories_Selling_in__c, sub.Subcategories_Selling_in__c));
	        }
        }
    
        return options;
    }
    
    

    public PageReference saveBrandList() {
        List<Brand_Details__c> brandDetailsList = new List<Brand_Details__c>();
        
        for (BrandDetailsWrapper brandWrap: brandWrapperList){
            brandWrap.brandDetails.Lead__c = leadId;
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