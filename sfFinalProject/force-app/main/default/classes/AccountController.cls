public with sharing class AccountController {
    public Account account { get; set; }

    public AccountController(ApexPages.StandardController controller) {

            Id accountId = ApexPages.currentPage().getParameters().get('accountId');
            if (accountId != null) {
                account = [SELECT Id, Name, Total_Loan_Amount__c, Monthly_EMI__c, Remaining_Loan_Amount__c, Loan_Type__c, Email__c 
                            FROM Account 
                            WHERE Id = :accountId 
                            LIMIT 1];
            }

    }
}