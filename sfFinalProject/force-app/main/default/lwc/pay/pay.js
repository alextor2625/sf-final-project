import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateLoanClosure from '@salesforce/apex/PayController.updateLoanClosure';
import { NavigationMixin } from 'lightning/navigation';

export default class Pay extends NavigationMixin(LightningElement) {
    @api recordId;

    handleCancel() {
        console.log('Cancel button clicked, closing action window');

        // Close the action window using NavigationMixin
        this.closeQuickAction();
    }

    handleConfirm() {
        updateLoanClosure({ accountId: this.recordId })
            .then(() => {
                this.showToast('Success', 'Payment confirmed', 'success');
                this.closeQuickAction(); 
            })
            .catch(error => {
                console.log(error);
                this.showToast('Error', 'Failed to confirm payment: ' + error.body.message, 'error');
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