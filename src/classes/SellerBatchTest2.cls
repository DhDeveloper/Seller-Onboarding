public with sharing class SellerBatchTest2 {
	public void callMe(){
		SellerTATBreachBatchUpdateClass stbClass = new SellerTATBreachBatchUpdateClass();
        Database.executeBatch(stbClass,100);
	}
}