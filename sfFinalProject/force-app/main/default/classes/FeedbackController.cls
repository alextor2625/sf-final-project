public with sharing class FeedbackController {
    @AuraEnabled
    public static String getAccountName(Id accountId) {
        Account account = [SELECT Name FROM Account WHERE Id = :accountId LIMIT 1];
        return account != null ? account.Name : null;
    }

    @AuraEnabled
    public static void saveFeedback(Feedback__c feedback) {
        try {
            insert feedback;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}