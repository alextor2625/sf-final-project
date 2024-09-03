/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class FeedbackEmailBatchTEST {

    @testSetup
    static void setupTestData() {
        // Create an Account with loan details
        Account acc = new Account(
            Name = 'Test Account',
            Email__c = 'testacc1@gmail.com',
            Loan_Type__c = 'Home Loan',
            Account_Balance__c = 5000,
            Remaining_Loan_Amount__c = 5000,
            Total_Loan_Amount__c = 10000,
            Monthly_EMI__c = 500,
            Installments__c = '240'
        );
        insert acc;
        
        // Create Contacts with different email scenarios
        Contact contactWithEmail = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'giocortes19@gmail.com',
            AccountId = acc.Id
        );
        insert contactWithEmail;

        // Account without contact
        Account accountWithoutContact = new Account(
            Name = 'Test Account 2',
            Email__c = 'gionocontact@gmail.com',
            Remaining_Loan_Amount__c = 10000,
            Account_Balance__c = 5000,
            Total_Loan_Amount__c = 10000,
            Monthly_EMI__c = 500,
            Loan_Type__c = 'Home Loan',
            Installments__c = '360'
        );
        insert accountWithoutContact;

    }
    
    @isTest
    static void testBatchJob() {

        // Set up a test batch job
        Test.startTest();
        
        // Execute the batch job
        FeedbackEmailBatch batch = new FeedbackEmailBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Use Test.getSentEmails to verify emails were sent correctly
        List<EmailMessage> sentEmails = [SELECT Id, ToAddress, Subject FROM EmailMessage];
        
        // Assertions to ensure the emails were sent
        System.assertEquals(2, sentEmails.size(), 'Expected 2 emails to be sent.');
        System.assertEquals('giocortes19@gmail.com', sentEmails[0].ToAddress, 'Expected email to be sent to Contact email.');
        System.assertEquals('gionocontact@gmail.com', sentEmails[1].ToAddress, 'Expected email to be sent to Account email.');

        // Test that the email contains "quarterly feedback session"
        System.assertEquals('Feedback Request for: Doe', sentEmails[0].Subject, 'Expected email to have subject "Quarterly Feedback Request"');   
    }
}