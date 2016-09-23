global with sharing class DeleteclassesBatch implements Database.Batchable<ApexClass>, Database.Stateful, Database.AllowsCallouts{
	public List<ApexClass> lstClassesToDelete;  
	public String sessionId='';// = UserInfo.getSessionId();
	public List<String> lstClassesFailedToDelete=new List<String>();
	global DeleteclassesBatch(List<ApexClass> lstClassesForDelete,string sess)
	{
		sessionId = sess;
		System.debug('In Cons sessionId DeleteCLassBatch='+sessionId);
		lstClassesToDelete=new List<ApexClass>();
		lstClassesToDelete=lstClassesForDelete;
	}
	
	global List<ApexClass> start(Database.BatchableContext BC){
		//sessionId=UserInfo.getSessionId();
		System.debug('In Start method sessionId '+sessionId);
        return lstClassesToDelete;
    }
    global void execute(Database.BatchableContext BC, List<ApexClass> scope){	
        try{
        	ToolingAPIService t = new ToolingAPIService();
        	String deletionStatus;
        	for(ApexClass a:scope)
        	{
        		deletionStatus=t.ClassDelete(a.Id,sessionId);
        		System.debug('deletionStatus='+deletionStatus);
        		if(deletionStatus!='No Content')
        		{
        			lstClassesFailedToDelete.add(a.Name);
        		}
        	}
        	System.debug('lstClassesFailedToDelete='+lstClassesFailedToDelete);
        }
        catch(Exception e){
        	System.debug('Error in Batch'+e.getMessage());
        }
    }
    global void finish(Database.BatchableContext BC){
    	String body;
    	if(lstClassesFailedToDelete.size()>0)
    	{
	    	body='Due to some reason classes='+lstClassesFailedToDelete+'are failed to delete.';
    	}
    	else
    	{
		    body='Classes you were selected to delete are deleted successfully.';
    	}
    	System.debug('Email Body='+body);
    	Id idOfCurrentBetch = BC.getJobId();
	    //List<AsyncApexJob> lstAsyncApexJob = new List<AsyncApexJob>();
	    AsyncApexJob lstAsyncApexJob = ConfigurationSelector.asyncApexJobDetails(idOfCurrentBetch);
	    AsyncApexJob a=lstAsyncApexJob;
	    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	    String[] toAddresses = new String[] {a.CreatedBy.Email};
	    mail.setToAddresses(toAddresses);
	    mail.setSubject('Classes Deletion Result');
		mail.setPlainTextBody(body);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }		
}