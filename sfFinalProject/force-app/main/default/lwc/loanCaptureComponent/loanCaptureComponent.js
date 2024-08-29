import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveLoanData from '@salesforce/apex/LoanDataController.saveLoanData'; // Import the save method
import { getRecord } from 'lightning/uiRecordApi';
import ACCOUNT_NAME_FIELD from '@salesforce/schema/Account.Name'; // Import the Account Name field
import ACCOUNT_LOAN_TYPE_FIELD from '@salesforce/schema/Account.Loan_Type__c'; // Import the Account Name field

export default class LoanCaptureComponent extends LightningElement {
    @api recordId; // To get the current account record ID
    @track accountName; // To store the account name
    @track loanType;
    @track totalLoanAmount;
    @track remainingLoanAmount;
    @track installments;

    accountHasLoan;

    // Use the @wire decorator to fetch the account name
    @wire(getRecord, { recordId: '$recordId', fields: [ACCOUNT_NAME_FIELD, ACCOUNT_LOAN_TYPE_FIELD] })
    wiredAccount({ error, data }) {
        if (data) {
            this.accountName = data.fields.Name.value; // Set the account name
            this.accountHasLoan = data.fields.Loan_Type__c.value ? true : false;
            console.log('Loan Type!!', this.accountHasLoan); // Set the account loanType
        } else if (error) {
            console.error('Error fetching account name:', error); // Handle errors
        }
    }

    // Define picklist options for Loan Type
    get loanTypeOptions() {
        return [
            { label: 'Home Loan', value: 'Home Loan' },
            { label: 'Car Loan', value: 'Car Loan' }
        ];
    }
    // Define picklist options for Installments.
    get installmentOptions() {

        if (this.loanType === 'Home Loan') {
            return [
                { label: '20 years', value: '240' },
                { label: '25 years', value: '300' },
                { label: '30 years', value: '360' }
            ];
        }
        else if (this.loanType === 'Car Loan') {
            return [
                { label: '5 years', value: '60' },
                { label: '8 years', value: '96' },
                { label: '10 years', value: '120' }
            ];
        }
    }
    get isLoanTypeEmpty() {
        return this.loanType ? false : true;
    }

    get isAllFieldsNotEmpty() {
        return this.loanType && this.totalLoanAmount && this.installments ? false : true;
    }
    // Handle input changes
    handleInputChange(event) {
        const field = event.target.name;
        if (field === 'loanType') {
            this.loanType = event.target.value;
        } else if (field === 'totalLoanAmount') {
            this.totalLoanAmount = event.target.value;
        } else if (field === 'installments') {
            this.installments = event.target.value;
        }
    }

    // Handle form submission
    handleSubmit() {
        // Prepare the account data to save
        if (this.accountHasLoan) {
            this.showToast('Error', 'This Account Already Has An Active Loan', 'error')
        } else {

            const accountRecord = {
                Id: this.recordId, // Use the current record ID
                Loan_Type__c: this.loanType,
                Total_Loan_Amount__c: this.totalLoanAmount,
                Remaining_Loan_Amount__c: this.remainingLoanAmount,
                Installments__c: this.installments
            };

            // Debug logs to check values before sending to Apex
            console.log('Submitting loan data:', accountRecord);

            // Call the Apex method to save data
            saveLoanData({ acc: accountRecord })
                .then(() => {
                    // Show a success toast message
                    this.showToast('Success', 'Loan details submitted successfully!', 'success');

                    // Optional: Add code to refresh the data table
                    const refreshEvent = new CustomEvent('refreshdatatable');
                    this.dispatchEvent(refreshEvent);
                })
                .catch(error => {
                    // Handle error and show error toast message
                    console.error('Error saving loan data:', error);
                    this.showToast('Error', 'Failed to submit loan details.', 'error');
                });
        }

    }

    // Show toast notification
    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(toastEvent);
    }
}