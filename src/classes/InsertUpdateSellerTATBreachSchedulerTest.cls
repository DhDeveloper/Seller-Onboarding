/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class InsertUpdateSellerTATBreachSchedulerTest {

   @isTest(SeeAllData=false)
    static void schedulerTest() {
        // TO DO: implement unit test
        String sch = '0 0 10 ? * MON-FRI'; 
        Test.startTest();
        
        InsertUpdateSellerTATBreachScheduler sbt = new InsertUpdateSellerTATBreachScheduler(); 
        system.schedule('Test Schedule', sch, sbt);
      
        Test.stopTest(); 
    }
}