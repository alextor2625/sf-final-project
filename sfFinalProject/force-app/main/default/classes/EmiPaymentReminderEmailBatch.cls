public with sharing class EmiPaymentReminderEmailBatch implements Database.Batchable<sObject>, Database.Stateful {
    // Start Method: Query Locator
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Query all contacts with related accounts that have loan EMIs
      
        return Database.getQueryLocator(
            [SELECT id, Name, Email__c, Remaining_Loan_Amount__c, Total_Loan_Amount__c, Monthly_EMI__c, (SELECT id, FirstName, LastName, Email FROM Contacts) 
            FROM Account 
            WHERE Remaining_Loan_Amount__c > 0]
            );
    }

    // Execute Method: Process Batch of Records

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        // Generate Email template
        EmailTemplate emailTemplate = [SELECT Id FROM EmailTemplate WHERE developerName = 'Monthly_EMI_Reminder'];

        // Create List of Emails to send
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Account acc : scope) {
            string emailToSend;
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            string htmlbody = '<!DOCTYPE html>' +
                          '<html lang="en">' +
                          '<head>' +
                          '    <meta charset="UTF-8">' +
                          '    <meta name="viewport" content="width=device-width, initial-scale=1.0">' +
                          '    <title>Time to Pay!</title>' +
                          '    <style>' +
                          '        body {' +
                          '            font-family: Arial, sans-serif;' +
                          '            background-color: #f4f4f4;' +
                          '            margin: 0;' +
                          '            padding: 0;' +
                          '            color: #333333;' +
                          '        }' +
                          '        .container {' +
                          '            width: 100%;' +
                          '            max-width: 600px;' +
                          '            margin: 0 auto;' +
                          '            background-color: #ffffff;' +
                          '            padding: 20px;' +
                          '            border-radius: 8px;' +
                          '            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);' +
                          '        }' +
                          '        .header {' +
                          '            background-color: #007bff;' +
                          '            color: #ffffff;' +
                          '            padding: 10px;' +
                          '            text-align: center;' +
                          '            border-radius: 8px 8px 0 0;' +
                          '        }' +
                          '        .header h1 {' +
                          '            margin: 0;' +
                          '            font-size: 24px;' +
                          '        }' +
                          '        .content {' +
                          '            padding: 20px;' +
                          '        }' +
                          '        .content p {' +
                          '            margin: 0 0 15px;' +
                          '            line-height: 1.5;' +
                          '        }' +
                          '        .content .highlight {' +
                          '            font-weight: bold;' +
                          '        }' +
                          '        .footer {' +
                          '            text-align: center;' +
                          '            padding: 10px;' +
                          '            font-size: 12px;' +
                          '            color: #888888;' +
                          '            border-top: 1px solid #dddddd;' +
                          '            margin-top: 20px;' +
                          '        }' +
                          '    </style>' +
                          '</head>' +
                          '<body>' +
                          '    <div class="container">' +
                          '        <div class="header">' +
                          '            <h1>Time to Pay!</h1>' +
                          '        </div>' +
                          '        <div class="content">' +
                          '            <p>It\'s that time of the month again! Time for your beloved EMI payment!</p>' +
                          '            <p><span class="highlight">Loan/Account Details (Because We Love to Remind You):</span></p>' +
                          '            <p><strong>Account Name:</strong> ' + acc.Name + '</p>' +
                          '            <p><strong>Total Loan Amount:</strong> ' + acc.Total_Loan_Amount__c + '</p>' +
                          '            <p><strong>EMI Amount:</strong> ' + acc.Monthly_EMI__c + '</p>' +
                          '            <p><strong>Remaining Balance:</strong> ' + acc.Remaining_Loan_Amount__c + ' (Just in case you were curious... or not.)</p>' +
                          '            <p>We know you\'re super excited to part with your hard-earned cash, so don\'t keep us waiting! Pay up by ASAP to avoid any of those nasty late fees that no one likes (especially your wallet).</p>' +
                          '            <p>Payment methods? We\'ve got options! Pay online, by check, or send us a carrier pigeon (okay, maybe not that last one).</p>' +
                          '            <p>Cheers<br>' + '</p>' +
                          '        </div>' +
                          '        <div class="footer">' +
                          '            <p>&copy; 2024 Your Company Name. All rights reserved.</p>' +
                          '        </div>' +
                          '    </div>' +
                          '</body>' +
                          '</html>';

            if (!acc.Contacts.isEmpty()) {
                emailToSend = acc.Contacts[0].Email;
                email.setToAddresses( new String[] {emailToSend} );
                email.setSubject('Monthly EMI Reminder for: ' + acc.Contacts[0].LastName);
                email.setHtmlBody(htmlbody);
                emails.add(email);
            } else {
                emailToSend = acc.Email__c;
                email.setToAddresses( new String[] {emailToSend} );
                email.setSubject('Monthly EMI Reminder for: ' + acc.Name);
                email.setHtmlBody(htmlbody);
                emails.add(email);
            }
            
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }

    }

    // Finish Method
    public void finish(Database.BatchableContext bc) {
        // potential notification
        system.debug('Batch Job Completed');
    }

}