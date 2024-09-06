@isTest
public class AccountTriggerHandlerTest{
    @TestSetup
    static void setupTestData(){
        Account testSalaryAccount = new Account(
            RecordTypeId = '012bm0000029Hi6AAE', 
            Name = 'Salary Account For Testing', 
            Email__c = 'alextor2625@gmail.com', 
            Account_Balance__c = 10000, 
            Installments__c = null
        );
        Account testCurrentAccount = new Account(
            RecordTypeId = '012bm0000029FzlAAE', 
            Name = 'Current Account For Testing', 
            Email__c = 'alextor2625@gmail.com', 
            Account_Balance__c = 10000, 
            Installments__c = null
        );
        Account testTransactionalAccount = new Account(
            RecordTypeId = '012bm0000029HDPAA2', 
            Name = 'Transactional Account For Testing', 
            Email__c = 'alextor2625@gmail.com', 
            Account_Balance__c = 10000, 
            Installments__c = null
        );
        insert new List<Account>{ testSalaryAccount, testCurrentAccount, testTransactionalAccount };
    }

    @isTest
    static void beforeInsertTest(){

        Account[] insertedAccounts = [SELECT Interest_Rate__c, Calculated_Interest__c, RecordTypeId, Account_Balance__c
                                      FROM Account
                                      WHERE Name IN ('Salary Account For Testing', 'Current Account For Testing', 'Transactional Account For Testing')];
        System.Assert.areNotEqual(null, insertedAccounts[0].Interest_Rate__c, 'Interest rate should not be null');
        System.Assert.areNotEqual(null, insertedAccounts[1].Interest_Rate__c, 'Interest rate should not be null');
        System.Assert.areNotEqual(null, insertedAccounts[2].Interest_Rate__c, 'Interest rate should not be null');

        System.Assert.areEqual('012bm0000029Hi6AAE', insertedAccounts[0].RecordTypeId);
        System.Assert.areEqual('012bm0000029FzlAAE', insertedAccounts[1].RecordTypeId);
        System.Assert.areEqual('012bm0000029HDPAA2', insertedAccounts[2].RecordTypeId);

        System.Assert.areEqual((insertedAccounts[0].Interest_Rate__c / 100) * insertedAccounts[0].Account_Balance__c, insertedAccounts[0].Calculated_Interest__c, 'Calculated Interest Should be (' + insertedAccounts[0].Interest_Rate__c + '/' + '100)*' + insertedAccounts[0].Account_Balance__c);
        System.Assert.areEqual((insertedAccounts[1].Interest_Rate__c / 100) * insertedAccounts[1].Account_Balance__c, insertedAccounts[1].Calculated_Interest__c, 'Calculated Interest Should be (' + insertedAccounts[1].Interest_Rate__c + '/' + '100)*' + insertedAccounts[1].Account_Balance__c);
        System.Assert.areEqual((insertedAccounts[2].Interest_Rate__c / 100) * insertedAccounts[2].Account_Balance__c, insertedAccounts[2].Calculated_Interest__c, 'Calculated Interest Should be (' + insertedAccounts[2].Interest_Rate__c + '/' + '100)*' + insertedAccounts[2].Account_Balance__c);
    }

