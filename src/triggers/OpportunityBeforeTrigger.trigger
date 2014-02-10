/**
  * This trigger executes before inserting and before updating records of Opportunity.
  * And do the following actions
  * 1) Populate Delay Reasons wise delay days count in Delay Summary section.
  * 2) Checks Opportunity records in 'Invited' stage and ready to send them 
  *    to SMS system group mail [sms-dev-ops@flipkart.com]
**/
trigger OpportunityBeforeTrigger on Opportunity (before insert, before update) {

    Integer     oldSellerNotReachableCount  = 0;
    Integer     oldSellerNeedMoreTimeCount  = 0;
    Integer     oldOthersCount              = 0;
    Integer     count                       = 0;
    Integer     oppDelayDays;
    String      s1                          = '<html><body><table border="1"><th>Name</th><th>Seller Registration Email</th><th>Owner Email</th>';
    String      s2                          = '</table></body></html>';
    String      data						= '';
    List<Holiday> holidaysList = [Select h.ActivityDate From Holiday h];
    
    /* On update of Opportunity record, Delay Reasons wise days count
       captured to populate with new values
    */
    if(Trigger.isUpdate){
        for(Opportunity oldOpp: Trigger.old){
            oldSellerNotReachableCount = (oldOpp.Seller_Not_Reachable__c != null) ?
                                            Integer.valueOf(oldOpp.Seller_Not_Reachable__c) : 0;
            oldSellerNeedMoreTimeCount = (oldOpp.Seller_Need_More_Time__c != null) ?
                                            Integer.valueOf(oldOpp.Seller_Need_More_Time__c):0;
            oldOthersCount             = (oldOpp.Others__c != null) ?
                                            Integer.valueOf(oldOpp.Others__c):0;
        }
    }
    
    if(Trigger.isInsert || Trigger.isUpdate){
        
            
        List<TAT_Profile__c> tatProfileList = [SELECT Id, TAT_Profile__c FROM TAT_Profile__c];
        
        ID TAT_Profile_13_ID = null;
        ID TAT_Profile_18_ID = null;
        
        for(TAT_Profile__c tat:tatProfileList){
            if((tat.TAT_Profile__c).contains(Constants.TAT_13)){
                TAT_Profile_13_ID = tat.Id;
            }else if((tat.TAT_Profile__c).contains(Constants.TAT_18)){
                TAT_Profile_18_ID = tat.Id;
            }
        }
        
        for(Opportunity opp: Trigger.new){
            if(opp.Expected_TAT__c != null){
                if(opp.Expected_TAT__c == Constants.TAT_13 || opp.Expected_TAT__c == Constants.TAT_15){
                    opp.TAT_Profile__c = TAT_Profile_13_ID;
                }else if(opp.Expected_TAT__c == Constants.TAT_18 || opp.Expected_TAT__c == Constants.TAT_25){
                    opp.TAT_Profile__c = TAT_Profile_18_ID;
                }
            }
        }
        
        if(Trigger.isUpdate){
            Map<Id, Opportunity> oldMap = Trigger.oldMap;
            for(Opportunity opp: Trigger.new){
                Opportunity oldOpp = oldMap.get(opp.Id);
                
                //Existing Opportunities data capture======
                if(oldOpp.StageName == Constants.OPP_STAGE_CANDIDATE && opp.StageName == Constants.OPP_STAGE_READY_TO_ONBOARD ){
                	opp.Ready_to_Onboard_Date__c = (opp.LastModifiedDate).date();
                }else if(oldOpp.StageName == Constants.OPP_STAGE_READY_TO_ONBOARD && opp.StageName == Constants.OPP_STAGE_READY_TO_INVITE ){
                	opp.Ready_to_Invite_Date__c = (opp.LastModifiedDate).date();
                }else if(oldOpp.StageName == Constants.OPP_STAGE_READY_TO_INVITE && opp.StageName == Constants.OPP_STAGE_INVITED ){
                	opp.Invited_Start_Date__c = (opp.LastModifiedDate).date();
                }else if(oldOpp.StageName == Constants.OPP_STAGE_INVITED && opp.StageName == Constants.OPP_STAGE_MIN_SKU_CREATION ){
                	opp.Pending_min_SKU_Date__c = (opp.LastModifiedDate).date();
                }else if(oldOpp.StageName == Constants.OPP_STAGE_MIN_SKU_CREATION && opp.StageName == Constants.OPP_STAGE_MIN_LISTINGS ){
                	opp.Pending_min_Listings_Date__c = (opp.LastModifiedDate).date();
                }else if(oldOpp.StageName == Constants.OPP_STAGE_MIN_LISTINGS && opp.StageName == Constants.OPP_STAGE_SELLER_APPROVAL ){
                	opp.Pending_Seller_Approval_Date__c = (opp.LastModifiedDate).date();
                }else if(oldOpp.StageName == Constants.OPP_STAGE_SELLER_APPROVAL && opp.StageName == Constants.OPP_STAGE_STOCK_UPDATE ){
                	opp.Pending_Stock_Update_Date__c = (opp.LastModifiedDate).date();
                }else if(oldOpp.StageName == Constants.OPP_STAGE_STOCK_UPDATE && opp.StageName == Constants.OPP_STAGE_GO_LIVE_CHECKLIST ){
                	opp.Go_Live_Checklist_Date__c = (opp.LastModifiedDate).date();
                }else if(oldOpp.StageName == Constants.OPP_STAGE_GO_LIVE_CHECKLIST && opp.StageName == Constants.OPP_STAGE_LIVE ){
                	opp.Live_Date__c = (opp.LastModifiedDate).date();
                }
                
               /* if(opp.Live_Date__c != null){
                	opp.Invited_to_Live_Time__c = UtilityClass.daysBetweenExcludingSundaysHolidays(	opp.Invited_Start_Date__c, 
                    																				opp.Live_Date__c, holidaysList);
                }*/
                //================================End
                /* Training T1 Validation rules. 
                */
                if( (opp.Training1__c == Constants.TRAINING_SCHEDULED) && 
                    (   (oldOpp.Training_Start_Date_Time__c != null && oldOpp.Training_Start_Date_Time__c != opp.Training_Start_Date_Time__c) || 
                        (oldOpp.Training_End_Date_Time__c != null && oldOpp.Training_End_Date_Time__c != opp.Training_End_Date_Time__c)
                        )){
                    opp.Training1__c.addError('Training1 (Listings) should be in Reschedule to Change Training Start Date/Time or Training End Date/Time');
                }
                
               /* if( opp.Training1__c == Constants.TRAINING_NOT_DONE ||
                    opp.Training1__c == Constants.TRAINING_SCHEDULED ||
                    opp.Training1__c == Constants.TRAINING_RESCHEDULE){
                    if(opp.Training1__c == Constants.TRAINING_NOT_DONE){
                        if(opp.Training_Start_Date_Time__c != null || opp.Training_End_Date_Time__c != null){
                            opp.Training_Start_Date_Time__c.addError('Without Scheduled/Reschedule, training timings should be empty');                     
                        }
                    }
                    
                    if( opp.Training1__c == Constants.TRAINING_SCHEDULED ||
                        opp.Training1__c == Constants.TRAINING_RESCHEDULE){
                        if(opp.Training_Start_Date_Time__c == null || opp.Training_End_Date_Time__c == null){
                                opp.Training_Start_Date_Time__c.addError('On Scheduled/Reschedule, Training Start Date/Time and Training End Date/Time cannot be empty');                       
                        }
                        if( (opp.Training1__c == Constants.TRAINING_SCHEDULED) && 
                            (   (oldOpp.Training_Start_Date_Time__c != null && oldOpp.Training_Start_Date_Time__c != opp.Training_Start_Date_Time__c) || 
                                (oldOpp.Training_End_Date_Time__c != null && oldOpp.Training_End_Date_Time__c != opp.Training_End_Date_Time__c)
                                )){
                            opp.Training1__c.addError('Training1 (Listings) should be in Reschedule to Change Training Start Date/Time or Training End Date/Time');
                        }
                    }
                }*/// End of Training1 -- Not Done/Scheduled/Reschedule
                
                //Training T2 & T3 Validation rules. 
                //if(opp.Training1__c == Constants.TRAINING_COMPLETED){
                if( (opp.Training2_Policy_Payments__c == Constants.TRAINING_SCHEDULED) && 
                    (   (oldOpp.Training2_Start_Date_Time__c != null && oldOpp.Training2_Start_Date_Time__c != opp.Training2_Start_Date_Time__c) || 
                        (oldOpp.Training2_End_Date_Time__c != null && oldOpp.Training2_End_Date_Time__c != opp.Training2_End_Date_Time__c)
                        )){
                    opp.Training2_Policy_Payments__c.addError('Training2 (Policy + Payments) should be in Reschedule to Change Training Start Date/Time or Training End Date/Time');
                }
                  /*  if(opp.Training2_Policy_Payments__c == null || opp.Training2_Policy_Payments__c == Constants.TRAINING_NOT_DONE){
                        if(opp.Training2_Start_Date_Time__c != null || opp.Training2_End_Date_Time__c != null){
                            opp.Training2_Start_Date_Time__c.addError('Without Scheduled/Reschedule, training timings should be empty');                        
                        }
                    }
                    
                    if( opp.Training2_Policy_Payments__c == Constants.TRAINING_SCHEDULED ||
                        opp.Training2_Policy_Payments__c == Constants.TRAINING_RESCHEDULE){
                        if(opp.Training2_Start_Date_Time__c == null || opp.Training2_End_Date_Time__c == null){
                                opp.Training2_Start_Date_Time__c.addError('On Scheduled/Reschedule, Training Start Date/Time and Training End Date/Time cannot be empty');                      
                        }
                        if( (opp.Training2_Policy_Payments__c == Constants.TRAINING_SCHEDULED) && 
                            (   (oldOpp.Training2_Start_Date_Time__c != null && oldOpp.Training2_Start_Date_Time__c != opp.Training2_Start_Date_Time__c) || 
                                (oldOpp.Training2_End_Date_Time__c != null && oldOpp.Training2_End_Date_Time__c != opp.Training2_End_Date_Time__c)
                                )){
                            opp.Training2_Policy_Payments__c.addError('Training2 (Policy + Payments) should be in Reschedule to Change Training Start Date/Time or Training End Date/Time');
                        }
                    }*/
                    
                    // T3 Validation Rules
                 /*   if(opp.Training3_OM_Returns_Disputes__c == null || 
                       opp.Training3_OM_Returns_Disputes__c == Constants.TRAINING_NOT_DONE){
                        if(opp.Training3_Start_Date_Time__c != null || opp.Training3_End_Date_Time__c != null){
                            opp.Training3_Start_Date_Time__c.addError('Without Scheduled/Reschedule, training timings should be empty');                        
                        }
                    }
                    if( opp.Training3_OM_Returns_Disputes__c == Constants.TRAINING_SCHEDULED ||
                        opp.Training3_OM_Returns_Disputes__c == Constants.TRAINING_RESCHEDULE){
                        if(opp.Training3_Start_Date_Time__c == null || opp.Training3_End_Date_Time__c == null){
                                opp.Training3_Start_Date_Time__c.addError('On Scheduled/Reschedule, Training Start Date/Time and Training End Date/Time cannot be empty');                      
                        }
                        if( (opp.Training3_OM_Returns_Disputes__c == Constants.TRAINING_SCHEDULED) && 
                            (   (oldOpp.Training3_Start_Date_Time__c != null && oldOpp.Training3_Start_Date_Time__c != opp.Training2_Start_Date_Time__c) || 
                                (oldOpp.Training3_End_Date_Time__c != null && oldOpp.Training3_End_Date_Time__c != opp.Training2_End_Date_Time__c)
                                )){
                            opp.Training3_OM_Returns_Disputes__c.addError('Training3 (OM Returns Disputes) should be in Reschedule to Change Training Start Date/Time or Training End Date/Time');
                        }
                     }*/
                //}// End of Training T2 & T3 Validation rules. 
            }
        }
        
        List<Opportunity> ownerInfoList = [select Id,Owner.email from opportunity where id=:Trigger.new];
        
        /* On insert or update of Opportunity record, Delay Reasons wise days count
           populated on Delay Summary Section of Opportunity
        */
        for(Opportunity opp: Trigger.new){
            if(opp.Delay_Reasons__c != null && opp.Attempts_Or_Delay_Days__c != null){
                oppDelayDays = (opp.Attempts_Or_Delay_Days__c != null && opp.Attempts_Or_Delay_Days__c != '')?
                                        Integer.valueOf(opp.Attempts_Or_Delay_Days__c) : 0;

                if(opp.Delay_Reasons__c == Constants.DELAY_REASON_SELLER_NOT_REACHABLE){
                    opp.Seller_Not_Reachable__c = oldSellerNotReachableCount + oppDelayDays;
                }
                else if(opp.Delay_Reasons__c == Constants.DELAY_REASON_SELLER_NEED_MORE_TIME){
                    opp.Seller_Need_More_Time__c = oldSellerNeedMoreTimeCount + oppDelayDays;
                }
                else if(opp.Delay_Reasons__c == Constants.DELAY_REASON_OTHER){
                    opp.Others__c = oldOthersCount + oppDelayDays;
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
            	data += '<tr><td>'+opp.Name+'</td>';
            	
            	if(opp.Seller_Registration_Email__c != null){
            		data += '<td>'+opp.Seller_Registration_Email__c+'</td>';
            	}else{
            		data += '<td></td>';
            	}
            	
            	for(Opportunity ownerInfo : ownerInfoList){
            		if(ownerInfo.Id == opp.Id){
            			if(ownerInfo.Owner.email != null){
		            		data += '<td>'+ownerInfo.Owner.email+'</td>';
		            	}else{
		            		data += '<td></td>';
		            	}
            		}
            	}
            	
            	data += '</tr>';
                opp.Is_Invited__c = 2;
                count++;
            }
        }
        
        if(count > 0){
            //Commit current transaction, reserver email capacity
            Messaging.reserveSingleEmailCapacity(1);
            //Create an email message object
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
            List<Messaging.SendEmailResult> results = new list<Messaging.SendEmailResult>();
            //hold email address
            String[] toAddresses = new String[] {Constants.SMS_GROUP_EMAIL_ID};//temp email address
        
            //Assign new address string
            mail.setToAddresses(toAddresses);
            //Return Address
            mail.setReplyTo(Constants.RETURN_EMAIL_ID);
            //sender name
            mail.setSenderDisplayName('Seller Onboarding System');
            //Subject Specification
            mail.setSubject('Seller Onboarding System: List of Invited people');
            //And... the content
            mail.setHtmlBody(s1+data+s2);
            results = Messaging.sendEmail(new Messaging.Email[] { mail });
        }
    }
}