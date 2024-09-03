public with sharing class FeedbackController {
    @AuraEnabled
    public static Contact getContact(Id accountId) {
        list<Contact> contacts = [Select Id from Contact where AccountId = :accountId LIMIT 1];
        if (!contacts.isEmpty()) {
            return contacts[0]; 
        }
        return null;
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