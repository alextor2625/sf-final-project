public with sharing class FeedbackEmailScheduler {
    public void execute(SchedulableContext sc){
        FeedbackEmailBatch batch = new FeedbackEmailBatch();
        Database.executeBatch(batch);
    }
}