import { LightningElement, wire, api, track } from 'lwc';
import getLoanData from '@salesforce/apex/LoanDataController.getLoanData';
import { refreshApex } from '@salesforce/apex';

const COLUMNS = [
    { label: 'Account Name', fieldName: 'Name' },
    { label: 'Loan Type', fieldName: 'Loan_Type__c' },
    { label: 'Total Loan Amount', fieldName: 'Total_Loan_Amount__c', type: 'currency' },
    { label: 'Loan Interest Rate', fieldName: 'Loan_Interest_Rate__c', type: 'percent' },
    { label: 'Monthly EMI', fieldName: 'Monthly_EMI__c', type: 'currency' },
    { label: 'Remaining Loan Amount', fieldName: 'Remaining_Loan_Amount__c', type: 'currency' }
];

export default class LoanDataTable extends LightningElement {
    @api recordId; // Accept the account record ID from the parent component
    @track data = [];
    @track columns = COLUMNS;
    wiredLoanDataResult;

    // Wire the Apex method to fetch loan data for the given account ID
    @wire(getLoanData, { accountId: '$recordId' })
    wiredLoanData(result) {
        this.wiredLoanDataResult = result; // Save the result for refreshing
        if (result.data) {
            this.data = result.data;
        } else if (result.error) {
            console.error('Error fetching loan data:', result.error);
        }
    }

    // Refresh the data table when needed
    handleRefresh() {
        refreshApex(this.wiredLoanDataResult);
    }
}