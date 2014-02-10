global class InsertUpdateSellerTATBreachScheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
      InsertUpdateSellerTATBreachBatchClass b = new InsertUpdateSellerTATBreachBatchClass(); 
      database.executebatch(b,50);
   }
}