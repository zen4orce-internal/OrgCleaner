public with sharing class ApexPageService {
	public static List<ApexPage> getApexPages()
    {
    	return ConfigurationSelector.getVisualforcePages();
    } 
    public static void deleteApexPages(List<String> selectedApexPages)
    {
        Map<string, List<String>> apexPageMap = new Map<string, List<String>>();
        apexPageMap.put('ApexPage', selectedApexPages);
        Id batchJobId = database.executeBatch(new ConfigurationCleanUpBatchService(apexPageMap),100);
        System.debug('batchJobId Apex Page- ' + batchJobId);
    }
}