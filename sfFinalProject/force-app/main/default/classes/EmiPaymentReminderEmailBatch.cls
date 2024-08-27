public with sharing class EmiPaymentReminderEmailBatch implements Database.Batchable<sObject>, Database.Stateful {
    // Start Method: Query Locator
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Query all contacts with related accounts that have loan EMIs
        return Database.getQueryLocator(
            [SELECT Id, Name, FirstName, Email, AccountId, Account.Remaining_Loan_Amount__c, Account.Total_Loan_Amount__c, Account.Monthly_EMI__c 
            FROM Contact 
            WHERE Account.Remaining_Loan_Amount__c > 0]);
    }

    // Execute Method: Process Batch of Records

    public void execute(Database.BatchableContext bc, List<Contact> scope) {
        // Generate Email template
        EmailTemplate emailTemplate = [SELECT Id FROM EmailTemplate WHERE developerName = 'Monthly_EMI_Reminder'];

        // Create List of Emails to send
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Contact con : scope) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTemplateId(emailTemplate.Id);
            email.setTargetObjectId(con.Id);
            email.setWhatId(con.AccountId);
            emails.add(email);
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }

    }

    // Finish Method
    public void finish(Database.BatchableContext bc) {
        // potential notification
        system.debug('Batch Job Completed');
    }

}