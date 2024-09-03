@isTest
public class AccountTriggerHandlerTest{
    @isTest
    static void beforeInsertTest(){
        Test.startTest();
        Account testAccount = new Account(
            RecordTypeId = '012bm0000029FzlAAE', 
            Name = 'Test Account', 
            Email__c = 'alextor2625@gmail.com', 
            Account_Balance__c = 10000, 
            Installments__c = null
        );

        insert testAccount;
        Test.stopTest();

        Account insertedAccount = [SELECT Interest_Rate__c, Calculated_Interest__c
                                   FROM Account
                                   WHERE Id = :testAccount.Id];
        System.Assert.areNotEqual(null, insertedAccount.Interest_Rate__c, 'Interest rate should not be null');
        System.Assert.areEqual(380, insertedAccount.Calculated_Interest__c);
    }
/*
    @isTest
    static void beforeUpdateCarLoanTest(){
        Test.startTest();
        Account testCurrentAccountBelow100000 = new Account(
            RecordTypeId = '012bm0000029FzlAAE', 
            Name = 'Test Current Account Below 100000', 
            Email__c = 'alextor2625@gmail.com', 
            Account_Balance__c = 10000, 
            Installments__c = null
        );
        Account testCurrentAccountBelow500000 = new Account(
            RecordTypeId = '012bm0000029FzlAAE', 
            Name = 'Test Current Account', 
            Email__c = 'alextor2625@gmail.com', 
            Account_Balance__c = 10000, 
            Installments__c = null
        );
        Account testCurrentAccount = new Account(
            RecordTypeId = '012bm0000029FzlAAE', 
            Name = 'Test Current Account', 
            Email__c = 'alextor2625@gmail.com', 
            Account_Balance__c = 10000, 
            Installments__c = null
        );

        Account testSalaryAccount = new Account(
            RecordTypeId = '012bm0000029Hi6AAE', 
            Name = 'Test Salary Account', 
            Email__c = 'alextor2625@gmail.com', 
            Account_Balance__c = 10000, 
            Installments__c = null
        );
        Account testTransactionalAccount = new Account(
            RecordTypeId = '012bm0000029HDPAA2', 
            Name = 'Test Transactional Account', 
            Email__c = 'alextor2625@gmail.com', 
            Account_Balance__c = 10000, 
            Installments__c = null
        );

        List<Account> insertAccounts = new List<Account>{testCurrentAccount, testSalaryAccount, testTransactionalAccount};
        insert insertAccounts;
        testCurrentAccount.Loan_Type__c = 'Car Loan';
        testSalaryAccount.Loan_Type__c = 'Car Loan';
        testTransactionalAccount.Loan_Type__c = 'Car Loan';

        testCurrentAccount.Total_Loan_Amount__c = 40000;
        testSalaryAccount.Total_Loan_Amount__c = 40000;
        testTransactionalAccount.Total_Loan_Amount__c = 40000;

        testCurrentAccount.Installments__c = 60;
        testSalaryAccount.Installments__c = 60;
        testTransactionalAccount.Installments__c = 60;
        List<Account> updateAccounts = new List<Account>{testCurrentAccount, testSalaryAccount, testTransactionalAccount};
        update updateAccounts;
        Test.stopTest();

        // System.Assert.areEqual(, );
    }

    @IsTest
    static void beforeUpdateHomeLoanTest(){
        Test.startTest();
        Account testCurrentAccount = new Account(
            RecordTypeId = '012bm0000029FzlAAE', 
            Name = 'Test Current Account', 
            Email__c = 'alextor2625@gmail.com', 
            Account_Balance__c = 10000, 
            Installments__c = null
        );

        Account testSalaryAccount = new Account(
            RecordTypeId = '012bm0000029Hi6AAE', 
            Name = 'Test Salary Account', 
            Email__c = 'alextor2625@gmail.com', 
            Account_Balance__c = 10000, 
            Installments__c = null
        );
        Account testTransactionalAccount = new Account(
            RecordTypeId = '012bm0000029HDPAA2', 
            Name = 'Test Transactional Account', 
            Email__c = 'alextor2625@gmail.com', 
            Account_Balance__c = 10000, 
            Installments__c = null
        );

        List<Account> insertAccounts = new List<Account>{testCurrentAccount, testSalaryAccount, testTransactionalAccount};
        insert insertAccounts;
        testCurrentAccount.Loan_Type__c = 'Home Loan';
        testSalaryAccount.Loan_Type__c = 'Home Loan';
        testTransactionalAccount.Loan_Type__c = 'Home Loan';

        testCurrentAccount.Total_Loan_Amount__c = 40000;
        testSalaryAccount.Total_Loan_Amount__c = 40000;
        testTransactionalAccount.Total_Loan_Amount__c = 40000;

        testCurrentAccount.Installments__c = 60;
        testSalaryAccount.Installments__c = 60;
        testTransactionalAccount.Installments__c = 60;
        List<Account> updateAccounts = new List<Account>{testCurrentAccount, testSalaryAccount, testTransactionalAccount};
        update updateAccounts;
        Test.stopTest();

        // System.Assert.areEqual(, );
    }
*/
}