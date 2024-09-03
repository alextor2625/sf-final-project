@isTest
public class AccountTriggerHandlerTest {

    @isTest
    static void beforeInsertTest() {
        // TO DO: implement unit test
        Test.startTest();
        Account testAccount = new Account(
            RecordTypeId='012bm0000029FzlAAE',
            Name='Test Account', 
            Email__c='alextor2625@gmail.com', 
            Account_Balance__c=10000,
            Installments__c=null
        );

        insert testAccount;
        Test.stopTest();

        Account insertedAccount = [SELECT Interest_Rate__c, Calculated_Interest__c FROM Account WHERE Id=:testAccount.Id];
        System.Assert.areNotEqual(null, insertedAccount.Interest_Rate__c, 'Interest rate should not be null');
        System.Assert.areEqual(380, insertedAccount.Calculated_Interest__c);
    }
    
}