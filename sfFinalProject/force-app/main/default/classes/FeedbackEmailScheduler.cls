public with sharing class FeedbackEmailScheduler implements Schedulable {
    public void execute(SchedulableContext sc){
        FeedbackEmailBatch batch = new FeedbackEmailBatch();
        Database.executeBatch(batch);
    }
}