public with sharing class AccountController {
    public Account account { get; set; }

    public AccountController(ApexPages.StandardController controller) {
        this.account = [SELECT Id, Name, Loan_Type__c, Email__c, Total_Loan_Amount__c, Remaining_Loan_Amount__c 
                        FROM Account 
                        WHERE Id = :controller.getId()
                        WITH SECURITY_ENFORCED];
    }
}