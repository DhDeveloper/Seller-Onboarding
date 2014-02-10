public class MultiSelectController {
	public Lead lead;
	public String[] parentPicklistVal {public get; public set;}
	public String[] selectedparentPicklistVal {public get; public set;}
	public String[] childPicklistVal {public get; public set;}
	public String[] selectedchildPicklistVal {public get; public set;}
	
	public List<SelectOption> ParentPicklistOptions{get;set;}
	public List<SelectOption> SelectedParentPicklistOptions{get;set;}
	public List<SelectOption> ChildPicklistOptions{get;set;}
	public list<SelectOption> SelectedChildPicklistOptions{get;set;}
	
	public list<string> lstgroup=new list<string>();
	public list<string> lstSubgroup=new list<string>();
	private Map<String, List<String>> parentChildMap;
	
	public boolean bIsRemoved{get;set;}
	public boolean bIsRemovedChild{get;set;}
	public boolean bIsAddChild{get;set;}
	
	public List<String> parentOpts = new List<String>();
	public List<String> childMultiOpts = new List<String>();
	
	
    public MultiSelectController(ApexPages.StandardController controller) {
    	lead = (Lead)controller.getRecord();
        MultiSelectDefaultLoad();
    }
    
	
	public void MultiSelectDefaultLoad(){
	    bIsRemoved=false;
	    bIsRemovedChild=false;
	    bIsAddChild=false;
	    
		Map<String, sub_category__c> allSubs = sub_category__c.getAll();
		parentOpts.addAll(allSubs.keySet());
		parentOpts.sort();  	
	
		Map<String, Verticals_Selling__c> verticals = Verticals_Selling__c.getAll(); 
		childMultiOpts.addAll(verticals.keySet());
        childMultiOpts.sort();  
        
        list<string> lstOne = null;	
        
        parentChildMap = new Map<String, List<String>>();
	    
		Integer i = 0;
		
		for(String s: parentOpts){
			lstOne = new list<string>(); 
			sub_category__c sub = allSubs.get(s);
			for(String v: childMultiOpts){
				Verticals_Selling__c ver = verticals.get(v);
				if(sub.Vertical_Seller_ID__c == ver.Vertical_Seller_ID__c ){
					lstOne.add(v);
				}
			}
			parentChildMap.put(parentOpts[i], lstOne);
			i++;
		}	
	
	    ParentPicklistOptions=new List<SelectOption>();
	    SelectedParentPicklistOptions=new List<SelectOption>();
	    ChildPicklistOptions=new List<SelectOption>();
	    SelectedChildPicklistOptions=new List<SelectOption>();
	
	    List<SelectOption> selectOpts = new List<SelectOption>();
	    for(String s : parentOpts  ){
	        selectOpts.add(new SelectOption(s, s));
	    }
	     
	    ParentPicklistOptions.addAll(selectOpts);
	
	}
	
	public PageReference actionUpdatePicklistVals() {
        bIsRemoved=false;
        List<SelectOption> selectOpts = new List<SelectOption>();
        if (parentPicklistVal != null && parentPicklistVal.size() > 0 ) {
           for(String s : parentPicklistVal ){
                selectOpts.add(new SelectOption(s, s));
            }    
        }
        
        SelectedParentPicklistOptions.addAll(selectOpts);
        
        List<System.SelectOption> AllPRaentSelectedVal=SelectedParentPicklistOptions;
        
        set<string> setselectVal=new set<string>();
        
        for(System.SelectOption opt:AllPRaentSelectedVal){
            setselectVal.add(opt.getvalue());
        }
        
        
        ParentPicklistOptions.clear();
        
        List<SelectOption> selectOpts2 = new List<SelectOption>();
        for(String s : parentOpts  ){
            if(!setselectVal.contains(s))
            selectOpts2.add(new SelectOption(s, s));
        }
     
        ParentPicklistOptions.addAll(selectOpts2);
        
        fCallAddToChildAvailableList();
    
        
        return null;
    }
    
    public void fCallAddToChildAvailableList(){
    
        List<System.SelectOption> AllPRaentSelectedVal=SelectedParentPicklistOptions;
        
        set<string> setselectVal=new set<string>();
        
        for(System.SelectOption opt:AllPRaentSelectedVal){
            setselectVal.add(opt.getvalue());
        }
        
        List<SelectOption> selectOpts = new List<SelectOption>();
        Set<String> possibleOpts = new Set<String>();
        for ( String val : setselectVal){
            if(parentChildMap.get(val)!=null)
            possibleOpts.addAll(parentChildMap.get(val));
        }
        
        list<system.Selectoption> AllselectedChildPickListOption=SelectedChildPicklistOptions;
        
        set<string> setselectedChildOpt=new set<string>();
        
        for(System.SelectOption opt:AllselectedChildPickListOption){
            setselectedChildOpt.add(opt.getvalue());
        }
            
        for ( String s : possibleOpts ){
            if(!setselectedChildOpt.contains(s))
            selectOpts.add(new SelectOption(s, s));
        }    
        ChildPicklistOptions.clear();
        ChildPicklistOptions.addAll(selectOpts);        
    }
        
    public PageReference addChildPicklistVals(){
        bIsRemovedChild=false;
        bIsAddChild=true;
        
        List<SelectOption> selectOpts = new List<SelectOption>();
        if (childPicklistVal != null && childPicklistVal .size() > 0 ) {
           for(String s : childPicklistVal ){
                selectOpts.add(new SelectOption(s, s));
            }    
        }
        
        
        SelectedChildPicklistOptions.addAll(selectOpts);
        ChildPicklistOptions.clear();
        
        List<System.SelectOption> AllPRaentSelectedVal=SelectedParentPicklistOptions;
        
        set<string> setselectVal=new set<string>();
        
        for(System.SelectOption opt:AllPRaentSelectedVal){
            setselectVal.add(opt.getvalue());
        }
        
        List<SelectOption> selectOpts2 = new List<SelectOption>();
        Set<String> possibleOpts = new Set<String>();
        for ( String val : setselectVal){
            if(parentChildMap.get(val)!=null)
            possibleOpts.addAll(parentChildMap.get(val));
        }    
        list<system.Selectoption> AllselectedChildPickListOption=SelectedChildPicklistOptions;
        
        set<string> setselectedChildOpt=new set<string>();
        
        for(System.SelectOption opt:AllselectedChildPickListOption){
            setselectedChildOpt.add(opt.getvalue());
        }
        
        for (String s : possibleOpts ){
            if(!setselectedChildOpt.contains(s))
            selectOpts2.add(new SelectOption(s, s));
        }
        ChildPicklistOptions.addAll(selectOpts2);
        
        
        return null;
    }   
  
 	public PageReference actionRemovePicklistVals() {
        // this doesn't really need to do anything, since the picklists should be updated when their getters call after returning
        bIsRemoved=true;
        
        set<string> setRemoveSelected=new set<string>();
        if (selectedparentPicklistVal != null && selectedparentPicklistVal .size() > 0 ) {
           for(String s : selectedparentPicklistVal){
                setRemoveSelected.add(s);
            }    
        }
        
        List<System.SelectOption> AllPRaentSelectedVal=SelectedParentPicklistOptions;
        
        set<string> setselectVal=new set<string>();
        
        for(System.SelectOption opt:AllPRaentSelectedVal){
            setselectVal.add(opt.getvalue());
        }
        
        setselectVal.removeAll(setRemoveSelected);
        
        SelectedParentPicklistOptions.clear();
        
        List<SelectOption> selectOpts2 = new List<SelectOption>();
        
        for(string s:setselectVal){
            selectOpts2.add(new SelectOption(s, s));
        }
        
        SelectedParentPicklistOptions.addAll(selectOpts2);
        
        RefreshParentOption();
        RefreshChildOption();
        
        
        return null;
    }
    
    public void RefreshParentOption(){
    
        ParentPicklistOptions.clear();
        
        List<System.SelectOption> AllPRaentSelectedVal=SelectedParentPicklistOptions;
        
        set<string> setselectVal=new set<string>();
        
        for(System.SelectOption opt:AllPRaentSelectedVal){
            setselectVal.add(opt.getvalue());
        }
        
        List<SelectOption> selectOpts2 = new List<SelectOption>();
        for(String s : parentOpts  ){
            if(!setselectVal.contains(s))
            selectOpts2.add(new SelectOption(s, s));
        }
     
        ParentPicklistOptions.addAll(selectOpts2);
    
    
    }
    
    public void RefreshChildOption(){
    
        ChildPicklistOptions.clear();
        
        List<System.SelectOption> AllPRaentSelectedVal=SelectedParentPicklistOptions;
        
        set<string> setselectVal=new set<string>();
        
        for(System.SelectOption opt:AllPRaentSelectedVal){
            setselectVal.add(opt.getvalue());
        }
        
        List<SelectOption> selectOpts2 = new List<SelectOption>();
        Set<String> possibleOpts = new Set<String>();
        for ( String val : setselectVal){
            if(parentChildMap.get(val)!=null)
            possibleOpts.addAll(parentChildMap.get(val));
        }
        
        list<system.SelectOption> lstSelectedChildPickListOpt=SelectedChildPicklistOptions;
        set<string> setAlreadySelectedChildPickListVal=new set<string>();
        
        for(system.SelectOption opt:lstSelectedChildPickListOpt){
            setAlreadySelectedChildPickListVal.add(opt.getValue());
        }
        
        list<system.selectoption> lstSelectOpt=new list<system.selectoption>();
        for (String s : possibleOpts ){
            if(!setAlreadySelectedChildPickListVal.contains(s))
                lstSelectOpt.add(new SelectOption(s, s));
        }
        ChildPicklistOptions.addAll(lstSelectOpt);
        
        
    
    }
    
    public PageReference RemoveChildPicklistVals(){
        //bIsRemovedChild=true;
        //bIsAddChild=false;
        
        set<string> setSelectedChildItem=new set<string>();
        if(selectedchildPicklistVal!=null && selectedchildPicklistVal.size()>0){
            for(string s:selectedchildPicklistVal){
                setSelectedChildItem.add(s);
            }
        }
        
        list<system.SelectOption> lstSelectedChildOption=new list<system.SelectOption>();
        lstSelectedChildOption=SelectedChildPicklistOptions;
        
        set<string> setAllOptionSelectedChild=new set<string>();
        
        for(system.SelectOption opt:lstSelectedChildOption){
            setAllOptionSelectedChild.add(opt.getValue());
        }
        
        setAllOptionSelectedChild.removeAll(setSelectedChildItem);
        
        list<system.selectoption> lstSelectOpt=new list<system.selectoption>();
        for(string s:setAllOptionSelectedChild){
            lstSelectOpt.add(new SelectOption(s, s));
        }
        
        SelectedChildPicklistOptions.clear();
        SelectedChildPicklistOptions.addAll(lstSelectOpt);
        RefreshChildOption();
        return null;
    }
    
    public PageReference saveBrandDetails() {
    	String tempStr = '';
    	
        List<System.SelectOption> AllPRaentSelectedVal = SelectedParentPicklistOptions;
        
        for(System.SelectOption opt:AllPRaentSelectedVal){
            tempStr = tempStr + opt.getvalue() + ';';
        }
        
        System.debug('tempStr:'+tempStr);
    	
    	lead.Subcategories_Values__c = tempStr;
    	
    	update lead;
        
        return  null;
    }

}