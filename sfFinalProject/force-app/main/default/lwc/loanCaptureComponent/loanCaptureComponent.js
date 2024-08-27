import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveLoanData from '@salesforce/apex/LoanDataController.saveLoanData'; // Import the save method
import { getRecord } from 'lightning/uiRecordApi';
import ACCOUNT_NAME_FIELD from '@salesforce/schema/Account.Name'; // Import the Account Name field

export default class LoanCaptureComponent extends LightningElement {
    @api recordId; // To get the current account record ID
    @track accountName; // To store the account name
    @track loanType;
    @track totalLoanAmount;
    @track remainingLoanAmount;


    // Use the @wire decorator to fetch the account name
    @wire(getRecord, { recordId: '$recordId', fields: [ACCOUNT_NAME_FIELD] })
    wiredAccount({ error, data }) {
        if (data) {
            this.accountName = data.fields.Name.value; // Set the account name
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

    // Handle input changes
    handleInputChange(event) {
        const field = event.target.name;
        if (field === 'loanType') {
            this.loanType = event.target.value;
        } else if (field === 'totalLoanAmount') {
            this.totalLoanAmount = event.target.value;
        }
    }

    // Handle form submission
    handleSubmit() {
        // Prepare the account data to save
        const accountRecord = {
            Id: this.recordId, // Use the current record ID
            Loan_Type__c: this.loanType,
            Total_Loan_Amount__c: this.totalLoanAmount,
            Remaining_Loan_Amount__c: this.remainingLoanAmount,
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