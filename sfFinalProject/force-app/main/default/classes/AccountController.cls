public with sharing class AccountController{
    public Map<String, String> acc{ get; set; }

    public AccountController(ApexPages.StandardController controller){
        acc = new Map<String, String>();
        // public AccountController(){

        Id accountId = ApexPages.currentPage().getParameters().get('accountId');
        // Id accountId = '001bm00000MNtARAA1';
        if (accountId != null){
            List<AccountHistory> historyRecords = [SELECT Field, OldValue, NewValue, CreatedDate, CreatedBy.Name
                                                   FROM AccountHistory
                                                   WHERE AccountId = :accountId AND Field IN ('Remaining_Loan_Amount__c', 'Installments__c', 'Total_Loan_Amount__c', 'Monthly_EMI__c', 'Loan_Type__c')
                                                   ORDER BY CreatedDate DESC
                                                   limit 10];

            Account currAccount = [SELECT Id, Name, Total_Loan_Amount__c, Monthly_EMI__c, Remaining_Loan_Amount__c, Loan_Type__c, Email__c
                                   FROM Account
                                   WHERE Id = :accountId
                                   LIMIT 1];

            List<AccountHistory> beforeLastChanges = new List<AccountHistory>();

            system.debug('historyRecords '+historyRecords);
            system.debug('currAccount '+currAccount);
            for (Integer i = 0; i < historyRecords.size()-5; i++){
                beforeLastChanges.add(historyRecords[i]);
            }
            system.debug('beforeLastChanges '+beforeLastChanges);
            acc.put('Id', currAccount.Id);
            acc.put('Name', currAccount.Name);
            acc.put('Email__c', currAccount.Email__c);

            for (AccountHistory history : beforeLastChanges){
                if (!acc.containsKey(history.Field)){
                    if (history.oldValue == null){
                        acc.put(history.Field, 'No Data');
                    } else{
                        acc.put(history.Field, String.valueOf(history.oldValue));
                    }
                }
            }
            system.debug('acc '+acc);

        }
    }
    @AuraEnabled
    public static void FormVisibility(Boolean State, Id AccountId){
        System.debug('Arguments received in FormVisibility apex method: State:' + State + ' AccountId: ' + AccountId);

        try { Account Acc = [select Hide_Feedback__c from Account where id = :AccountId limit 1];
             Acc.Hide_Feedback__c = State;
             System.debug('Account Inside FormVisibility apex method: ' + Acc);
             update Acc;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Account getAccount(Id AccountId){
        try { Account Acc = [select Hide_Feedback__c from Account where id = :AccountId limit 1];
             return Acc;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}