public class someController {

    public String[] parentPicklistVal {public get; public set;}
    public String[] childMultiPicklistVal {public get; public set;}

    // maps to hold your dependencies between picklists
    private Map<String, List<String>> parentDepMap;
    private Map<String, List<String>> childDepMap;

    private String[] parentOpts = new String[] { 'parent option 1', 'parent option 2' };
    private String[] childMultiOpts = new String[] { 'child multi 1', 'child multi 2', 'child multi 3' };

    public someController() {
        // init dependency maps
        parentDepMap = new Map<String, List<String>>();
        childDepMap = new Map<String, List<String>>();

        // pick which child options to display for which parent value
        parentDepMap.put(parentOpts[0], (new String[]{childMultiOpts[0], childMultiOpts[1]}));
        parentDepMap.put(parentOpts[1], (new String[]{childMultiOpts[1], childMultiOpts[2]}));
    }

    public List<SelectOption> getParentPicklistOptions() {
        List<SelectOption> selectOpts = new List<SelectOption>();
        for ( String s : parentOpts )
            selectOpts.add(new SelectOption(s, s));
        return selectOpts;
    }

    public List<SelectOption> getChildMultiPicklistOptions() {
        List<SelectOption> selectOpts = new List<SelectOption>();
        if ( parentPicklistVal != null && parentPicklistVal.size() > 0 ) {
            // build a set of values to avoid dupes, since there may be overlapping dependencies
            Set<String> possibleOpts = new Set<String>();
            for ( String val : parentPicklistVal )
                possibleOpts.addAll(parentDepMap.get(val));
            for ( String s : possibleOpts )
                selectOpts.add(new SelectOption(s, s));
        }
        return selectOpts;
    }
    
    public PageReference actionUpdatePicklistVals() {
        // this doesn't really need to do anything, since the picklists should be updated when their getters call after returning
        return null;
    }

}