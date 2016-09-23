public with sharing class ConfigurationCleanUpServiceHandler {
	public static List<String> classesToDelete;
	public static String sessionId;
   	public static string generateJsonForTrigger(Map<string, List<List<string>>> configurationList){
    	JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('data');
        gen.writeStartArray();
        Integer count = 1;	
        
        for(String objectName: configurationList.keySet()){
         	gen.writeStartObject();
        	gen.writeStringField('id', String.valueOf(count));
        	gen.writeStringField('name', objectName);
        	gen.writeStringField('enbl', '0');
        	gen.writeStringField('level', '0');
        	gen.writeStringField('parent', '');
        	gen.writeStringField('isLeaf', 'false');
        	gen.writeStringField('expanded', 'false');
        	gen.writeStringField('loaded', 'false');
        	gen.writeEndObject();
            Integer ChildCount = 0;
            
            for(List<String> configDetails : configurationList.get(objectName)){
                gen.writeStartObject();
        		gen.writeStringField('id', count + '' + (ChildCount+1));
        		gen.writeStringField('configID', configDetails[1]);
        		gen.writeStringField('name', configDetails[0]);
        		gen.writeStringField('enbl', '0');
        		gen.writeStringField('level', '1');
                gen.writeStringField('parentName', objectName);
        		gen.writeStringField('parent', String.valueOf(count));
        		gen.writeStringField('isLeaf', 'true');
        		gen.writeStringField('expanded', 'false');
        		gen.writeStringField('loaded', 'false');
        		gen.writeEndObject();
                ChildCount++;
            }
			count++;
        }
         gen.writeEndArray();
        gen.writeEndObject();
        return gen.getAsString();
    }
    public static string generateJsonForApexPage(List<ApexPage> configurationList){
    	JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('data');
        gen.writeStartArray();
        Integer count = 1;	
        
        for(ApexPage apexPageObj: configurationList){
         	gen.writeStartObject();
        	gen.writeStringField('id', String.valueOf(count));
        	gen.writeStringField('configID', apexPageObj.ID);
        	gen.writeStringField('name', apexPageObj.Name);
        	gen.writeStringField('enbl', '0');
        	gen.writeStringField('level', '0');
        	gen.writeStringField('parent', '');
        	gen.writeStringField('isLeaf', 'false');
        	gen.writeStringField('expanded', 'false');
        	gen.writeStringField('loaded', 'false');
        	gen.writeEndObject();
			count++;
        }
         gen.writeEndArray();
        gen.writeEndObject();
        return gen.getAsString();
    }
     public static string generateJsonForApexClass(List<ApexClass> lstAllApexClasses){
    	JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('data');
        gen.writeStartArray();
        Integer count = 1;	
        
        for(ApexClass apexClassObj: lstAllAPexClasses){
         	gen.writeStartObject();
        	gen.writeStringField('id', String.valueOf(count));
        	gen.writeStringField('configID', apexClassObj.ID);
        	gen.writeStringField('name', apexClassObj.Name);
        	gen.writeStringField('enbl', '0');
        	gen.writeStringField('level', '0');
        	gen.writeStringField('parent', '');
        	gen.writeStringField('isLeaf', 'false');
        	gen.writeStringField('expanded', 'false');
        	gen.writeStringField('loaded', 'false');
        	gen.writeEndObject();
			count++;
        }
         gen.writeEndArray();
        gen.writeEndObject();
        System.debug('gen.getAsString()='+gen.getAsString());
        return gen.getAsString();
    }
      public static string generateJsonForCustomField(Map<string, List<string>> configurationList){
       System.debug('In Service Handler ');
    	JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('data');
        gen.writeStartArray();
        Integer count = 1;	
        
        for(String objectName: configurationList.keySet()){
         	gen.writeStartObject();
        	gen.writeStringField('id', String.valueOf(count));
        	gen.writeStringField('name', objectName);
        	gen.writeStringField('enbl', '0');
        	gen.writeStringField('level', '0');
        	gen.writeStringField('parent', '');
        	gen.writeStringField('isLeaf', 'false');
        	gen.writeStringField('expanded', 'false');
        	gen.writeStringField('loaded', 'false');
        	gen.writeEndObject();
            Integer ChildCount = 0;
            
            for(String configDetails : configurationList.get(objectName))
            {
                gen.writeStartObject();
        		gen.writeStringField('id', count + '' + (ChildCount+1));
        		gen.writeStringField('configID', configDetails);
        		gen.writeStringField('name', configDetails);
        		gen.writeStringField('enbl', '0');
        		gen.writeStringField('level', '1');
                gen.writeStringField('parentName', objectName);
        		gen.writeStringField('parent', String.valueOf(count));
        		gen.writeStringField('isLeaf', 'true');
        		gen.writeStringField('expanded', 'false');
        		gen.writeStringField('loaded', 'false');
        		gen.writeEndObject();
                ChildCount++;
            }
			count++;
        }
        gen.writeEndArray();
        gen.writeEndObject();
        return gen.getAsString();
    }
     Public static List<String> SearchInClass(List<String> searchKeywords)
    {
        List<String> lstDependentCLasses = new List<String>();
        String keywordsToSearch;
        set<String> ClassSummary = new set<String>();
        List<String> lstclasses=new List<String>();
        for(String s:searchKeywords)
        {
        	keywordsToSearch=keywordsToSearch+s+' '+'OR ';
        }
        String preFinalString=keywordsToSearch.removeStart('null');
        String FinalString=preFinalString.removeEndIgnoreCase('OR ');
        //SOSL Dynamic Query
        String SearchQuery = 'FIND {'+FinalString+'}RETURNING ApexClass(Name)';
        List<Search.SearchResult> ClassSearchResult=ConfigurationSelector.selectclasses(SearchQuery);
        //Retriving Keyword Used in Class
        for (Search.SearchResult searchResult : ClassSearchResult) { 
        ApexClass Classes = (ApexClass) searchResult.getSObject(); 
        ClassSummary.add(Classes.Name);
        }
        ClassSummary.removeAll(searchKeywords);
        lstclasses.addAll(ClassSummary);
        Map<String, List<String>> SummaryMap = new Map<String, List<String>>();
        SummaryMap.put('ApexClass',lstclasses);
        return lstclasses; 
    }
    
    Public static List<String> SearchInTrigger(List<String> searchKeywords)
    {
        String keywordsToSearch;
        List<String> TriggerSummary = new list<String>();
        for(String s:searchKeywords)
        {
        	keywordsToSearch=keywordsToSearch+s+' '+'OR ';
        }
        String preFinalString=keywordsToSearch.removeStart('null');
        String FinalString=preFinalString.removeEndIgnoreCase('OR ');
        String SearchQuery = 'FIND {'+FinalString+'}RETURNING ApexTrigger(name)';
        List<Search.SearchResult> TriggersearchResults=ConfigurationSelector.selectTriggers(SearchQuery);
        //Retriving Keyword Used in Triggers
        for (Search.SearchResult TriggersResults : TriggersearchResults) { 
        ApexTrigger Triggers = (ApexTrigger) TriggersResults.getSObject();
            TriggerSummary.add(Triggers.Name);
        }
         Map<String, List<String>> SummaryMap = new Map<String, List<String>>();
        SummaryMap.put('ApexTrigger', TriggerSummary);
        return TriggerSummary;  
    }
    
    Public static List<String> SearchInPage(List<String> searchKeywords)
    {        
        //Retriving Keyword Used in Pages
        List<String> PageNames = new List<String>();
        PageNames=ConfigurationSelector.selectApexPages(searchKeywords);
         Map<String, List<String>> SummaryMap = new Map<String, List<String>>();
        SummaryMap.put('ApexPages', PageNames);
        return PageNames;
    }
    
    public static string generateJson(List<String> lstComponents){
    	JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('data');
        gen.writeStartArray();
        Integer count = 1;	
        
        for(String apexClassObj: lstComponents){
         	gen.writeStartObject();
        	gen.writeStringField('id', String.valueOf(count));
        	gen.writeStringField('configID', '');
        	gen.writeStringField('name', apexClassObj);
        	gen.writeStringField('enbl', '0');
        	gen.writeStringField('level', '0');
        	gen.writeStringField('parent', '');
        	gen.writeStringField('isLeaf', 'false');
        	gen.writeStringField('expanded', 'false');
        	gen.writeStringField('loaded', 'false');
        	gen.writeEndObject();
			count++;
        }
         gen.writeEndArray();
        gen.writeEndObject();
        System.debug('gen.getAsString()='+gen.getAsString());
        return gen.getAsString();
    }
    
    
    public static void deleteclasses(List<String> lstClassesToDelete,List<String> lstDependentClasses,List<String> lstDependentTriggers ,List<String> lstDependentPages)
    {
    	classesToDelete=new List<String>();
    	classesToDelete.addAll(lstClassesToDelete);
    	lstDependentClasses=SearchInClass(lstClassesToDelete);
    	lstDependentPages=SearchInPage(lstClassesToDelete);
    	lstDependentTriggers=SearchInTrigger(lstClassesToDelete);	
    	sessionId=UserInfo.getSessionId();
    	Integer count = System.purgeOldAsyncJobs(Date.today()+1);
    	Database.executeBatch(new CommentDependentClassBatch(lstClassesToDelete,lstDependentClasses,sessionId),10);
    	Database.executeBatch(new CommentDependentTriggersBatch(lstClassesToDelete,lstDependentTriggers,sessionId),10);
    	Database.executeBatch(new CommentDependentPagesBatch(lstClassesToDelete,lstDependentPages,sessionId),10);
    	ScheduleDeletionBatch();	
    }
    
    public static void ScheduleDeletionBatch(){
    	List<ApexClass> lstclasses=new List<ApexClass>();
        lstclasses=ConfigurationSelector.getApexClasses(classesToDelete);
        DeleteclassesBatch deletionBatch=new DeleteclassesBatch(lstclasses,sessionId);
        BatchScheduler scheduler = new BatchScheduler();
        scheduler.batchClass = deletionBatch;
       	if(BatchScheduler.schedulestatus==false || BatchScheduler.schedulestatus==null){
       		String day = string.valueOf(system.now().day());
	        String month = string.valueOf(system.now().month());
	        String hour = string.valueOf(system.now().hour());
	        String minute = string.valueOf(system.now().minute()+1);
	        String second = string.valueOf(system.now().second());
	        String year = string.valueOf(system.now().year());
	        String strJobName = 'Job-' + second + '_' + minute + '_' + hour + '_' + day + '_' + month + '_' + year;
	        String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
       		System.schedule(strJobName,strSchedule,scheduler);
        }
    }
    
   //Added
   public static string generateJsonForCustomData(List<String> configurationList)
   {
       System.debug('In Service Handler ');
       JSONGenerator gen = JSON.createGenerator(true);
       gen.writeStartObject();
       gen.writeFieldName('data');
       gen.writeStartArray();
       Integer count = 1; 
       
       for(String objectName: configurationList){
           gen.writeStartObject();
           gen.writeStringField('id', String.valueOf(count));
           gen.writeStringField('name', objectName);
           gen.writeStringField('enbl', '0');
           gen.writeStringField('level', '0');
           gen.writeStringField('parent', '');
           gen.writeStringField('isLeaf', 'false');
           gen.writeStringField('expanded', 'false');
           gen.writeStringField('loaded', 'false');
           gen.writeEndObject();
           count++;
       }
       gen.writeEndArray();
       gen.writeEndObject();
       System.debug('In Json Parser gen.getAsString()'+gen.getAsString());
       return gen.getAsString();
   }
}