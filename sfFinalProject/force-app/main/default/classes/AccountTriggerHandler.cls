public with sharing class AccountTriggerHandler {
    public static void handle(System.TriggerOperation operation) {
        switch on operation {
            when BEFORE_INSERT {
                beforeInsert(Trigger.new);
            }
            when BEFORE_UPDATE {
                beforeUpdate(Trigger.new, Trigger.oldMap);
            }
        }
    }

    private static void beforeInsert(List<Account> newAccList) {
        for (Account acc : newAccList) {
            acc.Calculated_Interest__c = calculateInterest(acc.Interest_Rate__c, acc.Account_Balance__c);
        }
    }

    private static void beforeUpdate(List<Account> newAccList, Map<Id, SObject> oldAccMap) {
        for (Account acc : newAccList) {
            Account oldAcc = (Account) oldAccMap.get(acc.Id);
            if (oldAcc.Loan_Type__c == null && oldAcc.Loan_Type__c != acc.Loan_Type__c) {
                Decimal interest = calculateInterestRate(acc.RecordTypeId, acc.Loan_Type__c, acc.Total_Loan_Amount__c);
                if (interest != null) {
                    System.debug('Success: ' + interest);
                    acc.Loan_Interest_Rate__c = interest;
                    acc.Remaining_Loan_Amount__c = acc.Total_Loan_Amount__c + (acc.Total_Loan_Amount__c*interest);
                    acc.Monthly_EMI__c = acc.Remaining_Loan_Amount__c/ Integer.valueOf(acc.Installments__c);
                } else {
                    acc.Total_Loan_Amount__c.addError('Error message - we do not provide loans beyond 500000 for this type of accounts.');
                }
            }
        }
    }

    private static Decimal calculateInterest(Decimal interestRate, Decimal balance) {
        return (interestRate / 100) * balance;
    }

    private static Decimal calculateInterestRate(String accountType, String loanType, Decimal totalLoanAmount) {
        System.debug('AccountType: ' + accountType + '\nLoanType: '+ loanType + '\nTotal Loan: ' + totalLoanAmount);
        switch on accountType {
            // Salary Account
            when '012bm0000029Hi6AAE' {
                switch on loanType {
                    when 'Home Loan' {
                        if (totalLoanAmount >= 0 && totalLoanAmount <= 100000) {
                            return 0.08;
                        } else if (totalLoanAmount >= 100001 && totalLoanAmount <= 500000) {
                            return 0.11;
                        } else if (totalLoanAmount >= 500001 && totalLoanAmount <= 1000000) {
                            return 0.14;
                        }
                    }
                    when 'Car Loan' {
                        if (totalLoanAmount >= 0 && totalLoanAmount <= 100000) {
                            return 0.084;
                        } else if (totalLoanAmount >= 100001 && totalLoanAmount <= 500000) {
                            return 0.103;
                        } else if (totalLoanAmount > 500000) {
                            system.debug('Im over 500000');
                            return null;
                        }
                    }
                }
            }
            // Transactional Account
            when '012bm0000029HDPAA2' {
                switch on loanType {
                    when 'Home Loan' {
                        if (totalLoanAmount >= 0 && totalLoanAmount <= 100000) {
                            return 0.09;
                        } else if (totalLoanAmount >= 100001 && totalLoanAmount <= 500000) {
                            return  0.118;
                        } else if (totalLoanAmount >= 500001 && totalLoanAmount <= 1000000) {
                            return 0.159;
                        }
                    }
                    when 'Car Loan' {
                        if (totalLoanAmount >= 0 && totalLoanAmount <= 100000) {
                            return 0.07;
                        } else if (totalLoanAmount >= 100001 && totalLoanAmount <= 500000) {
                            return 0.109;
                        } else if (totalLoanAmount >= 500001 && totalLoanAmount <= 1000000) {
                            return 0.136;
                        }
                    }
                }
            }
            // Current Account
            when '012bm0000029FzlAAE' {
                switch on loanType {
                    when 'Home Loan' {
                        if (totalLoanAmount >= 0 && totalLoanAmount <= 1000000) {
                            return 0.10;
                        } else if (totalLoanAmount >= 1000001 && totalLoanAmount <= 5000000) {
                            return 0.125;
                        } else if (totalLoanAmount >= 5000001 && totalLoanAmount <= 10000000) {
                            return 0.162;
                        }
                    }
                    when 'Car Loan' {
                        if (totalLoanAmount >= 0 && totalLoanAmount <= 100000) {
                            return 0.09;
                        } else if (totalLoanAmount >= 100001 && totalLoanAmount <= 500000) {
                            return 0.119;
                        } else if (totalLoanAmount >= 500001 && totalLoanAmount <= 1000000) {
                            return 0.146;
                        }
                    }
                }
            }
        }
        system.debug('I failed all other checks');
        return null;
    }
}