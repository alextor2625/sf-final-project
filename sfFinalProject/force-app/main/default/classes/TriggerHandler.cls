public with sharing class TriggerHandler{
    public static void handle(Schema.SObjectType sObjectType, System.TriggerOperation operation, List<SObject> sObjectList, Map<Id, SObject> sObjectMap){
        if (sObjectType == Account.SObjectType){

            AccountTriggerHandler.handle(operation, (List<Account>) sObjectList, (Map<Id, Account>) sObjectMap);

        }
    }

}