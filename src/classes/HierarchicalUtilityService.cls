//This class is used as Utility class which is used to find all objects related child objects and their dependency
public  with sharing class HierarchicalUtilityService {
   //Get All Objects list
    public static List<String> allObjects()
    {
        List<String> objects = new List<String>();
        Map<String,Schema.SObjectType> lstOfObj = Schema.getGlobalDescribe();
        objects.addAll(lstOfObj.keySet());
        return objects;
    }
    //Get Standard Objects list
    public static List<String> allStandardObj(List<String> objects)
    {
        List<String> objectList = new List<String>();
        for(integer i =0;i< objects.size();i++)
        {
            if(objects[i].endsWith('kav') || objects[i].containsIgnoreCase('CollaborationGroupRecord'))
            {
                objects.remove(i);
            }
        }
        Schema.DescribeSObjectResult[] results = Schema.DescribeSObjects(objects);
        String nameSpace = DataCleanUpSelector.nameSpaceprefixOfOrg();
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
         return objectList;
     }
    //Get a list of All Custom Objects
    public static List<String> allCustomObj(List<String> objects)
    {
        List<String> objectList = new List<String>();
        Schema.DescribeSObjectResult[] results = Schema.DescribeSObjects(objects);
        String nameSpace = DataCleanUpSelector.nameSpaceprefixOfOrg();
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
   //This method is used to implement recurssive function which calls mathod recurssively
    public static Map<string,Set<String>> findChildObjects(list<String> objList)
    {
        Map<string,Set<String>> mapObj_Rel = new Map<String,Set<String>>();
        findChildRelationShip(objList,mapObj_Rel); //calls method to perform recurssive function
        return mapObj_Rel;
    }
     //Find childObjects of a list
    /*Description -This method is used to find all child object's child object and creates a map relation which holds parent as a key and 
    all child related to that object as a values of Map*/
    public static void findChildRelationShip(List<String> objList,Map<String,Set<String>> mapObj_Rel)
    {
        Schema.DescribeSObjectResult[] results = Schema.DescribeSObjects(objList);
        for(Schema.DescribeSObjectResult R : results)
        {
            if(R.isqueryable() && R.isDeletable()) //check the property of the object
            {
                Set<String> putInMap = new Set<String>();
                list<Schema.ChildRelationship> childRel = R.getChildRelationships();
                if(childRel != null)
                {
                    for(Schema.ChildRelationship cr : childRel)
                    {
                        if(R.getName() =='Account') 
                        {
                            list<String> recussionList = new list<String>();
                            recussionList.add('Opportunity');//As we know,Account and Opportunity behaves like Master-detail relationship but it is lookup relationship .
                            findChildRelationShip(recussionList,mapObj_Rel);
                            putInMap.add('Opportunity');
                            recussionList.add('Contact');//Same for contact
                            findChildRelationShip(recussionList,mapObj_Rel);
                            putInMap.add('Contact');
                            
                        }
                        if(cr.isRestrictedDelete() &&  String.valueOf(cr.getChildSObject()) != R.getName() ) // Find lookUp relationShip
                        {	
                            list<String> recussionList = new list<String>();
                            recussionList.add(String.valueOf(cr.getChildSObject()));
                            findChildRelationShip(recussionList,mapObj_Rel);
                            putInMap.add(String.valueOf(cr.getChildSObject()));
                        }
                    }
                }
                mapObj_Rel.put(R.getName(),putInMap) ;
            }
        }
        //Put it in Map;
    }
   
    /* Call Recurssion function to find child's child*/
    public static List<String> findNullValues(Map<string,Set<String>> mapObj_Rel)
    {
       List<String> finalRelationList = new List<String>();
        for(String k : mapObj_Rel.keySet())
        {
            checkForRelationShip(k,mapObj_Rel);
            finalRelationList.add(k);
        }
        return finalRelationList;
    }
    /* This method is used to find child who is not parent of another object*/
    public static void checkForRelationShip(String keys,Map<string,Set<String>> mapObj_Rel)
    {
        Set<String> mapValues = new Set<String>();
        mapValues = mapObj_Rel.get(keys);
        if(mapValues != null)
        {
            for(String values : mapValues)
            {
                checkForRelationShip(values,mapObj_Rel);
            }
        }
    } 
    //Find dependent objects list 
    public static Set<String> dependentObjects(List<String> objList)
    {
        Set<String> dependentObject = new Set<String>();
        if(objList.size() > 0)
        {
            Map<string,Set<String>> mapchildobjects=new Map<string,Set<String>>();
            mapchildobjects= findChildObjects(objList);
            List<String> lstOfDependent = new List<String>();
            lstOfDependent = findNullValues(mapchildobjects);
            dependentObject.addAll(lstOfDependent);
            for(String s : objList)
            {
                if(dependentObject.contains(s))
                {
                    dependentObject.remove(s);
                }
            }
        }
         return dependentObject;
    }
}