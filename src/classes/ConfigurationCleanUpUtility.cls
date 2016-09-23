public  with sharing class ConfigurationCleanUpUtility {
  
    public static List<String> allObjects()
    {
        List<String> objects = new List<String>();
        Map<String,Schema.SObjectType> lstOfObj = Schema.getGlobalDescribe();
        objects.addAll(lstOfObj.keySet());
        return objects;
    }
    public static List<String> allStandardObj(List<String> objects)
    {
        List<String> objectList = new List<String>();
        System.debug('objects'+objects.size());
        for(integer i =0;i< objects.size();i++)
        {
            if(objects[i].endsWith('kav') || objects[i].containsIgnoreCase('CollaborationGroupRecord'))
            {
                objects.remove(i);
            }
        }
          System.debug('objects out size - '+objects.size());
        Schema.DescribeSObjectResult[] results = Schema.DescribeSObjects(objects);
        System.debug('objects out size YZZZZZ - '+objects.size());
        String nameSpace = ConfigurationSelector.nameSpaceprefixOfOrg();
        System.debug('objects out - ' + results.size());
        for(Schema.DescribeSObjectResult res : results)
        {
            String resString = String.valueOf((res.getName()));
            if(!res.isCustomSetting() &&!res.isCustom() && res.getRecordTypeInfos().size() > 0 && res.isqueryable()  && res.isDeletable() && res.isCreateable())//get the list of objetcs which are queryable,deletable and creatable
            {
                if(nameSpace != null && resString.startsWith(nameSpace + '__'))
                {
                    objectList.add(res.getname());
                }
                else if(namespace == null && resString.countMatches('__') < 2)
                {
                    objectList.add(res.getname());
                } 
            }
        }
        System.debug('objects outer');
         return objectList;
     }
    //Get a list of All Custom Objects
    public static List<String> allCustomObj(List<String> objects)
    {
        List<String> objectList = new List<String>();
        Schema.DescribeSObjectResult[] results = Schema.DescribeSObjects(objects);
        String nameSpace = ConfigurationSelector.nameSpaceprefixOfOrg();
        for(Schema.DescribeSObjectResult res : results)
        {
            String resString = String.valueOf(res.getName());
            if(!res.isCustomSetting()  && res.iscustom() && res.getRecordTypeInfos().size() > 0 && res.isqueryable()  && res.isDeletable() && res.isCreateable())//get the list of objetcs which are queryable,deletable and creatable
            {
                if(nameSpace != null && resString.startsWith(nameSpace + '__'))
                {
                    objectList.add(res.getname());
                }
                else if(namespace == null && resString.countMatches('__') < 2)
                {
                    objectList.add(res.getname());
                } 
            }
        }
        return objectList; 
    }
}