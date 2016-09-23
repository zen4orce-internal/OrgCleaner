global with sharing class CommentDependentClassBatch implements Database.Batchable<String>, Database.Stateful, Database.AllowsCallouts{
	
	public String typeName='';
	public List<String> lstPagesToComment;  
	public List<String> lstClassesToDelete=new List<String>();
	public String sessionId='';// = UserInfo.getSessionId();
	//public List<String> lstFailedTriggers=new List<String>();
    //public List<String> lstFailedClasses=new List<String>();
    //public List<String> lstFailedPages=new List<String>();
    public List<String> lstFailedClasses=new List<String>();
    public map<String,List<String>> failedComponentsToComment=new map<String,List<String>>();

	global CommentDependentClassBatch(List<String> lstClassesForDelete,List<String> typeWiseMap,string sess)
	{
		sessionId = sess;
		System.debug('In Cons sessionId CommentDependentClassBatch'+sessionId);
		lstPagesToComment=new List<String>();
		lstClassesToDelete=lstClassesForDelete;
		lstPagesToComment=typeWiseMap;
	}
	
	global List<String> start(Database.BatchableContext BC){
		//sessionId=UserInfo.getSessionId();
		System.debug('In Start method sessionId CommentDependentClassBatch'+sessionId);
        return lstPagesToComment;	
    }
    global void execute(Database.BatchableContext BC, List<String> scope){	
        try{
        	System.debug('one ');
        	//CommentDependentClasses c=new CommentDependentClasses();
        		System.debug('sessionId CommentDependentClassBatch execute method='+sessionId);
        		for(String s:CommentDependents.CommentMultipleClasses(scope, sessionId))
        		{
        			lstFailedClasses.add(s);	
        		}
        		//lstFailedClasses.addAll(c.CommentMultipleClasses(scope, sessionId));
        		failedComponentsToComment.put('ApexClass',lstFailedClasses);
        		System.debug('lstFailedClasses='+lstFailedClasses);
        	System.debug('one end');
        }
        catch(Exception e){
        	System.debug('Error in Batch'+e.getMessage());
        }
    }
    global void finish(Database.BatchableContext BC){
    	
    	System.debug('Inside CommentDependentClassBatch finish');
    	String body;
	    	if(lstFailedClasses.size()>0){
	    		body='Class='+lstFailedClasses+' are not commented and will give errors while you compile. Please Comment these mannually';
	    	}
	    	else{
	    		body='All Classes are commented Successfully';
	    	}
	    	Id idOfCurrentBetch = BC.getJobId();
	        //List<AsyncApexJob> lstAsyncApexJob = new List<AsyncApexJob>();
	        List<ApexClass> lstclasses=new List<ApexClass>();
	        AsyncApexJob lstAsyncApexJob = ConfigurationSelector.asyncApexJobDetails(idOfCurrentBetch);
	        AsyncApexJob a=lstAsyncApexJob;
	    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        String[] toAddresses = new String[] {a.CreatedBy.Email};
	        mail.setToAddresses(toAddresses);
	        mail.setSubject('Details of Classes Comment');
			mail.setPlainTextBody(body);
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			/*List<AsyncApexJob> lstAsyncApexJobNew=new List<AsyncApexJob>();
			List<String> lstJobNames=new List<String>();
			lstJobNames.add('CommentDependentPagesBatch');
			lstJobNames.add('CommentDependentClassBatch');
			lstJobNames.add('CommentDependentTriggersBatch');
			lstclasses=Configurationcleanupselector.getApexClasses(lstClassesToDelete);
			lstAsyncApexJobNew=Configurationcleanupselector.getAsyncApexJobStatus(lstJobNames);
			System.debug('lstAsyncApexJobNew size='+lstAsyncApexJobNew);
			if(lstAsyncApexJobNew[0].status=='Completed' && lstAsyncApexJobNew[1].status=='Completed' && lstAsyncApexJobNew[2].status=='Completed')
			{
				Database.executeBatch(new DeleteclassesBatch(lstclasses,sessionId),10);
				
			}*/
			System.debug('Inside CommentDependentClassBatch finish');
    }		
}