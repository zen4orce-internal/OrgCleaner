public with sharing class ConfigurationSelector {
    public static List<ApexTrigger> getTriggers()
    {
        List<ApexTrigger> triggerList = new List<ApexTrigger>([Select TableEnumOrId,Name from ApexTrigger]);
        return triggerList;
    }
    public static List<ApexPage> getVisualforcePages(){      
        List<ApexPage> apexPageList = new List<ApexPage>([Select Id, Name From Apexpage]);
        return apexPageList;
    }
    public static List<ApexClass> getApexClasses(){      
        List<ApexClass> apexClassList=new List<ApexClass>([select Id,Name from ApexClass]);
  		return apexClassList;
    }
     public static List<Search.SearchResult> selectclasses(String SearchQuery)
    {
		//System.debug('searchResults of class');
    	Search.SearchResults searchResults = Search.find(SearchQuery);
    	return searchResults.get('ApexClass');
    } 
    //get triggers
    public static List<Search.SearchResult> selectTriggers(String SearchQuery)
    {
		//System.debug('searchResults in Trigger');
    	Search.SearchResults searchResults = Search.find(SearchQuery);
    	return searchResults.get('ApexTrigger');
    }
    //get visiualforce pages
    public static List<String> selectApexPages(List<String> searchKeywords)
    {
    	//System.debug('Inside Selector class selectApexPages');
    	//for(String s:searchKeywords)
    	//{
    		//System.debug('Page to search='+s);
    	//}
    	Map<ID, ApexPage> ApexpageBody = new Map<ID, ApexPage>([SELECT Id,Name,Markup FROM ApexPage]);
    	List<String> PageNames = new List<String>();
    	for(String s:searchKeywords)
        {
	        for (ID idKey : ApexpageBody.keyset()) 
	        {
	            ApexPage a = ApexpageBody.get(idKey);
	            	//System.debug('a.pageName'+a.Name);
	            	String pageMarkup=a.Markup.normalizeSpace();
	            	String pageName=pageMarkup.substringAfter('=');
	            	String finalPageName=pageName.substringBefore('>');
	            	//System.debug('finalPageName='+finalPageName);
	            	//finalPageName.trim();
	            	//finalPageName.replace('"','');
	            	//System.debug('finalPageName='+finalPageName);
	            	//System.debug('pageMarkup='+pageMarkup);
		            //Boolean PageSearchResult = a.Markup.contains(s);
		           // System.debug('pageName='+finalPageName);
		           // System.debug('s='+s);
		            //if(PageSearchResult)
		            if(finalPageName=='"'+s+'"' || finalPageName==s)
		            {
		                PageNames.add(a.Name);
		            }
	        }
        }
        return PageNames;
    }
    
    //Added for Apex Classes deletion
    public static Map<ID, ApexClass> getApexClassBody(String className)
  	{
  		return new Map<ID, ApexClass>([SELECT Id,Body,Name FROM ApexClass where Name=:className]);
  	}
  	public static Map<ID, ApexTrigger> getApexTrigger(String triggerName)
   {
   		return new Map<ID, ApexTrigger>([SELECT Id,Body,Name FROM ApexTrigger where Name=:triggerName]);	
   }
   //get visiualforcePageMarkup
    public static ApexPage selectApexPagemarkup(String pageName)
    {
    	ApexPage ApexPageBody = ([SELECT Id,Markup,Name FROM ApexPage where Name=:pageName]);
    	return ApexPageBody;
    }
    
    public static AsyncApexJob asyncApexJobDetails(Id idOfJob)
    {
        AsyncApexJob a;
        if(idOfJob != null)
        {
          a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                    TotalJobItems, CreatedBy.Email
                  FROM AsyncApexJob WHERE Id =:idOfJob];
        }
   		return a;
   }
   
    public static List<ApexClass> getApexClasses(List<String> lstNameOfClasses)
    {
    	List<ApexClass> lstclasses=new List<ApexClass>([select Id,Name from ApexCLass where Name IN:lstNameOfClasses]);
    	return  lstclasses;
    }
    
    public static List<AsyncApexJob> getAsyncApexJobStatus(List<String> lstAsyncApexJobNames){
  		System.debug('lstAsyncApexJobNames='+lstAsyncApexJobNames);
  		return new List<AsyncApexJob>([Select ApexClass.Name,ApexClassID,status from AsyncApexJob where ApexClass.name IN:lstAsyncApexJobNames]);
  	}
    //Query for find NamespacePrefix of your Organization
    public static string nameSpaceprefixOfOrg()
    {
        String nameSpace;
        Organization org = [SELECT NamespacePrefix FROM Organization];
        nameSpace = String.valueOf(org.NamespacePrefix);
        return nameSpace;
    }
}