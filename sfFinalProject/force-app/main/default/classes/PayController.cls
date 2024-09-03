public with sharing class PayController {
    @AuraEnabled
    public static void updateLoanClosure(Id accountId) {
        try {
            // Query the account with the specified Id
            Account acc = [SELECT Id, Loan_Closure__c FROM Account WHERE Id = :accountId LIMIT 1];

            // Set the Loan_Closure__c field to true
            acc.Loan_Closure__c = true;

            // Update the account
            update acc;
        } catch (Exception e) {
            // Log the exception for debugging
            System.debug('Error in updateLoanClosure method: ' + e.getMessage());

            // Throw a custom exception to inform the user or calling method
            // Replace with AuraHandledException for Lightning context
            throw new AuraHandledException('An error occurred while updating the Loan Closure status. Please try again or contact your administrator.');
        }
    }
}