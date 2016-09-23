global with sharing class CommentDependentPagesBatch implements Database.Batchable<String>, Database.Stateful, Database.AllowsCallouts{
	
	
	public List<String> lstFailedPages=new List<String>();
	public List<String> lstClassesToDelete=new List<String>();
	public List<String> lstPagesToComment=new List<String>();
	public String sessionId='';
	global CommentDependentPagesBatch(List<String> lstClassesForDelete,List<String> typeWiseMap,string sess){
		sessionId=sess;	
		System.debug('sessionId='+sessionId);
		lstPagesToComment=typeWiseMap;
		lstClassesToDelete=lstClassesForDelete;
	}
	
	global List<String> start(Database.BatchableContext BC){
		return lstPagesToComment;	
    }
    global void execute(Database.BatchableContext BC, List<String> scope){	
        try{
        		//CommentDependentClasses c=new CommentDependentClasses();
        		System.debug('sessionId='+sessionId);
        		for(String s:CommentDependents.CommentMultiplePages(scope,sessionId))
        		{
        			lstFailedPages.add(s);
        		} 
        		//lstFailedPages.addAll(c.CommentMultiplePages(scope,sessionId));
        		System.debug('lstFailedPages='+lstFailedPages);
        }
        catch(Exception e){
        	System.debug('Error:'+e);
        }
        	
    }
    global void finish(Database.BatchableContext BC){
    		System.debug('Inside CommentDependentPagesBatch finish');
    		String body;
	    	if(lstFailedPages.size()>0){
	    		body='Page='+lstFailedPages+' are not commented and will give errors while you compile. Please Comment these mannually';
	    	}
	    	else{
	    		body='All Pages are commented Successfully';
	    	}
	    	Id idOfCurrentBetch = BC.getJobId();
	        //List<AsyncApexJob> lstAsyncApexJob = new List<AsyncApexJob>();
	        List<ApexClass> lstclasses=new List<ApexClass>();
	        AsyncApexJob lstAsyncApexJob = ConfigurationSelector.asyncApexJobDetails(idOfCurrentBetch);
	        AsyncApexJob a=lstAsyncApexJob;
	    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        String[] toAddresses = new String[] {a.CreatedBy.Email};
	        mail.setToAddresses(toAddresses);
	        mail.setSubject('Details of Pages failed to Comment');
			mail.setPlainTextBody(body);
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			
			
			
			/*List<AsyncApexJob> lstAsyncApexJobNew=new List<AsyncApexJob>();
			List<String> lstJobNames=new List<String>();
			lstJobNames.add('CommentDependentPagesBatch');
			lstJobNames.add('CommentDependentClassBatch');
			lstJobNames.add('CommentDependentTriggersBatch');
			lstclasses=Configurationcleanupselector.getApexClasses(lstClassesToDelete);
			lstAsyncApexJobNew=Configurationcleanupselector.getAsyncApexJobStatus(lstJobNames);
			if(lstAsyncApexJobNew[0].status=='Completed' && lstAsyncApexJobNew[1].status=='Completed' && lstAsyncApexJobNew[2].status=='Completed')
			{
				Database.executeBatch(new DeleteclassesBatch(lstclasses,sessionId),10);
			}*/
			System.debug('Inside CommentDependentPagesBatch finish');
    }		    
}