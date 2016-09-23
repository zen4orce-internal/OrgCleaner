public class DataCleanUpServiceHandler {
    //This method is used to call Custom ObjectList
    public static List<String> getCustomObjList()
    {
        List<String> customObjList = new List<String>();
        try
        {
            List<String> allObjList = HierarchicalUtilityService.allObjects();
            customObjList = HierarchicalUtilityService.allCustomObj(allObjList);
        }
        catch(Exception e)
        {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+e.getMessage()));
        }
         return customObjList;
    }
    //This method is used to call Standard ObjectList
    public static List<String> getStandardObjList()
    {
        List<String> stdObjList = new List<String>();
        try
        {
             List<String> allObjList = HierarchicalUtilityService.allObjects();
             stdObjList = HierarchicalUtilityService.allStandardObj(allObjList);
        }
        catch(Exception e)
        {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+e.getMessage()));
        }
        return stdObjList;
    } 
    //This method is used to delete all records related to selected object list
    public static void deleteAllRecords(List<String>selectedObjects)
    {
        try
        {
            if(selectedObjects.size() > 0 && selectedObjects != null)
            {
                Map<string,Set<String>> chidlValues = new Map<string,Set<String>>();
                chidlValues = HierarchicalUtilityService.findChildObjects(selectedObjects);
                list<String> strList = new list<String>();
                strList =  HierarchicalUtilityService.findNullValues(chidlValues);
                if(strList.size() > 0)
                {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'We will send you an email after completion of precoss'));
                    BatchApexDeleteRecordsService d = new BatchApexDeleteRecordsService(strList.get(0),strList);//Created an instance to call Batch Apex class 
                    database.executeBatch(d,2000);
                }
            }
            else
            {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'Please select any object to delete'));
            }
        } 
        catch(Exception ex)
        {
             Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,''+ex.getMessage()));
        }
    } 
    
}