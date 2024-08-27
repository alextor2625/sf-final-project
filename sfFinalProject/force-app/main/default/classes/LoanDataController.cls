public with sharing class LoanDataController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getLoanData(String accountId) {
        // Query to get loan-related data from the specified Account object
        return [
            SELECT Id, Name, Loan_Type__c, Total_Loan_Amount__c, Loan_Interest_Rate__c, Monthly_EMI__c, Remaining_Loan_Amount__c
            FROM Account
            WHERE Id = :accountId
            AND Loan_Type__c != NULL
        ];
    }
    
    @AuraEnabled
    public static void saveLoanData(Account acc) {
        try {
            upsert acc; // Upsert will insert or update the account record
        } catch (Exception e) {
            System.debug('Error in saveLoanData: ' + e.getMessage());
            throw new AuraHandledException('Unable to save loan data: ' + e.getMessage());
        }
    }
}