public with sharing class CustomFieldService {

    Map <String, Schema.SObjectField> fieldMap{get;set;}
    private Static Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    
  
    public static List<String> listOfAllObj()
   	{
       List<String> allStdCusList = new List<String>();
       try
       {
           System.debug('all obj call');
           List<String> lstOfallObj = ConfigurationCleanUpUtility.allObjects();
           System.debug('all std call');
           List<String> lstOfStdObj = ConfigurationCleanUpUtility.allStandardObj(lstOfallObj);
           System.debug('all cst call');
           List<String> lstOfCusObj = ConfigurationCleanUpUtility.allCustomObj(lstOfallObj);
           allStdCusList.addAll(lstOfStdObj);
           allStdCusList.addAll(lstOfCusObj);
       }
       catch(Exception e )
        {
            System.debug('Error:'+e.getMessage());
        }
      return allStdCusList;
   }
    
   public static Map<String,List<String>> listOfAllFields()
   {
       Map<String,List<String>> customFieldsMap = new Map<String,List<String>>();
       List<String> lstOfObj = new List<String>();
       System.debug('before all obj');
       lstOfObj = listOfAllObj();
       System.debug('after all obj');
       if(lstOfObj != null)
       for(String obj : lstOfObj)
       { 
           List<String> lstOfFields = new List<String>();
           System.debug('before');
           lstOfFields   = allFieldsOfObject(obj);
           System.debug('after');
           if(lstOfFields.size() > 0)
           {
           	customFieldsMap.put(obj,lstOfFields);
           }
       }
       System.debug('customFieldsMap'+customFieldsMap);
       return customFieldsMap;
   }
 
   public static list<String> allFieldsOfObject(String ObjName)
   {
       System.debug('IN allFieldsOfObject method');
       List<String> fieldList = new List<String>(); 
       try
        {
            Map <String,Schema.SObjectField> fieldMap = schemaMap.get(ObjName).getDescribe().fields.getMap();
           
            for(Schema.SObjectField sfield : fieldMap.Values())
            {
                schema.describefieldresult dfield = sfield.getDescribe();
                if(dfield.isCustom())
                {
                    fieldList.add(dfield.getName());
                }
            }
        }
        catch(Exception e )
        {
            System.debug('Error:'+e.getMessage());
        }
       System.debug('fieldList -' + fieldList);
       return fieldList;    
	}
   
    
  
  
    //Call the batch class
   public static void DeleteFields(List<String> lstOfFields)
   {
       CustomFieldBatchService d = new CustomFieldBatchService(lstOfFields) ; //Created an instance to call Batch Apex class 
       database.executeBatch(d,10);
   }
}