    @isTest
    static void beforeUpdateCarLoanTest(){
        Map<String, Account> results = new Map<String, Account>();
        List<Integer> loanAmount = new List<Integer>{ 50000, 250000, 700000 };
        Account[] testAccounts = [SELECT Name, Interest_Rate__c, Calculated_Interest__c, RecordTypeId, Account_Balance__c, Loan_Type__c, Total_Loan_Amount__c, Installments__c, Loan_Interest_Rate__c, Remaining_Loan_Amount__c, Monthly_EMI__c, Loan_Closure__c
                                  FROM Account
                                  WHERE Name IN ('Salary Account For Testing', 'Current Account For Testing', 'Transactional Account For Testing')];
        List<Account> updatedAccounts;

        Test.startTest();
        //Test 1
        for (Account acc : testAccounts){
            if (acc.Name == 'Salary Account For Testing'){
                acc.Loan_Type__c = 'Car Loan';
                acc.Total_Loan_Amount__c = loanAmount[0];
                acc.Installments__c = '120';
            } else if (acc.Name == 'Current Account For Testing'){
                acc.Loan_Type__c = 'Car Loan';
                acc.Total_Loan_Amount__c = loanAmount[0];
                acc.Installments__c = '120';

            } else if (acc.Name == 'Transactional Account For Testing'){
                acc.Loan_Type__c = 'Car Loan';
                acc.Total_Loan_Amount__c = loanAmount[0];
                acc.Installments__c = '120';
            }
        }
        update testAccounts;
        // Quering results
        updatedAccounts = [SELECT Name, Interest_Rate__c, Calculated_Interest__c, RecordTypeId, Account_Balance__c, Loan_Type__c, Total_Loan_Amount__c, Installments__c, Loan_Interest_Rate__c, Remaining_Loan_Amount__c, Monthly_EMI__c, Loan_Closure__c
                           FROM Account
                           WHERE Name IN ('Salary Account For Testing', 'Current Account For Testing', 'Transactional Account For Testing')];
        //Saving Results 1
        for (Account acc : updatedAccounts){
            if (!results.containsKey(acc.Name + ' Result 1')){
                results.put(acc.Name + ' Result 1', acc);
            }
        }
        // reseting
        updatedAccounts[0].Loan_Type__c = null;
        // updatedAccounts[0].Loan_Closure__c = true;
        updatedAccounts[1].Loan_Type__c = null;
        // updatedAccounts[1].Loan_Closure__c = true;
        updatedAccounts[2].Loan_Type__c = null;
        // updatedAccounts[2].Loan_Closure__c = true;

        update updatedAccounts;

        //Test 2
        testAccounts = [SELECT Name, Interest_Rate__c, Calculated_Interest__c, RecordTypeId, Account_Balance__c, Loan_Type__c, Total_Loan_Amount__c, Installments__c, Loan_Interest_Rate__c, Remaining_Loan_Amount__c, Monthly_EMI__c, Loan_Closure__c
                        FROM Account
                        WHERE Name IN ('Salary Account For Testing', 'Current Account For Testing', 'Transactional Account For Testing')];
        for (Account acc : testAccounts){
            if (acc.Name == 'Salary Account For Testing'){
                acc.Loan_Type__c = 'Car Loan';
                acc.Total_Loan_Amount__c = loanAmount[1];
                // acc.Total_Loan_Amount__c = loanAmount[1];
                acc.Installments__c = '120';
            } else if (acc.Name == 'Current Account For Testing'){
                acc.Loan_Type__c = 'Car Loan';
                acc.Total_Loan_Amount__c = loanAmount[1];
                acc.Installments__c = '120';

            } else if (acc.Name == 'Transactional Account For Testing'){
                acc.Loan_Type__c = 'Car Loan';
                acc.Total_Loan_Amount__c = loanAmount[1];
                acc.Installments__c = '120';
            }
        }
        update testAccounts;
        // Quering results
        updatedAccounts = [SELECT Name, Interest_Rate__c, Calculated_Interest__c, RecordTypeId, Account_Balance__c, Loan_Type__c, Total_Loan_Amount__c, Installments__c, Loan_Interest_Rate__c, Remaining_Loan_Amount__c, Monthly_EMI__c, Loan_Closure__c
                           FROM Account
                           WHERE Name IN ('Salary Account For Testing', 'Current Account For Testing', 'Transactional Account For Testing')];
        //Saving Results 1
        for (Account acc : updatedAccounts){
            if (!results.containsKey(acc.Name + ' Result 2')){
                results.put(acc.Name + ' Result 2', acc);
            }
        }
        // reseting
        updatedAccounts[0].Loan_Type__c = null;
        // updatedAccounts[0].Loan_Closure__c = true;
        updatedAccounts[1].Loan_Type__c = null;
        // updatedAccounts[1].Loan_Closure__c = true;
        updatedAccounts[2].Loan_Type__c = null;
        // updatedAccounts[2].Loan_Closure__c = true;

        update updatedAccounts;

        //Test 3
        testAccounts = [SELECT Name, Interest_Rate__c, Calculated_Interest__c, RecordTypeId, Account_Balance__c, Loan_Type__c, Total_Loan_Amount__c, Installments__c, Loan_Interest_Rate__c, Remaining_Loan_Amount__c, Monthly_EMI__c, Loan_Closure__c
                        FROM Account
                        WHERE Name IN ('Salary Account For Testing', 'Current Account For Testing', 'Transactional Account For Testing')];
        for (Account acc : testAccounts){
            if (acc.Name == 'Salary Account For Testing'){
                // acc.Loan_Type__c = 'Car Loan';
                // acc.Total_Loan_Amount__c = loanAmount[2];
                // acc.Installments__c = '120';
                continue;
            } else if (acc.Name == 'Current Account For Testing'){
                acc.Loan_Type__c = 'Car Loan';
                acc.Total_Loan_Amount__c = loanAmount[2];
                acc.Installments__c = '120';

            } else if (acc.Name == 'Transactional Account For Testing'){
                acc.Loan_Type__c = 'Car Loan';
                acc.Total_Loan_Amount__c = loanAmount[2];
                acc.Installments__c = '120';
            }
        }

        update testAccounts;
        // Quering results
        updatedAccounts = [SELECT Name, Interest_Rate__c, Calculated_Interest__c, RecordTypeId, Account_Balance__c, Loan_Type__c, Total_Loan_Amount__c, Installments__c, Loan_Interest_Rate__c, Remaining_Loan_Amount__c, Monthly_EMI__c, Loan_Closure__c
                           FROM Account
                           WHERE Name IN ('Salary Account For Testing', 'Current Account For Testing', 'Transactional Account For Testing')];
        //Saving Results 1
        for (Account acc : updatedAccounts){
            if (!results.containsKey(acc.Name + ' Result 3')){
                results.put(acc.Name + ' Result 3', acc);
            }
        }
        Test.stopTest();
        //50000
        System.assert.areEqual(0.084, results.get('Salary Account For Testing Result 1').Loan_Interest_Rate__c);
        System.assert.areEqual(loanAmount[0] + (loanAmount[0] * results.get('Salary Account For Testing Result 1').Loan_Interest_Rate__c), results.get('Salary Account For Testing Result 1').Remaining_Loan_Amount__c);
        System.assert.areEqual(results.get('Salary Account For Testing Result 1').Remaining_Loan_Amount__c / 120, results.get('Salary Account For Testing Result 1').Monthly_EMI__c);
        System.assert.areNotEqual(true, results.get('Salary Account For Testing Result 1').Loan_Closure__c);

        System.assert.areEqual(0.09, results.get('Current Account For Testing Result 1').Loan_Interest_Rate__c);
        System.assert.areEqual(loanAmount[0] + (loanAmount[0] * results.get('Current Account For Testing Result 1').Loan_Interest_Rate__c), results.get('Current Account For Testing Result 1').Remaining_Loan_Amount__c);
        System.assert.areEqual(results.get('Current Account For Testing Result 1').Remaining_Loan_Amount__c / 120, results.get('Current Account For Testing Result 1').Monthly_EMI__c);
        System.assert.areNotEqual(true, results.get('Current Account For Testing Result 1').Loan_Closure__c);


        System.assert.areEqual(0.07, results.get('Transactional Account For Testing Result 1').Loan_Interest_Rate__c);
        System.assert.areEqual(loanAmount[0] + (loanAmount[0] * results.get('Transactional Account For Testing Result 1').Loan_Interest_Rate__c), results.get('Transactional Account For Testing Result 1').Remaining_Loan_Amount__c);
        System.assert.areEqual(results.get('Transactional Account For Testing Result 1').Remaining_Loan_Amount__c / 120, results.get('Transactional Account For Testing Result 1').Monthly_EMI__c);
        System.assert.areNotEqual(true, results.get('Transactional Account For Testing Result 1').Loan_Closure__c);


        //250000
        System.assert.areEqual(0.103, results.get('Salary Account For Testing Result 2').Loan_Interest_Rate__c);
        System.assert.areEqual(loanAmount[1] + (loanAmount[1] * results.get('Salary Account For Testing Result 2').Loan_Interest_Rate__c), results.get('Salary Account For Testing Result 2').Remaining_Loan_Amount__c);
        System.assert.areEqual(results.get('Salary Account For Testing Result 2').Remaining_Loan_Amount__c / 120, results.get('Salary Account For Testing Result 2').Monthly_EMI__c);
        System.assert.areNotEqual(true, results.get('Salary Account For Testing Result 2').Loan_Closure__c);


        System.assert.areEqual(0.119, results.get('Current Account For Testing Result 2').Loan_Interest_Rate__c);
        System.assert.areEqual(loanAmount[1] + (loanAmount[1] * results.get('Current Account For Testing Result 2').Loan_Interest_Rate__c), results.get('Current Account For Testing Result 2').Remaining_Loan_Amount__c);
        System.assert.areEqual(results.get('Current Account For Testing Result 2').Remaining_Loan_Amount__c / 120, results.get('Current Account For Testing Result 2').Monthly_EMI__c);
        System.assert.areNotEqual(true, results.get('Current Account For Testing Result 2').Loan_Closure__c);


        System.assert.areEqual(0.109, results.get('Transactional Account For Testing Result 2').Loan_Interest_Rate__c);
        System.assert.areEqual(loanAmount[1] + (loanAmount[1] * results.get('Transactional Account For Testing Result 2').Loan_Interest_Rate__c), results.get('Transactional Account For Testing Result 2').Remaining_Loan_Amount__c);
        System.assert.areEqual(results.get('Transactional Account For Testing Result 2').Remaining_Loan_Amount__c / 120, results.get('Transactional Account For Testing Result 2').Monthly_EMI__c);
        System.assert.areNotEqual(true, results.get('Transactional Account For Testing Result 2').Loan_Closure__c);


        //700000
        // System.assert.areEqual(0.084,results.get('Salary Account For Testing Result 3').Loan_Interest_Rate__c)
        // System.assert.areEqual(loanAmount[2]+(loanAmount[2]*results.get('Salary Account For Testing Result 3').Loan_Interest_Rate__c),results.get('Salary Account For Testing Result 3').Remaining_Loan_Amount__c);
        // System.assert.areEqual(results.get('Salary Account For Testing Result 3').Remaining_Loan_Amount__c/120, results.get('Salary Account For Testing Result 3').Monthly_EMI__c);
        // System.assert.areNotEqual(true, results.get('Salary Account For Testing Result 3').Loan_Closure__c);

        System.assert.areEqual(0.146, results.get('Current Account For Testing Result 3').Loan_Interest_Rate__c);
        System.assert.areEqual(loanAmount[2] + (loanAmount[2] * results.get('Current Account For Testing Result 3').Loan_Interest_Rate__c), results.get('Current Account For Testing Result 3').Remaining_Loan_Amount__c);
        System.assert.areEqual(results.get('Current Account For Testing Result 3').Remaining_Loan_Amount__c / 120, results.get('Current Account For Testing Result 3').Monthly_EMI__c);
        System.assert.areNotEqual(true, results.get('Current Account For Testing Result 3').Loan_Closure__c);

        System.assert.areEqual(0.136, results.get('Transactional Account For Testing Result 3').Loan_Interest_Rate__c);
        System.assert.areEqual(loanAmount[2] + (loanAmount[2] * results.get('Transactional Account For Testing Result 3').Loan_Interest_Rate__c), results.get('Transactional Account For Testing Result 3').Remaining_Loan_Amount__c);
        System.assert.areEqual(results.get('Transactional Account For Testing Result 3').Remaining_Loan_Amount__c / 120, results.get('Transactional Account For Testing Result 3').Monthly_EMI__c);
        System.assert.areNotEqual(true, results.get('Transactional Account For Testing Result 3').Loan_Closure__c);
    }
    @isTest
    static void beforeUpdateHomeLoanTest(){
        Map<String, Account> results = new Map<String, Account>();
        List<Integer> loanAmount = new List<Integer>{ 50000, 250000, 700000 };
        Account[] testAccounts = [SELECT Name, Interest_Rate__c, Calculated_Interest__c, RecordTypeId, Account_Balance__c, Loan_Type__c, Total_Loan_Amount__c, Installments__c, Loan_Interest_Rate__c, Remaining_Loan_Amount__c, Monthly_EMI__c, Loan_Closure__c
                                  FROM Account
                                  WHERE Name IN ('Salary Account For Testing', 'Current Account For Testing', 'Transactional Account For Testing')];
        List<Account> updatedAccounts;

        Test.startTest();
        //Test 1
        for (Account acc : testAccounts){
            if (acc.Name == 'Salary Account For Testing'){
                acc.Loan_Type__c = 'Home Loan';
                acc.Total_Loan_Amount__c = loanAmount[0];
                acc.Installments__c = '240';
            } else if (acc.Name == 'Current Account For Testing'){
                acc.Loan_Type__c = 'Home Loan';
                acc.Total_Loan_Amount__c = loanAmount[0]*10;
                acc.Installments__c = '240';

            } else if (acc.Name == 'Transactional Account For Testing'){
                acc.Loan_Type__c = 'Home Loan';
                acc.Total_Loan_Amount__c = loanAmount[0];
                acc.Installments__c = '240';
            }
        }
        update testAccounts;
        // Quering results
        updatedAccounts = [SELECT Name, Interest_Rate__c, Calculated_Interest__c, RecordTypeId, Account_Balance__c, Loan_Type__c, Total_Loan_Amount__c, Installments__c, Loan_Interest_Rate__c, Remaining_Loan_Amount__c, Monthly_EMI__c, Loan_Closure__c
                           FROM Account
                           WHERE Name IN ('Salary Account For Testing', 'Current Account For Testing', 'Transactional Account For Testing')];
        //Saving Results 1
        for (Account acc : updatedAccounts){
            if (!results.containsKey(acc.Name + ' Result 1')){
                results.put(acc.Name + ' Result 1', acc);
            }
        }
        // reseting
        updatedAccounts[0].Loan_Type__c = null;
        // updatedAccounts[0].Loan_Closure__c = true;
        updatedAccounts[1].Loan_Type__c = null;
        // updatedAccounts[1].Loan_Closure__c = true;
        updatedAccounts[2].Loan_Type__c = null;
        // updatedAccounts[2].Loan_Closure__c = true;

        update updatedAccounts;

        //Test 2
        testAccounts = [SELECT Name, Interest_Rate__c, Calculated_Interest__c, RecordTypeId, Account_Balance__c, Loan_Type__c, Total_Loan_Amount__c, Installments__c, Loan_Interest_Rate__c, Remaining_Loan_Amount__c, Monthly_EMI__c, Loan_Closure__c
                        FROM Account
                        WHERE Name IN ('Salary Account For Testing', 'Current Account For Testing', 'Transactional Account For Testing')];
        for (Account acc : testAccounts){
            if (acc.Name == 'Salary Account For Testing'){
                acc.Loan_Type__c = 'Home Loan';
                acc.Total_Loan_Amount__c = loanAmount[1];
                // acc.Total_Loan_Amount__c = loanAmount[1];
                acc.Installments__c = '240';
            } else if (acc.Name == 'Current Account For Testing'){
                acc.Loan_Type__c = 'Home Loan';
                acc.Total_Loan_Amount__c = loanAmount[1]*10;
                acc.Installments__c = '240';

            } else if (acc.Name == 'Transactional Account For Testing'){
                acc.Loan_Type__c = 'Home Loan';
                acc.Total_Loan_Amount__c = loanAmount[1];
                acc.Installments__c = '240';
            }
        }
        update testAccounts;
        // Quering results
        updatedAccounts = [SELECT Name, Interest_Rate__c, Calculated_Interest__c, RecordTypeId, Account_Balance__c, Loan_Type__c, Total_Loan_Amount__c, Installments__c, Loan_Interest_Rate__c, Remaining_Loan_Amount__c, Monthly_EMI__c, Loan_Closure__c
                           FROM Account
                           WHERE Name IN ('Salary Account For Testing', 'Current Account For Testing', 'Transactional Account For Testing')];
        //Saving Results 1
        for (Account acc : updatedAccounts){
            if (!results.containsKey(acc.Name + ' Result 2')){
                results.put(acc.Name + ' Result 2', acc);
            }
        }
        // reseting
        updatedAccounts[0].Loan_Type__c = null;
        // updatedAccounts[0].Loan_Closure__c = true;
        updatedAccounts[1].Loan_Type__c = null;
        // updatedAccounts[1].Loan_Closure__c = true;
        updatedAccounts[2].Loan_Type__c = null;
        // updatedAccounts[2].Loan_Closure__c = true;

        update updatedAccounts;

        //Test 3
        testAccounts = [SELECT Name, Interest_Rate__c, Calculated_Interest__c, RecordTypeId, Account_Balance__c, Loan_Type__c, Total_Loan_Amount__c, Installments__c, Loan_Interest_Rate__c, Remaining_Loan_Amount__c, Monthly_EMI__c, Loan_Closure__c
                        FROM Account
                        WHERE Name IN ('Salary Account For Testing', 'Current Account For Testing', 'Transactional Account For Testing')];
        for (Account acc : testAccounts){
            if (acc.Name == 'Salary Account For Testing'){
                acc.Loan_Type__c = 'Home Loan';
                acc.Total_Loan_Amount__c = loanAmount[2];
                acc.Installments__c = '240';
            } else if (acc.Name == 'Current Account For Testing'){
                acc.Loan_Type__c = 'Home Loan';
                acc.Total_Loan_Amount__c = loanAmount[2]*10;
                acc.Installments__c = '240';

            } else if (acc.Name == 'Transactional Account For Testing'){
                acc.Loan_Type__c = 'Home Loan';
                acc.Total_Loan_Amount__c = loanAmount[2];
                acc.Installments__c = '240';
            }
        }

        update testAccounts;
        // Quering results
        updatedAccounts = [SELECT Name, Interest_Rate__c, Calculated_Interest__c, RecordTypeId, Account_Balance__c, Loan_Type__c, Total_Loan_Amount__c, Installments__c, Loan_Interest_Rate__c, Remaining_Loan_Amount__c, Monthly_EMI__c, Loan_Closure__c
                           FROM Account
                           WHERE Name IN ('Salary Account For Testing', 'Current Account For Testing', 'Transactional Account For Testing')];
        //Saving Results 1
        for (Account acc : updatedAccounts){
            if (!results.containsKey(acc.Name + ' Result 3')){
                results.put(acc.Name + ' Result 3', acc);
            }
        }
        Test.stopTest();
        //50000
        System.assert.areEqual(0.08, results.get('Salary Account For Testing Result 1').Loan_Interest_Rate__c);
        System.assert.areEqual(loanAmount[0] + (loanAmount[0] * results.get('Salary Account For Testing Result 1').Loan_Interest_Rate__c), results.get('Salary Account For Testing Result 1').Remaining_Loan_Amount__c);
        System.assert.areEqual(results.get('Salary Account For Testing Result 1').Remaining_Loan_Amount__c / 240, results.get('Salary Account For Testing Result 1').Monthly_EMI__c);
        System.assert.areNotEqual(true, results.get('Salary Account For Testing Result 1').Loan_Closure__c);

        System.assert.areEqual(0.10, results.get('Current Account For Testing Result 1').Loan_Interest_Rate__c);
        System.assert.areEqual((loanAmount[0]*10) + ((loanAmount[0]*10) * results.get('Current Account For Testing Result 1').Loan_Interest_Rate__c), results.get('Current Account For Testing Result 1').Remaining_Loan_Amount__c);
        System.assert.areEqual(results.get('Current Account For Testing Result 1').Remaining_Loan_Amount__c / 240, results.get('Current Account For Testing Result 1').Monthly_EMI__c);
        System.assert.areNotEqual(true, results.get('Current Account For Testing Result 1').Loan_Closure__c);


        System.assert.areEqual(0.09, results.get('Transactional Account For Testing Result 1').Loan_Interest_Rate__c);
        System.assert.areEqual(loanAmount[0] + (loanAmount[0] * results.get('Transactional Account For Testing Result 1').Loan_Interest_Rate__c), results.get('Transactional Account For Testing Result 1').Remaining_Loan_Amount__c);
        System.assert.areEqual(results.get('Transactional Account For Testing Result 1').Remaining_Loan_Amount__c / 240, results.get('Transactional Account For Testing Result 1').Monthly_EMI__c);
        System.assert.areNotEqual(true, results.get('Transactional Account For Testing Result 1').Loan_Closure__c);


        //250000
        System.assert.areEqual(0.11, results.get('Salary Account For Testing Result 2').Loan_Interest_Rate__c);
        System.assert.areEqual(loanAmount[1] + (loanAmount[1] * results.get('Salary Account For Testing Result 2').Loan_Interest_Rate__c), results.get('Salary Account For Testing Result 2').Remaining_Loan_Amount__c);
        System.assert.areEqual(results.get('Salary Account For Testing Result 2').Remaining_Loan_Amount__c / 240, results.get('Salary Account For Testing Result 2').Monthly_EMI__c);
        System.assert.areNotEqual(true, results.get('Salary Account For Testing Result 2').Loan_Closure__c);


        System.assert.areEqual(0.125, results.get('Current Account For Testing Result 2').Loan_Interest_Rate__c);
        System.assert.areEqual((loanAmount[1]*10) + ((loanAmount[1]*10) * results.get('Current Account For Testing Result 2').Loan_Interest_Rate__c), results.get('Current Account For Testing Result 2').Remaining_Loan_Amount__c);
        System.assert.areEqual(results.get('Current Account For Testing Result 2').Remaining_Loan_Amount__c / 240, results.get('Current Account For Testing Result 2').Monthly_EMI__c);
        System.assert.areNotEqual(true, results.get('Current Account For Testing Result 2').Loan_Closure__c);


        System.assert.areEqual(0.118, results.get('Transactional Account For Testing Result 2').Loan_Interest_Rate__c);
        System.assert.areEqual(loanAmount[1] + (loanAmount[1] * results.get('Transactional Account For Testing Result 2').Loan_Interest_Rate__c), results.get('Transactional Account For Testing Result 2').Remaining_Loan_Amount__c);
        System.assert.areEqual(results.get('Transactional Account For Testing Result 2').Remaining_Loan_Amount__c / 240, results.get('Transactional Account For Testing Result 2').Monthly_EMI__c);
        System.assert.areNotEqual(true, results.get('Transactional Account For Testing Result 2').Loan_Closure__c);


        //700000
        System.assert.areEqual(0.14,results.get('Salary Account For Testing Result 3').Loan_Interest_Rate__c);
        System.assert.areEqual(loanAmount[2]+(loanAmount[2]*results.get('Salary Account For Testing Result 3').Loan_Interest_Rate__c),results.get('Salary Account For Testing Result 3').Remaining_Loan_Amount__c);
        System.assert.areEqual(results.get('Salary Account For Testing Result 3').Remaining_Loan_Amount__c/240, results.get('Salary Account For Testing Result 3').Monthly_EMI__c);
        System.assert.areNotEqual(true, results.get('Salary Account For Testing Result 3').Loan_Closure__c);

        System.assert.areEqual(0.162, results.get('Current Account For Testing Result 3').Loan_Interest_Rate__c);
        System.assert.areEqual((loanAmount[2]*10) + ((loanAmount[2]*10) * results.get('Current Account For Testing Result 3').Loan_Interest_Rate__c), results.get('Current Account For Testing Result 3').Remaining_Loan_Amount__c);
        System.assert.areEqual(results.get('Current Account For Testing Result 3').Remaining_Loan_Amount__c / 240, results.get('Current Account For Testing Result 3').Monthly_EMI__c);
        System.assert.areNotEqual(true, results.get('Current Account For Testing Result 3').Loan_Closure__c);

        System.assert.areEqual(0.159, results.get('Transactional Account For Testing Result 3').Loan_Interest_Rate__c);
        System.assert.areEqual(loanAmount[2] + (loanAmount[2] * results.get('Transactional Account For Testing Result 3').Loan_Interest_Rate__c), results.get('Transactional Account For Testing Result 3').Remaining_Loan_Amount__c);
        System.assert.areEqual(results.get('Transactional Account For Testing Result 3').Remaining_Loan_Amount__c / 240, results.get('Transactional Account For Testing Result 3').Monthly_EMI__c);
        System.assert.areNotEqual(true, results.get('Transactional Account For Testing Result 3').Loan_Closure__c);
    }

}