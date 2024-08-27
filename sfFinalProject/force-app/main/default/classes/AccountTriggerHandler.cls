public with sharing class AccountTriggerHandler {
//     public static void handle(System.TriggerOperation operation){
//         switch on operation {
//             // when BEFORE_INSERT {
//             //     AccountTriggerHandler.beforeInsert(Trigger.new);
//             // }
//             // when AFTER_INSERT {
//             //     AccountTriggerHandler.afterInsert(Trigger.new);
//             // }
//             when BEFORE_UPDATE {
//                 AccountTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
//             }
//             // when AFTER_UPDATE {
//             //     AccountTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
//             // }
//             // when BEFORE_DELETE {
//             //     AccountTriggerHandler.beforeDelete(Trigger.old);
//             // }
//             // when AFTER_DELETE {
//             //     AccountTriggerHandler.afterDelete(Trigger.old);
//             // }
//         }
//     }
//     private static void beforeUpdate(List<Account> newAccList, Map<Id,Account> oldAccMap){
//         for(Account acc : newAccList){
//             acc.Calculated_Interest__c = (acc.Interest_Rate__c/100) * acc.Loan_Amount__c;
//             if(acc.RecordType == 'Salary Account' && acc.Loan_Type__c)
//         }

//         update newAccList;
//     }
}