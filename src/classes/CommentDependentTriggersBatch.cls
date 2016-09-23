global with sharing class CommentDependentTriggersBatch implements Database.Batchable<String>, Database.Stateful, Database.AllowsCallouts{
	
	public List<String> lstClassesToDelete=new List<String>();
	public List<String> lstTriggersToComment=new List<String>();
	public List<String> lstFailedTriggers=new List<String>();
	public String sessionId='';
	public map<String,List<String>> failedComponentsToComment=new map<String,List<String>>();
	global CommentDependentTriggersBatch(List<String> lstClassesForDelete,List<String> typeWiseMap,string sess){
		sessionId=sess;	
		System.debug('sessionId='+sessionId);
		lstTriggersToComment=typeWiseMap;
		lstClassesToDelete=lstClassesForDelete;
	}
	
	global List<String> start(Database.BatchableContext BC){
		return lstTriggersToComment;	
    }
    global void execute(Database.BatchableContext BC, List<String> scope){	
        try{
        		//CommentDependentClasses c=new CommentDependentClasses();
        		//lstFailedTriggers=failedComponentsToComment.get('ApexTrigger');
        		System.debug('sessionId='+sessionId);
        		for (String s:CommentDependents.CommentMultipleTriggers(scope, sessionId))
        		{
        			lstFailedTriggers.add(s);
        		} 
        		//lstFailedTriggers.addAll(c.CommentMultipleTriggers(scope, sessionId));
        		failedComponentsToComment.put('ApexTrigger',lstFailedTriggers);
        		System.debug('Failed Triggers='+lstFailedTriggers);
        }
        catch(Exception e){
        	System.debug('Error:'+e);
        }
        	
    }
    global void finish(Database.BatchableContext BC){
    	
	    	System.debug('Inside CommentDependentTriggersBatch finish');
	    	String body;
	    	if(lstFailedTriggers.size()>0){
	    		body='Triggers='+lstFailedTriggers+' are not commented and will give errors while you compile. Please Comment these mannually';
	    	}
	    	else{
	    		body='All Triggers are commented successfully';
	    	}
	    	Id idOfCurrentBetch = BC.getJobId();
	    	List<ApexClass> lstclasses=new List<ApexClass>();
	        List<AsyncApexJob> lstAsyncApexJobNew = new List<AsyncApexJob>();
	        AsyncApexJob lstAsyncApexJob = ConfigurationSelector.asyncApexJobDetails(idOfCurrentBetch);
	        AsyncApexJob a=lstAsyncApexJob;
	    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        String[] toAddresses = new String[] {a.CreatedBy.Email};
	        mail.setToAddresses(toAddresses);
	        mail.setSubject('Details of Triggers Comment');
			mail.setPlainTextBody(body);
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			
			
			
			/*List<String> lstJobNames=new List<String>();
			lstJobNames.add('CommentDependentPagesBatch');
			lstJobNames.add('CommentDependentClassBatch');
			lstJobNames.add('CommentDependentTriggersBatch');
			lstclasses=Configurationcleanupselector.getApexClasses(lstClassesToDelete);
			lstAsyncApexJobNew=Configurationcleanupselector.getAsyncApexJobStatus(lstJobNames);
			if(lstAsyncApexJobNew[0].status=='Completed' && lstAsyncApexJobNew[1].status=='Completed' && lstAsyncApexJobNew[2].status=='Completed')
			{
				Database.executeBatch(new DeleteclassesBatch(lstclasses,sessionId),10);
			}*/
			System.debug('Inside CommentDependentTriggersBatch finish');
    }		    
}