public with sharing class TriggerService {
	public static Map<string, List<List<String>>> getTriggers()
    {
        List<ApexTrigger> triggerList = ConfigurationSelector.getTriggers();
     	Map<string, List<List<String>>> triggerMap = new Map<string, List<List<String>>>();
        List<string> triggerTempList;
        List<List<String>> triggerTempList2;
        for(ApexTrigger apexTriggerObj : triggerList)
        {
            triggerTempList = new List<String>();
            triggerTempList2 = new List<List<STring>>();
            if(triggerMap.containsKey(apexTriggerObj.TableEnumOrId)){
                triggerTempList2.addAll(triggerMap.get(apexTriggerObj.TableEnumOrId));
                triggerTempList.add(apexTriggerObj.Name);
                triggerTempList.add(apexTriggerObj.ID);  
                triggerTempList2.add(triggerTempList);
            }
            else{
            	triggerTempList.add(apexTriggerObj.Name);
            	triggerTempList.add(apexTriggerObj.ID);  
                triggerTempList2.add(triggerTempList);
            }
            triggerMap.put(apexTriggerObj.TableEnumOrId, triggerTempList2);                     
        }
        return triggerMap;
    } 
    public static void deleteTrigger(List<String> selectedTriggers)
    {
        Map<string, List<String>> triggerMap = new Map<string, List<String>>();
        triggerMap.put('ApexTrigger', selectedTriggers);
        Id batchJobId = database.executeBatch(new ConfigurationCleanUpBatchService(triggerMap),100);
        System.debug('batchJobId - ' + batchJobId);
    }
    public static Map<string, List<String>> getTriggersTemp()
    {
        List<ApexTrigger> triggerList = ConfigurationSelector.getTriggers();
     	Map<string, List<String>> triggerMap = new Map<string, List<String>>();
        List<string> triggerTempList;
        for(ApexTrigger apexTriggerObj : triggerList)
        {
            triggerTempList = new List<String>();
            if(triggerMap.containsKey(apexTriggerObj.TableEnumOrId)){
                triggerTempList.addAll(triggerMap.get(apexTriggerObj.TableEnumOrId));
                triggerTempList.add(apexTriggerObj.Name);
            }
            else{
            	triggerTempList.add(apexTriggerObj.Name);
            }
            triggerMap.put(apexTriggerObj.TableEnumOrId, triggerTempList);                     
        }
        return triggerMap;
    }
}