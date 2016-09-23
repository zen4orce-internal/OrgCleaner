global class BatchScheduler implements Schedulable {
  global Database.Batchable<ApexClass> batchClass{get;set;}
  global Integer batchSize{get;set;} {batchSize = 10;}
  global static Integer callstatus=0;
  global static boolean schedulestatus{get;set;}

  global void execute(SchedulableContext sc) {
  	
		List<AsyncApexJob> lstAsyncApexJobNew=new List<AsyncApexJob>();
		List<String> lstJobNames=new List<String>();
		lstJobNames.add('CommentDependentPagesBatch');
		lstJobNames.add('CommentDependentClassBatch');
		lstJobNames.add('CommentDependentTriggersBatch');
		lstAsyncApexJobNew=ConfigurationSelector.getAsyncApexJobStatus(lstJobNames);
		if(lstAsyncApexJobNew[0].status=='Completed' && lstAsyncApexJobNew[1].status=='Completed' && lstAsyncApexJobNew[2].status=='Completed')
		{
			database.executebatch(batchClass, batchSize);
			schedulestatus=true;
		}
		else{
			ConfigurationCleanUpServiceHandler.ScheduleDeletionBatch();
			schedulestatus=false;
		}
  }
}