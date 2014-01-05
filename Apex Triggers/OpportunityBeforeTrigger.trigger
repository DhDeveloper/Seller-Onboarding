/**
  * This trigger executes before inserting and before updating records of Opportunity.
  * And do the following actions
  * 1) Populate Delay Reasons wise delay days count in Delay Summary section.
  * 2) Checks Opportunity records in 'Invited' stage and ready to send them 
  *    to SMS system group mail [sms-dev-ops@flipkart.com]
**/
trigger OpportunityBeforeTrigger on Opportunity (before insert, before update) {

    Integer		oldSellerNotReachableCount 	= 0;
    Integer		oldSellerNeedMoreTimeCount 	= 0;
    Integer		oldOthersCount             	= 0;
    Integer		count                      	= 0;
    String		finalData                  	= '\tOpp Name \t Reg Email';
	String		s1							= '<html><body><table border="1"><th>Name</th><th>Seller Registration Email</tr>';
    String		s2 							= '</table></body></html>';
    String     	oppDelayDays;
    String 		data;
    
    /* On update of Opportunity record, Delay Reasons wise days count
       captured to populate with new values
    */
    if(Trigger.isUpdate){
        for(Opportunity oldOpp: Trigger.old){
            oldSellerNotReachableCount = Integer.valueOf(oldOpp.Seller_Not_Reachable__c);
            oldSellerNeedMoreTimeCount = Integer.valueOf(oldOpp.Seller_Need_More_Time__c);
            oldOthersCount             = Integer.valueOf(oldOpp.Others__c);
        }
    }
    
    /* On insert or update of Opportunity record, Delay Reasons wise days count
       populated on Delay Summary Section of Opportunity
    */
    if(Trigger.isInsert || Trigger.isUpdate){
    	
    	if(Trigger.isUpdate){
    		Map<Id, Opportunity> oldMap = Trigger.oldMap;
    		for(Opportunity opp: Trigger.new){
    			Opportunity oldOpp = oldMap.get(opp.Id);
    			if(	opp.Training1__c == Constants.TRAINING_NOT_DONE ||
    				opp.Training1__c == Constants.TRAINING_SCHEDULED ||
    				opp.Training1__c == Constants.TRAINING_RESCHEDULE){
    				if(opp.Training2_Policy_Payments__c != null || opp.Training3_OM_Returns_Disputes__c != null){
    					opp.Training1__c.addError(' without completing Training1 (Listings) cannot start Training2 (Policy + Payments) and Training3 (OM Returns Disputes)');
    				}
    				
    				if(opp.Training1__c == Constants.TRAINING_NOT_DONE){
    					if(opp.Training_Start_Date_Time__c != null || opp.Training_End_Date_Time__c != null){
		    				opp.Training1__c.addError('Without Scheduled/Reschedule, training timings should be empty');    					
	    				}
    				}
    				
    				if(	opp.Training1__c == Constants.TRAINING_SCHEDULED ||
    					opp.Training1__c == Constants.TRAINING_RESCHEDULE){
	    				if(opp.Training_Start_Date_Time__c == null || opp.Training_End_Date_Time__c == null){
		    					opp.Training_Start_Date_Time__c.addError('On Scheduled/Reschedule, Training Start Date/Time and Training End Date/Time cannot be empty');    					
	    				}
	    				if(	(opp.Training1__c == Constants.TRAINING_SCHEDULED) && 
	    					(	(oldOpp.Training_Start_Date_Time__c != null && oldOpp.Training_Start_Date_Time__c != opp.Training_Start_Date_Time__c) || 
	    						(oldOpp.Training_End_Date_Time__c != null && oldOpp.Training_End_Date_Time__c != opp.Training_End_Date_Time__c)
	    						)){
	    					opp.Training_Start_Date_Time__c.addError('Training1 (Listings) should be in Reschedule to Change Training Start Date/Time or Training End Date/Time');
	    				}
    				}
    			}// Training1 -- Not Done/Scheduled/Reschedule
    			
    			/*if(opp.Training1__c == Constants.TRAINING_COMPLETED){
    				if(	opp.Training2_Policy_Payments__c == Constants.TRAINING_NOT_DONE ||
	    				opp.Training2_Policy_Payments__c == Constants.TRAINING_SCHEDULED ||
	    				opp.Training2_Policy_Payments__c == Constants.TRAINING_RESCHEDULE){
	    				if(opp.Training3_OM_Returns_Disputes__c != null){
	    					opp.Training1__c.addError(' without completing Training2 (Policy + Payments) cannot start Training3 (OM Returns Disputes)');
	    				}
	    				
	    				if(opp.Training2_Policy_Payments__c == Constants.TRAINING_NOT_DONE){
	    					if(opp.Training_Start_Date_Time__c != null || opp.Training_End_Date_Time__c != null){
			    				opp.Training1__c.addError('Without Scheduled/Reschedule, training timings should be empty');    					
		    				}
	    				}
	    				
	    				if(	opp.Training1__c == Constants.TRAINING_SCHEDULED ||
	    					opp.Training1__c == Constants.TRAINING_RESCHEDULE){
		    				if(opp.Training_Start_Date_Time__c == null || opp.Training_End_Date_Time__c == null){
			    					opp.Training_Start_Date_Time__c.addError('On Scheduled/Reschedule, Training Start Date/Time and Training End Date/Time cannot be empty');    					
		    				}
		    				if(	(opp.Training1__c == Constants.TRAINING_SCHEDULED) && 
		    					(	(oldOpp.Training_Start_Date_Time__c != null && oldOpp.Training_Start_Date_Time__c != opp.Training_Start_Date_Time__c) || 
		    						(oldOpp.Training_End_Date_Time__c != null && oldOpp.Training_End_Date_Time__c != opp.Training_End_Date_Time__c)
		    						)){
		    					opp.Training_Start_Date_Time__c.addError('Training1 (Listings) should be in Reschedule to Change Training Start Date/Time or Training End Date/Time');
		    				}
	    				}
	    			}// Training2 -- Not Done/Scheduled/Reschedule
    			}*/
    			
    		}
    	}

        for(Opportunity opp: Trigger.new){
            if(opp.Delay_Reasons__c != null && opp.Attempts_Or_Delay_Days__c != null){
                oppDelayDays = opp.Attempts_Or_Delay_Days__c;

                if(opp.Delay_Reasons__c == Constants.DELAY_REASON_SELLER_NOT_REACHABLE){
                    opp.Seller_Not_Reachable__c = oldSellerNotReachableCount + Integer.valueOf(oppDelayDays);
                }
                else if(opp.Delay_Reasons__c == Constants.DELAY_REASON_SELLER_NEED_MORE_TIME){
                    opp.Seller_Need_More_Time__c = oldSellerNeedMoreTimeCount + Integer.valueOf(oppDelayDays);
                }
                else if(opp.Delay_Reasons__c == Constants.DELAY_REASON_OTHER){
                    opp.Others__c = oldOthersCount + Integer.valueOf(oppDelayDays);
                }
            }else{
                opp.Seller_Not_Reachable__c    = 0;
                opp.Seller_Need_More_Time__c   = 0;
                opp.Others__c                  = 0;
            }
            
            /* Apex Scheduler update 'Is Invited' field to 1
               at 10:00 and 16:00 on weekdays. Checking updated
               field and capture required information to send email         
            */
            if(opp.Is_Invited__c == 1){
                data = '<tr><td>'+opp.Name+'</td><td>'+opp.Seller_Registration_Email__c+'</td></tr>';
                finalData+='\n\t'+opp.Name+'\t'+opp.Seller_Registration_Email__c;
                opp.Is_Invited__c = 2;
                count++;
            }
            finalData+='\n';
        }
        
        if(count > 0){
            //Commit current transaction, reserver email capacity
            Messaging.reserveSingleEmailCapacity(1);
            //Create an email message object
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
            List<Messaging.SendEmailResult> results = new list<Messaging.SendEmailResult>();
            //hold email address
            String[] toAddresses = new String[] {'murali.dharnala@in.pwc.com'};//temp email address
        
            //Assign new address string
            mail.setToAddresses(toAddresses);
            //sender name
            mail.setSenderDisplayName('Seller Onboarding System');
            //Subject Specification
            mail.setSubject('Seller Onboarding System: List of Invited people');
            //And... the content
            //mail.setPlainTextBody('Invited List \n'+finalData);
            mail.setHtmlBody(s1+data+s2);
            results = Messaging.sendEmail(new Messaging.Email[] { mail });
        }
    }
}