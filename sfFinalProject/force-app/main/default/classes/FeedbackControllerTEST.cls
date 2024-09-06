@isTest
private class FeedbackControllerTEST {

    @testSetup
    static void setupTestData() {
        // Create an Account
        Account testAccount = new Account(
            Name = 'Test Account',
            Email__c = 'testaccount@example.com'
        );
        insert testAccount;

        // Create a Contact related to the Account
        Contact testContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'testcontact@example.com',
            AccountId = testAccount.Id
        );
        insert testContact;

        // Create a Feedback record
        Feedback__c testFeedback = new Feedback__c(
            Comments__c = 'Great service!',
            Rating__c = 'Good',
            Account__c = testAccount.Id
        );
        insert testFeedback;
    }

    @isTest
    static void testGetContact() {
        // Retrieve the Account created during the test setup
        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        // Execute the method under test
        Test.startTest();
        Contact resultContact = FeedbackController.getContact(testAccount.Id);
        Test.stopTest();

        // Assert that a contact is returned
        System.assertNotEquals(null, resultContact, 'The returned contact should not be null');
        System.assertEquals(testAccount.Id, resultContact.AccountId, 'The contact should be related to the correct account');
    }

    @isTest
    static void testGetContactNoContact() {
        // Create an Account with no Contact
        Account testAccountNoContact = new Account(
            Name = 'Test Account No Contact',
            Email__c = 'nocontact@example.com'
        );
        insert testAccountNoContact;

        // Execute the method under test
        Test.startTest();
        Contact resultContact = FeedbackController.getContact(testAccountNoContact.Id);
        Test.stopTest();

        // Assert that no contact is returned
        System.assertEquals(null, resultContact, 'The result should be null as no contact is related to this account');
    }

    @isTest
    static void testSaveFeedback() {
        // Retrieve the Account created during the test setup
        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        // Create a new feedback record
        Feedback__c newFeedback = new Feedback__c(
            Comments__c = 'Excellent service!',
            Rating__c = 'Excellent',
            Account__c = testAccount.Id
        );

        // Execute the method under test
        Test.startTest();
        FeedbackController.saveFeedback(newFeedback);
        Test.stopTest();

        // Assert that the feedback was saved
        Feedback__c insertedFeedback = [SELECT Id, Comments__c FROM Feedback__c WHERE Id = :newFeedback.Id LIMIT 1];
        System.assertNotEquals(null, insertedFeedback, 'The feedback should be successfully inserted');
        System.assertEquals('Excellent service!', insertedFeedback.Comments__c, 'The feedback comments should match the input');
    }

    @isTest
    static void testSaveFeedbackWithException() {
        // Create a feedback record without mandatory fields to trigger an exception
        Feedback__c invalidFeedback = new Feedback__c(
            Comments__c = 'This will fail'
            // Missing required fields like Account__c or other required fields
        );

        // Execute the method under test
        Test.startTest();
        try {
            FeedbackController.saveFeedback(invalidFeedback);
        } catch (AuraHandledException e) {
            System.assertEquals(true, e.getMessage().contains('Required fields are missing'), 'The exception message should indicate missing fields');
        }
        Test.stopTest();
    }
}