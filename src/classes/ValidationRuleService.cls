public with sharing class ValidationRuleService {
	public static Map<string, List<List<String>>> getValidationRules()
    {
    	Map<string, List<List<String>>> ValidationRuleMap = new Map<string, List<List<String>>>();
    	MetadataAPI mapi = new MetadataAPI();
        MetadataService.FileProperties[] fileproperties = mapi.listValidationRuleMetadata();
        if(fileproperties != null){
        	list<String> ValidationRuleName;
            list<List<String>> ValidationRuleName1;
    		for(MetadataService.FileProperties fileProperty : fileproperties)
    		{
	    		if(fileProperty.fullName != null && fileProperty.fullName != '')
    	        {
        	        ValidationRuleName = new List<String>();  
                    ValidationRuleName1 = new List<List<String>>();
            	    string Objectname = fileProperty.fullName;
                	if(ValidationRuleMap.containsKey(Objectname.substringBefore('.')))
                	{ 
                    	ValidationRuleName1.addAll(ValidationRuleMap.get(Objectname.substringBefore('.')));
                    	ValidationRuleName.add(Objectname.substringAfter('.'));  
                        ValidationRuleName.add(fileProperty.ID); 
                        ValidationRuleName1.add(ValidationRuleName);
                	}
                	else{
	                    ValidationRuleName.add(Objectname.substringAfter('.'));
                        ValidationRuleName.add(fileProperty.ID); 
                        ValidationRuleName1.add(ValidationRuleName);
    	            }
        	       	ValidationRuleMap.put(Objectname.substringBefore('.'), ValidationRuleName1);      
    			}
    		}
        }
    	return ValidationRuleMap;         
    }
    public static void deleteValidationRules(List<String> selectedValidationRules)
    {
        Map<string, List<String>> validationRulesMap = new Map<string, List<String>>();
        validationRulesMap.put('ValidationRule', selectedValidationRules);
        Id batchJobId = database.executeBatch(new ConfigurationCleanUpBatchService(validationRulesMap),100);
        System.debug('batchJobId Validation Rule- ' + batchJobId);
        
        //MetadataAPI mapi = new MetadataAPI();
        //mapi.deleteWorkflow(selectedWorkflows);
    }
}