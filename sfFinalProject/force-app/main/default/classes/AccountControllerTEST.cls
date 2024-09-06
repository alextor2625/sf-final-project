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
private class AccountControllerTEST {

    @testSetup
    static void setupTestData() {
        // Create a test account
        Account testAccount = new Account(
            Name = 'Test Account',
            Email__c = 'test@example.com',
            Total_Loan_Amount__c = 10000,
            Monthly_EMI__c = 500,
            Remaining_Loan_Amount__c = 5000,
            Loan_Type__c = 'Home Loan'
        );
        insert testAccount;
        
    }

    @isTest
    static void testAccountControllerConstructor() {
        // Simulate setting the 'accountId' parameter
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Test.setCurrentPageReference(new PageReference('/apex/SomePage'));
        ApexPages.currentPage().getParameters().put('accountId', testAccount.Id);

        // Mock the AccountHistory query result by directly querying the database (if applicable)

        Test.startTest();
        // Simulate instantiating a standard controller and AccountController
        ApexPages.StandardController sc = new ApexPages.StandardController(testAccount);
        AccountController controller = new AccountController(sc);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, controller.acc, 'The account map should not be null');
        System.assert(controller.acc.containsKey('Id'), 'The account map should contain the account Id');
        System.assert(controller.acc.containsKey('Email__c'), 'The account map should contain the email field');
    }

    @isTest
    static void testFormVisibility() {
        // Create a test account
        Account testAccount = [SELECT Id, Hide_Feedback__c FROM Account LIMIT 1];
        
        // Execute the method
        Test.startTest();
        AccountController.FormVisibility(true, testAccount.Id);
        Test.stopTest();

        // Assert that the Hide_Feedback__c field was updated
        Account updatedAccount = [SELECT Hide_Feedback__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(true, updatedAccount.Hide_Feedback__c, 'Hide_Feedback__c should be true after FormVisibility call.');
    }

    @isTest
    static void testGetAccount() {
        // Create a test account
        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        // Execute the method
        Test.startTest();
        Account resultAccount = AccountController.getAccount(testAccount.Id);
        Test.stopTest();

        // Assert that the account was returned
        System.assertNotEquals(null, resultAccount, 'The returned account should not be null');
        System.assertEquals(testAccount.Id, resultAccount.Id, 'The returned account ID should match the test account ID');
    }

}