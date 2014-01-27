/**
  * This Apex Class used in Serialize and Deserialize of Case Object 
  * from CaseAfterInsertTrigger to Future method call
**/
public with sharing class CaseHelperClass {
	 public Id caseId 				{get;set;}
	 public String issueType 		{get;set;}
	 public String typeName 		{get;set;}
	 public String status 			{get;set;}
	 public String priority 		{get;set;}
	 public String sellerRegEmail	{get;set;}
	 public String email 			{get;set;}
	 public String origin 			{get;set;}
	 public String subject 			{get;set;}
	 public String description 		{get;set;}
 
    public CaseHelperClass(	Id caseId, String issueType, String typeString, String status, String priority, 
    						String sellerRegEmail, String email, String origin, String subject, String description) {
        this.caseId 		= caseId;
        this.issueType 		= issueType;
        this.typeName 		= typeString;
        this.status 		= status;
        this.priority 		= priority;
        this.sellerRegEmail	= sellerRegEmail;
        this.email 			= email;
        this.origin 		= origin;
        this.subject 		= subject;
        this.description 	= description;
    }
	
}