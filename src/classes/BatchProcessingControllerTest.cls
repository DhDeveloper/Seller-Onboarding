/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class BatchProcessingControllerTest {

    static testMethod void myUnitTest() {
        BatchProcessingController bpc = new BatchProcessingController();
        bpc.updateBatch();
    }
}