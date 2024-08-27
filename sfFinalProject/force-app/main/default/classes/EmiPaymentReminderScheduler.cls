public with sharing class EmiPaymentReminderScheduler implements Schedulable {
    public void execute(SchedulableContext sc){
        EmiPaymentReminderEmailBatch batch = new EmiPaymentReminderEmailBatch();
        Database.executeBatch(batch);
    }
    
}