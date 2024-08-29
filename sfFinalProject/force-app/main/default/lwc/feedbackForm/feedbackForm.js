import { LightningElement, track } from 'lwc';
import saveFeedback from '@salesforce/apex/FeedbackController.saveFeedback';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import getAccountName from '@salesforce/apex/FeedbackController.getAccountName';

export default class FeedbackForm extends NavigationMixin(LightningElement) {
    @track rating;
    @track comments;
    @track relatedRecordName;
    @track showRelatedRecordName = false;
    accountId;

    @track ratingOptions = [
        { label: 'Bad', value: 'Bad' },
        { label: 'Neutral', value: 'Neutral' },
        { label: 'Good', value: 'Good' },
        { label: 'Excellent', value: 'Excellent' }
    ];

    connectedCallback() {
        // Get URL parameters
        const urlParams = new URLSearchParams(window.location.search);
        this.accountId = urlParams.get('accountId');
        console.log('accountId: ' + this.accountId);

        if (this.accountId) {
            this.showRelatedRecordName = true;
            // Fetch the account name based on the accountId
            getAccountName({ accountId: this.accountId })
                .then(result => {
                    this.relatedRecordName = result; // Set account name in related record name
                })
                .catch(error => {
                    console.error('Error fetching account name:', error);
                });
        }
    }

    handleInputChange(event) {
        const field = event.target.dataset.id;
        if (field === 'rating') {
            this.rating = event.target.value;
        } else if (field === 'comments') {
            this.comments = event.target.value;
        }
    }

    handleSubmit() {
        const feedbackData = {
            Rating__c: this.rating,
            Comments__c: this.comments,
            Account__c: this.accountId
        };

        saveFeedback({ feedback: feedbackData })
            .then(() => {
                this.showToast('Success', 'Feedback submitted successfully', 'success');
            })
            .catch(error => {
                this.showToast('Error', 'Error submitting feedback', 'error');
                console.error(error);
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}