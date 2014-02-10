/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class SellerBatchUpdateControllerTest {

     static testMethod void myUnitTest() {
        SellerBatchUpdateController controller = new SellerBatchUpdateController();
        controller.updateBatch();
    }
}