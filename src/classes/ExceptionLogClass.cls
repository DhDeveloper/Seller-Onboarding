global class ExceptionLogClass {
	/**
	  * 
	**/
	@future
 	public static void createErrorRecord(	String objectName, String className, String methodName,
 											String errorMessage, String exceptionType, String stackTrace){
    	Exceptions__c errorRecord = new Exceptions__c();
     	
     	errorRecord.Object__c					= objectName;
     	errorRecord.Class_Or_Trigger_Name__c	= className;
     	errorRecord.Method_Or_Block_Name__c		= methodName;
     	errorRecord.Error_Message__c 			= errorMessage;
     	errorRecord.Exception_Type__c 			= exceptionType;
     	errorRecord.Stack_Trace__c 				= stackTrace;
     	
     	Database.insert(errorRecord,false);
 	}
}