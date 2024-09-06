@isTest
private class LoanDataControllerTEST {

    @testSetup
    static void setupTestData() {
        // Create test Account with loan-related fields populated
        Account testAccount = new Account(
            Name = 'Test Account',
            Email__c = 'testaccount@example.com',
            Loan_Type__c = 'Home Loan',
            Total_Loan_Amount__c = 250000,
            Loan_Interest_Rate__c = 5.5,
            Monthly_EMI__c = 1500,
            Remaining_Loan_Amount__c = 200000,
            Installments__c = '240'
        );
        insert testAccount;
    }

    @isTest
    static void testGetLoanData() {
        // Retrieve the test Account created in test setup
        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        // Execute the method under test
        Test.startTest();
        List<Account> loanData = LoanDataController.getLoanData(testAccount.Id);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(0, loanData.size(), 'Expected at least one account to be returned.');
        Account retrievedAccount = loanData[0];
        System.assertEquals(testAccount.Id, retrievedAccount.Id, 'The returned account should match the test account.');
        System.assertEquals('Home Loan', retrievedAccount.Loan_Type__c, 'Expected Loan_Type__c to be "Home Loan".');
        System.assertEquals(250000, retrievedAccount.Total_Loan_Amount__c, 'Expected Total_Loan_Amount__c to be 250000.');
    }

    @isTest
    static void testGetLoanDataNoLoanType() {
        // Create an Account with no Loan_Type__c
        Account accountNoLoan = new Account(
            Name = 'Account Without Loan',
            Total_Loan_Amount__c = 100000,
            Email__c = 'accountnoloan@example.com'
        );
        insert accountNoLoan;

        // Execute the method under test
        Test.startTest();
        List<Account> loanData = LoanDataController.getLoanData(accountNoLoan.Id);
        Test.stopTest();

        // Assertions
        System.assertEquals(0, loanData.size(), 'Expected no accounts to be returned, as Loan_Type__c is null.');
    }

    @isTest
    static void testSaveLoanData() {
        // Retrieve the test Account created in test setup
        Account testAccount = [SELECT Id, Remaining_Loan_Amount__c FROM Account LIMIT 1];
        
        // Modify the account data
        testAccount.Remaining_Loan_Amount__c = 180000;

        // Execute the method under test
        Test.startTest();
        LoanDataController.saveLoanData(testAccount);
        Test.stopTest();

        // Retrieve the updated account
        Account updatedAccount = [SELECT Remaining_Loan_Amount__c FROM Account WHERE Id = :testAccount.Id];
        
        // Assertions
        System.assertEquals(180000, updatedAccount.Remaining_Loan_Amount__c, 'The Remaining_Loan_Amount__c should have been updated.');
    }

    @isTest
    static void testSaveLoanDataWithException() {
        // Create an invalid account (missing required fields)
        Account invalidAccount = new Account();

        // Execute the method under test and expect an exception
        Test.startTest();
        try {
            LoanDataController.saveLoanData(invalidAccount);
            System.assert(false, 'An exception should have been thrown.');
        } catch (Exception e) {
            System.assertEquals(true, e.getMessage().contains('Script-thrown exception'), 'The exception message should indicate that loan data could not be saved.');
        }
        Test.stopTest();
    }
}