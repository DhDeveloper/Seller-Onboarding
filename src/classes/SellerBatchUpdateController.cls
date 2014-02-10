public with sharing class SellerBatchUpdateController {
	public void updateBatch(){
		InsertUpdateSellerTATBreachBatchClass stbClass = new InsertUpdateSellerTATBreachBatchClass();
        Database.executeBatch(stbClass,50);
	}
}