global class SellerBatchTest implements Schedulable {
   global void execute(SchedulableContext sc) {
      SellerTATBreachBatchUpdateClass b = new SellerTATBreachBatchUpdateClass(); 
      database.executebatch(b);
   }
}