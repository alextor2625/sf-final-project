public with sharing class FeedbackEmailBatch implements Database.Batchable<sObject>, Database.Stateful{

     public Database.QueryLocator start(Database.BatchableContext bc) {

        // Query all Accounts
        return Database.getQueryLocator(
            [SELECT id, Name, Email__c, Remaining_Loan_Amount__c, Total_Loan_Amount__c, Monthly_EMI__c, Active__c, (SELECT id, FirstName, LastName, Email FROM Contacts) 
            FROM Account 
            WHERE Account_Balance__c > 0
            LIMIT 4] // Active__c = True
            );
    }

    // Execute Method: Process Batch of Records

    public void execute(Database.BatchableContext bc, List<Account> scope) {

        // Create List of Emails to send
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        system.debug('Accounts queried: ' + scope);

        for (Account acc : scope) {
            string emailToSend;
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            string htmlbody = '<!DOCTYPE html>' +
                                '<html lang="en">' +
                                '<head>' +
                                '    <meta charset="UTF-8">' +
                                '    <meta name="viewport" content="width=device-width, initial-scale=1.0">' +
                                '    <title>Quarterly Feedback Request</title>' +
                                '    <style>' +
                                '        body {' +
                                '            font-family: Arial, sans-serif;' +
                                '            background-color: #f4f4f4;' +
                                '            margin: 0;' +
                                '            padding: 20px;' +
                                '            color: #333;' +
                                '            text-align: center;' +
                                '        }' +
                                '        .email-container {' +
                                '            background-color: #ffffff;' +
                                '            padding: 20px;' +
                                '            border-radius: 8px;' +
                                '            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);' +
                                '            max-width: 600px;' +
                                '            margin: auto;' +
                                '            display: inline-block;' +
                                '            text-align: center;' +
                                '            border: 2px solid #d32f2f;' + /* Red from the logo */
                                '        }' +
                                '        .header {' +
                                '            font-size: 24px;' +
                                '            margin-bottom: 10px;' +
                                '            color: #004085;' + /* Blue */
                                '        }' +
                                '        .content {' +
                                '            font-size: 16px;' +
                                '            line-height: 1.5;' +
                                '            margin-bottom: 20px;' +
                                '            color: #555;' +
                                '        }' +
                                '        .cta-button {' +
                                '            display: inline-block;' +
                                '            padding: 12px 20px;' +
                                '            background-color: #d32f2f;' + /* Red from the logo */
                                '            color: #ffffff;' +
                                '            text-decoration: none;' +
                                '            border-radius: 5px;' +
                                '            font-size: 16px;' +
                                '            font-weight: bold;' +
                                '        }' +
                                '        .cta-button:hover {' +
                                '            background-color: #004085;' + /* Blue */
                                '        }' +
                                '        .footer {' +
                                '            font-size: 14px;' +
                                '            color: #004085;' + /* Blue */
                                '            margin-top: 20px;' +
                                '            text-align: center;' +
                                '        }' +
                                '        .footer img {' +
                                '            width: 40px;' +
                                '            height: 40px;' +
                                '            margin-top: 10px;' +
                                '        }' +
                                '    </style>' +
                                '</head>' +
                                '<body>' +
                                '    <div class="email-container">' +
                                '        <div class="header">' +
                                '            Dear ' + acc.Name + ',' +
                                '        </div>' +
                                '        <div class="content">' +
                                '            Guess what? It\'s time for your quarterly feedback session! 🎉 Yes, we\'re about to be "those people" asking you for your thoughts—because your opinion matters to us (seriously, it does).' +
                                '        </div>' +
                                '        <div class="content">' +
                                '            We know surveys aren\'t exactly your idea of fun (unless you\'re into that sort of thing—no judgment). But your feedback helps us make Banking with Banco better, faster, stronger—just like your favorite superhero, but with more financial security.' +
                                '        </div>' +
                                '        <div class="content">' +
                                '            Click the button below to share your thoughts. We promise it won\'t take long, and you\'ll be our hero for the day.' +
                                '        </div>' +
                                '        <div>' +
                                '            <a class="cta-button" href="https://cunning-shark-9oabw1-dev-ed.trailblaze.lightning.force.com/lightning/r/Account/' + acc.Id + '/view' + '">Give Feedback</a>' +
                                '        </div>' +
                                '        <div class="footer">' +
                                '            Thank you for being a valued part of our banking family. Keep rocking those finances! 💪<br>' +
                                '            <img src="https://cdn-icons-png.flaticon.com/512/1355/1355644.png" alt="High Five">' +
                                '        </div>' +
                                '    </div>' +
                                '</body>' +
                                '</html>';



            if (!acc.Contacts.isEmpty()) {
                if (acc.Contacts[0].Email == null) {
                    continue;
                }
                emailToSend = acc.Contacts[0].Email;
                email.setToAddresses( new String[] {emailToSend} );
                email.setSubject('Feedback Request for: ' + acc.Contacts[0].LastName);
                email.setHtmlBody(htmlbody);
                emails.add(email);
            } else {
                if (acc.Email__c == null) {
                    continue;
                }
                emailToSend = acc.Email__c;
                email.setToAddresses( new String[] {emailToSend} );
                email.setSubject('Feedback Request for: ' + acc.Name);
                email.setHtmlBody(htmlbody);
                emails.add(email);
            }
            
        }

        system.debug('Emails List length: ' + emails.size());


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