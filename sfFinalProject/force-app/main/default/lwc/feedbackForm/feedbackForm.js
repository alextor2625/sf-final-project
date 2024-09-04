import { LightningElement, track, api } from 'lwc';
import saveFeedback from '@salesforce/apex/FeedbackController.saveFeedback';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin} from 'lightning/navigation';
import getContact from '@salesforce/apex/FeedbackController.getContact';


export default class FeedbackForm extends NavigationMixin(LightningElement) {
    @track rating;
    @track comments;
    @api recordId;
    @track contactId;
    @track formSubmitted = true;

    @track ratingOptions = [
        { label: 'Bad', value: 'Bad' },
        { label: 'Neutral', value: 'Neutral' },
        { label: 'Good', value: 'Good' },
        { label: 'Excellent', value: 'Excellent' }
    ];

    connectedCallback() {
        console.log('Record ID:', this.recordId);
        // Fetch related contact if on an Account record
        if (this.recordId) {
            getContact({ accountId: this.recordId })
                .then(contact => {
                    if (contact) {
                        this.contactId = contact.Id; // Store the contact ID to use in the feedback
                        console.log('Contact ID:', this.contactId);
                    } else {
                        console.log('No contact found for this account.');
                    }
                })
                .catch(error => {
                    console.error('Error fetching contact:', error);
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
        if (!this.rating) {
            this.showToast('Error', 'Please complete Rating Field for Submission', 'error');
            return;
        }

        const feedbackData = {
            Rating__c: this.rating,
            Comments__c: this.comments,
            Account__c: this.recordId,
            Contact__c: this.contactId
        };

        saveFeedback({ feedback: feedbackData })
            .then(() => {
                this.showToast('Success', 'Feedback submitted successfully', 'success');
                this.formSubmitted = true;
                this.closeQuickAction();
            })
            .catch(error => {
                this.showToast('Error', 'Error submitting feedback', 'error');
                console.error(error);
            });
    }

     closeQuickAction() {
        
        const closeAction = new CustomEvent('close');
        this.dispatchEvent(closeAction);

        
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'view',
            },
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