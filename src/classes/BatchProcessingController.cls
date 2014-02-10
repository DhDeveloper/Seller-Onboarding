public with sharing class BatchProcessingController {
	public void updateBatch(){
    	BatchProcessingExistingTATDataClass stbClass = new BatchProcessingExistingTATDataClass();
        Database.executeBatch(stbClass,50);
  	}
}