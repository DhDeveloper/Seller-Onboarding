/**
  * This Apex Trigger executes after inserting and after updating Opportunity records
  * The following actions occur
  * 1) On Opportunity after insert, 
  *		Insert set of records into Seller_TAT_Breach Object based on TAT_Profile[as per now 15/25 Days]
  * 2) On Opportunity after update,
  *		a] Updates Seller_Id on all Opportunity related Seller_TAT_Breach Object records
  *		b] Updates Actual_Closure_Date on Opportunity Stage related Seller_TAT_Breach Object record
  *		c] Updates Next_Breach_Date,Estimated_Closure_Date on all Opportunity related Seller_TAT_Breach Object records 
  *		   if Actual_Closure_Date differs from Ideal_Closure_Date
**/
trigger OpportunityAfterTrigger on Opportunity (after insert, after update) {
    List<Opportunity> insertOppList = new List<Opportunity>();
    List<Opportunity> insertTrainingList = new List<Opportunity>();
    List<Opportunity> updateTrainingList = new List<Opportunity>();
    List<Seller_TAT_Breach__c> sellerTATList = new List<Seller_TAT_Breach__c>();
    List<TAT_Stage_Profile__c> TATStageProfileList = [SELECT Id,TAT_Profile_Spec__c,TAT_Profile_ID__r.TAT_Profile__c,
                                                             TAT_Stage_ID__r.Name,TAT_Stage_ID__r.TAT_Stage__c,
                                                             TAT_Profile_ID__r.Name
                                                      FROM TAT_Stage_Profile__c];
                                                      //WHERE TAT_Profile_ID__r.TAT_Profile__c ='15 Days'];
    List<Holiday> holidaysList = [Select h.ActivityDate From Holiday h];
    Map<Id, Opportunity> oldMap = Trigger.oldMap;
    List<Opportunity> updateSeller = new List<Opportunity>();
    List<Integer> bdActionList = new List<Integer>();
    
    /*	Insert set of records into Seller_TAT_Breach Object 
		based on TAT_Profile[as per now 15/25 Days]
	*/
    if(Trigger.isInsert){
        for(Opportunity opp: Trigger.new){
            Date actualStartDate = date.parse('27/12/2013');//(opp.CreatedDate).date();//
            Date closureDate = actualStartDate - 1;
            Date nextBreachDate;
            
            for(TAT_Stage_Profile__c tsp: TATStageProfileList){
            	if(opp.TAT_Profile__c != null && tsp.TAT_Profile_ID__c == opp.TAT_Profile__c ){
	                closureDate = UtilityClass.addDaysExcludingSundaysHolidays(closureDate,
	                                                                        Integer.valueOf(tsp.TAT_Profile_Spec__c),
	                                                                        holidaysList);
	                nextBreachDate = UtilityClass.addDaysExcludingSundaysHolidays(closureDate,1,holidaysList);
	                Seller_TAT_Breach__c sellerTAT = new Seller_TAT_Breach__c();
	                sellerTAT.TAT_Stage_Profile_ID__c = tsp.Id;
	                sellerTAT.Opportunity__c = opp.Id;
	                sellerTAT.Ideal_Closure_Date__c = closureDate;
	                sellerTAT.Next_Breach_Date__c = nextBreachDate;
	                sellerTAT.Estimated_Closure_Date__c = closureDate;
	                sellerTATList.add(sellerTAT);
            	}
            }
        }
        insert sellerTATList;
    }
    
    if(Trigger.isUpdate ){
        List<Opportunity> updateOppList = new List<Opportunity>();
        List<Opportunity> updateOppList2 = new List<Opportunity>();
        
        for(Opportunity opp: Trigger.new){
            Opportunity oldOpp = oldMap.get(opp.Id);
            
            /* Collecting Seller Ids' updated opportunity records to update them on 
               related Seller_TAT_Breach__c Object records
            */
            if(oldOpp.StageName != 'Candidate For Onboarding' ){ 
                if((oldOpp.Seller_Id__c == null && opp.Seller_Id__c != null) ||
                   (oldOpp.Seller_Id__c != null && opp.Seller_Id__c != oldOpp.Seller_Id__c )){
                    updateOppList.add(opp);
                    System.debug('update List Size: '+updateOppList.size());
                }
            }
            
            /* 	Collecting all Stage changed Opportunity records to update
            	related Seller_TAT_Breach__c Object records with Actual closure Date and further
            	changes of Next Breach Date, Estimated Closure Date and Time taken per Stage and 
            	TAT Breach calculation 
            */ 
            if(oldOpp.StageName != opp.StageName){
                updateSeller.add(opp);
            }
            
            /* Collecting all Opportunity records to insert training schedules in calendar
            */
            if(	opp.Training1__c == Constants.TRAINING_SCHEDULED || 
            	opp.Training2_Policy_Payments__c == Constants.TRAINING_SCHEDULED ||
            	opp.Training3_OM_Returns_Disputes__c == Constants.TRAINING_SCHEDULED){
            	insertTrainingList.add(opp);	
            }
            
            /* Collecting all Opportunity records to update training schedules in calendar
            */
            if( (opp.Training1__c == Constants.TRAINING_RESCHEDULE || 
            	opp.Training2_Policy_Payments__c == Constants.TRAINING_RESCHEDULE ||
            	opp.Training3_OM_Returns_Disputes__c == Constants.TRAINING_RESCHEDULE) &&
            	(oldOpp.Training_End_Date_Time__c != opp.Training_End_Date_Time__c)){
            	updateTrainingList.add(opp);
            }
            
            /* Following conditions to check Delay Reasons changes, BD Actions [Drop, Continue] and Training Reschedules
               and collects the opportunity records to insert record into Seller_TAT_Swimline__c Object
               and update Next Breach Dates and Estimated Closure Dates of Seller_TAT_Breach__c Object
            */
            if(	(	oldOpp.Delay_Reasons__c != opp.Delay_Reasons__c
            		) ||
            	(	oldOpp.Delay_Reasons__c != '' && opp.Attempts_Or_Delay_Days__c != oldOpp.Attempts_Or_Delay_Days__c
            		) ||
            	(	oldOpp.BD_Action__c != opp.BD_Action__c && 
            		(opp.BD_Action__c == Constants.BD_ACTION_DROP || opp.BD_Action__c == Constants.BD_ACTION_PAUSE)
            		) || 
            	(	opp.BD_Action__c == Constants.BD_ACTION_PAUSE && oldOpp.Revisit_Date__c != opp.Revisit_Date__c
            		)||
            	(	oldOpp.Training1__c != opp.Training1__c && opp.Training1__c == Constants.TRAINING_RESCHEDULE
            		) ||
            	(	oldOpp.Training2_Policy_Payments__c != opp.Training2_Policy_Payments__c && 
            		opp.Training2_Policy_Payments__c == Constants.TRAINING_RESCHEDULE
            		) ||
            	(	oldOpp.Training3_OM_Returns_Disputes__c != opp.Training3_OM_Returns_Disputes__c && 
            		opp.Training3_OM_Returns_Disputes__c == Constants.TRAINING_RESCHEDULE
            		) ||
            	(	(oldOpp.Training_End_Date_Time__c != opp.Training_End_Date_Time__c) && 
            		(	oldOpp.Training1__c == Constants.TRAINING_RESCHEDULE ||oldOpp.Training2_Policy_Payments__c == Constants.TRAINING_RESCHEDULE || 
            			oldOpp.Training3_OM_Returns_Disputes__c == Constants.TRAINING_RESCHEDULE
            		)
            	)
               ){
            	
            	// Following conditions check changes occured on Opportunity and 
            	// assign Constant values like [1-In Progress, 2-Dropped, 3-Paused, 4-Training T1, 5-Training T2, 6-Training T3]
            	if(	oldOpp.Delay_Reasons__c != opp.Delay_Reasons__c || 
            		(oldOpp.Delay_Reasons__c != '' && opp.Attempts_Or_Delay_Days__c != oldOpp.Attempts_Or_Delay_Days__c)){
            		bdActionList.add(Constants.TAT_SWIMLINE_IN_PROGRESS);
            	}
            	if(oldOpp.BD_Action__c != opp.BD_Action__c){
            		if(opp.BD_Action__c == Constants.BD_ACTION_DROP){
	            		bdActionList.add(Constants.TAT_SWIMLINE_DROPPED);
	            	}else if(opp.BD_Action__c == Constants.BD_ACTION_PAUSE){
	            		bdActionList.add(Constants.TAT_SWIMLINE_PAUSE);
	            	}	
            	}else if(opp.BD_Action__c == Constants.BD_ACTION_PAUSE &&  oldOpp.Revisit_Date__c != opp.Revisit_Date__c){
            		bdActionList.add(Constants.TAT_SWIMLINE_PAUSE);
            	}else if((oldOpp.Training1__c != opp.Training1__c && opp.Training1__c == Constants.TRAINING_RESCHEDULE) ||
            			 (oldOpp.Training1__c == Constants.TRAINING_RESCHEDULE && oldOpp.Training_End_Date_Time__c != opp.Training_End_Date_Time__c)){
            		bdActionList.add(Constants.TAT_SWIMLINE_TRAINING_T1);
            	}else if((oldOpp.Training2_Policy_Payments__c != opp.Training2_Policy_Payments__c && opp.Training2_Policy_Payments__c == Constants.TRAINING_RESCHEDULE) ||
            			 (oldOpp.Training2_Policy_Payments__c == Constants.TRAINING_RESCHEDULE && oldOpp.Training_End_Date_Time__c != opp.Training_End_Date_Time__c)){
            		bdActionList.add(Constants.TAT_SWIMLINE_TRAINING_T2);
            	}else if((oldOpp.Training3_OM_Returns_Disputes__c != opp.Training3_OM_Returns_Disputes__c && opp.Training3_OM_Returns_Disputes__c == Constants.TRAINING_RESCHEDULE) ||
            			 (oldOpp.Training3_OM_Returns_Disputes__c == Constants.TRAINING_RESCHEDULE && oldOpp.Training_End_Date_Time__c != opp.Training_End_Date_Time__c)){
            		bdActionList.add(Constants.TAT_SWIMLINE_TRAINING_T3);
            	}
            	
            	updateOppList2.add(opp);
            }
        }
        
        /* Updating Seller_TAT_Breach Object records with collected Seller_Id
        */
        if(updateOppList.size() > 0 ){
            List<Seller_TAT_Breach__c> updateSellerTATList =
                Database.query('SELECT Id FROM Seller_TAT_Breach__c WHERE Opportunity__c in :updateOppList');
            
            System.debug('Seller TAT: '+updateSellerTATList.size());
            
            for(Opportunity opp: updateOppList){
                for(Seller_TAT_Breach__c stb: updateSellerTATList){
                    stb.Seller_ID__c = opp.Seller_ID__c;
                }
            }
            update updateSellerTATList;
        }
        
        /*	Updating Actual_Closure_Date for Seller_TAT_Breach on Opportunity Stage Change and
        	Updates Next_Breach_Date,Estimated_Closure_Date on all Opportunity related 
			Seller_TAT_Breach Object records if Actual_Closure_Date differs from Ideal_Closure_Date
        */
        if(updateSeller.size() > 0){
            List<Seller_TAT_Breach__c> updateSellerList = [ SELECT 	Id,Opportunity__c,Ideal_Closure_Date__c,
                                                       				Actual_Closure_Date__c,Next_Breach_Date__c,
                                                       				Estimated_Closure_Date__c,TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c,
                                                            		TAT_Stage_Profile_ID__r.TAT_Stage_ID__r.TAT_Stage__c
                                                            FROM 	Seller_TAT_Breach__c 
                                                            WHERE 	Opportunity__c in :updateSeller];
            
            for(Opportunity opp: Trigger.new){
                Opportunity oldOpp = oldMap.get(opp.Id);
        		for(Integer i=0; i<updateSellerList.size();i++){
	                Date nextBreachDateTemp = null;  
					
					// Updates Actual Closure Date based on Stage Change of Opportunity record                	  
                    if(opp.Id == updateSellerList.get(i).Opportunity__c && 
                       oldOpp.StageName ==  updateSellerList.get(i).TAT_Stage_Profile_ID__r.TAT_Stage_ID__r.TAT_Stage__c){
                       updateSellerList.get(i).Actual_Closure_Date__c = (opp.LastModifiedDate).date();
                    }
                    
                    // Updates Next_Breach_Date,Estimated_Closure_Date on all Opportunity related 
					// Seller_TAT_Breach Object records if Actual_Closure_Date differs from Ideal_Closure_Date 
                    if(i!=0 && updateSellerList.get(i-1).Actual_Closure_Date__c != null){
			        	if(updateSellerList.get(i-1).Actual_Closure_Date__c != updateSellerList.get(i-1).Ideal_Closure_Date__c){
			                nextBreachDateTemp = UtilityClass.addDaysExcludingSundaysHolidays(updateSellerList.get(i-1).Actual_Closure_Date__c ,
			                                                                                  Integer.valueOf(updateSellerList.get(i).TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c),
			                                                                                  holidaysList);
			        	}
                    } 
                    updateSellerList = OpportunityHelperClass.recalculateNextBreachAndEstimatedClosureDates(i, nextBreachDateTemp, opp, updateSellerList, holidaysList);
                }
            }
            update updateSellerList;
        }
        
        /* Inserting training schedules in calendar for respective Opportunity records
        */
        if(insertTrainingList.size() > 0){
        	List<Event> insertEventList = new List<Event>();
        	
        	for(Opportunity opp : insertTrainingList){
        		if(	opp.Training1__c == Constants.TRAINING_SCHEDULED || 
        			opp.Training2_Policy_Payments__c == Constants.TRAINING_SCHEDULED ||
        			opp.Training3_OM_Returns_Disputes__c == Constants.TRAINING_SCHEDULED ){
        			Event event = new Event();
        			event.WhatId = opp.Id;
        			event.StartDateTime = opp.Training_Start_Date_Time__c;
        			event.EndDateTime = opp.Training_End_Date_Time__c;
        			
        			if(opp.Training1__c == Constants.TRAINING_SCHEDULED){
        				event.Subject = Constants.TRAINING_T1;	
        			}else if(opp.Training2_Policy_Payments__c == Constants.TRAINING_SCHEDULED){
        				event.Subject = Constants.TRAINING_T2;	
        			}else if(opp.Training3_OM_Returns_Disputes__c == Constants.TRAINING_SCHEDULED){
        				event.Subject = Constants.TRAINING_T3;	
        			}
        			insertEventList.add(event);
        		}
        	}
        	
        	if(insertEventList.size() > 0){
        		insert insertEventList;
        	}
        }
        
        /* Updating training schedules in calendar for respective Opportunity records
        */
        if(updateTrainingList.size() > 0){
        	List<Event> updateEventList = [	SELECT 	Id, StartDateTime, EndDateTime, Subject 
        									FROM 	Event 
        									WHERE 	WhatId IN :updateTrainingList ];
        	
        	for(Opportunity opp: updateTrainingList){
	        	for(Event event : updateEventList){
	        		if(opp.Training1__c == Constants.TRAINING_RESCHEDULE){
	        			event.StartDateTime = opp.Training_Start_Date_Time__c;
	        			event.EndDateTime = opp.Training_End_Date_Time__c;	        			
	        		}else if(opp.Training2_Policy_Payments__c == Constants.TRAINING_RESCHEDULE){
	        			event.StartDateTime = opp.Training_Start_Date_Time__c;
	        			event.EndDateTime = opp.Training_End_Date_Time__c;
	        		}else if(opp.Training3_OM_Returns_Disputes__c == Constants.TRAINING_RESCHEDULE){
	        			event.StartDateTime = opp.Training_Start_Date_Time__c;
	        			event.EndDateTime = opp.Training_End_Date_Time__c;
	        		}
	        	}
        	}
        	update updateEventList;
        }
        
        
        /* Code for inserting record in Seller_TAT_Swimline__c Object
        */
        if(updateOppList2.size() > 0){
        	
        	List<Seller_TAT_Breach__c> sellerTATBreach = [SELECT 	Id,Opportunity__c,Ideal_Closure_Date__c,
                                                       				Actual_Closure_Date__c,Next_Breach_Date__c,Estimated_Closure_Date__c,
                                                       				TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c,
                                                            		TAT_Stage_Profile_ID__r.TAT_Stage_ID__r.TAT_Stage__c
                                                            FROM 	Seller_TAT_Breach__c 
                                                            WHERE 	Opportunity__c in :updateOppList2];
            
            List<TAT_Swimline__c> tatSwimlineList = [SELECT Id,TAT_Stage_Swimline__c  FROM 	TAT_Swimline__c];                                                
            List<Seller_TAT_Swimline__c> sellerTATSwimlineList = new List<Seller_TAT_Swimline__c>();                                                            
        	Integer bdAction = 0;
        	
        	for(Opportunity opp: updateOppList2){
        		// Determine constant for BD Action/ Training Reschedule/ Delay 
        		Integer bdActionItem = bdActionList.get(bdAction);
                for(Integer i=0; i<sellerTATBreach.size();i++){
                	if(opp.Id == sellerTATBreach.get(i).Opportunity__c && 
	                   opp.StageName ==  sellerTATBreach.get(i).TAT_Stage_Profile_ID__r.TAT_Stage_ID__r.TAT_Stage__c){
	                   
	                	// Seller_TAT_Swimline__c new Object 
	                	Seller_TAT_Swimline__c sellerTATSwimline = new Seller_TAT_Swimline__c();	
		        		
		        		sellerTATSwimline.Seller_TAT_Breach_ID__c = sellerTATBreach.get(i).Id;
		        		sellerTATSwimline.TAT_Swimline_ID__c = OpportunityHelperClass.returnTATSwimlineID(bdActionItem, tatSwimlineList);
						
						if(bdActionItem == Constants.TAT_SWIMLINE_IN_PROGRESS){
							sellerTATSwimline.Swimline_Start_Date__c = (opp.LastModifiedDate).Date();
							sellerTATSwimline.Comments__c = opp.Delay_Reasons__c+' - '+opp.Delay_Description__c;
							if(opp.Delay_Reasons__c == Constants.DELAY_REASON_SELLER_NOT_REACHABLE){
								sellerTATSwimline.Swimline_End_Date__c = (opp.LastModifiedDate).Date();
							}else{
								sellerTATSwimline.Swimline_End_Date__c = UtilityClass.addDaysExcludingSundaysHolidays((opp.LastModifiedDate).Date(),
                                                                                                               Integer.valueOf(opp.Attempts_Or_Delay_Days__c),
                                                                                                               holidaysList);
							}
						}else if(bdActionItem == Constants.TAT_SWIMLINE_DROPPED){
							sellerTATSwimline.Swimline_Start_Date__c = (opp.LastModifiedDate).Date();	
							sellerTATSwimline.Comments__c = opp.BD_Comments__c;
						}else if(bdActionItem == Constants.TAT_SWIMLINE_PAUSE){
							sellerTATSwimline.Swimline_Start_Date__c = (opp.LastModifiedDate).Date();
							sellerTATSwimline.Swimline_End_Date__c = opp.Revisit_Date__c ;
							sellerTATSwimline.Comments__c = opp.BD_Comments__c;
						}else if(	bdActionItem == Constants.TAT_SWIMLINE_TRAINING_T1 || 
									bdActionItem == Constants.TAT_SWIMLINE_TRAINING_T2 || 
									bdActionItem == Constants.TAT_SWIMLINE_TRAINING_T3){
							
							sellerTATSwimline.Swimline_Start_Date__c = (opp.Training_Start_Date_Time__c).Date();
							sellerTATSwimline.Swimline_End_Date__c = (opp.Training_End_Date_Time__c).Date();
							
							if(bdActionItem == Constants.TAT_SWIMLINE_TRAINING_T1){
								sellerTATSwimline.Comments__c = opp.Training1__c;
							}else if(bdActionItem == Constants.TAT_SWIMLINE_TRAINING_T2){
								sellerTATSwimline.Comments__c = opp.Training2_Policy_Payments__c;
							}else if(bdActionItem == Constants.TAT_SWIMLINE_TRAINING_T3){
								sellerTATSwimline.Comments__c = opp.Training3_OM_Returns_Disputes__c;
							}
						}
						sellerTATSwimlineList.add(sellerTATSwimline);
	                }
 	       		}
        		bdAction++;
    		}
    		insert  sellerTATSwimlineList;//Seller_TAT_Swimline__c insertion
    		
    		/* Updates Next Breach Date and Estimated Closure Date for 
    		   remaining set of records affected by Seller_TAT_Swimline__c insertion
    		*/
    		for(Seller_TAT_Swimline__c sts: sellerTATSwimlineList){
    			for(Opportunity opp: updateOppList2){
    				// flag represents the starting record to update Next Breach Date and Estimated Closure Date
    				boolean flag = false;
    				Integer actualDays = 0;
        		    for(Integer i=0; i<sellerTATBreach.size();i++){
	                	
	                	if(flag == true){
	                		sellerTATBreach = OpportunityHelperClass.recalcNextBreachAndEstimatedClosureDates(	i, actualDays, null, opp, 
	                																							sellerTATBreach, holidaysList);
	                	}
	                	if(opp.Id == sellerTATBreach.get(i).Opportunity__c &&  sellerTATBreach.get(i).Id == sts.Seller_TAT_Breach_ID__c){
	                		if(	sts.Swimline_End_Date__c != null && 
								sts.Swimline_End_Date__c >= sellerTATBreach.get(i).Next_Breach_Date__c ){
								if(i != 0){
			                		actualDays = 	Integer.valueOf(sellerTATBreach.get(i).TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c) -
			                						UtilityClass.daysBetweenExcludingSundaysHolidays(	sellerTATBreach.get(i-1).Actual_Closure_Date__c, 
			                																			sts.Swimline_Start_Date__c, 
			                																			holidaysList);
			                	}else{
			                		actualDays = 	Integer.valueOf(sellerTATBreach.get(i).TAT_Stage_Profile_ID__r.TAT_Profile_Spec__c) -
			                						UtilityClass.daysBetweenExcludingSundaysHolidays(	(opp.CreatedDate).Date(), 
			                																			sts.Swimline_Start_Date__c, 
			                																			holidaysList);
			                	}
								sellerTATBreach = OpportunityHelperClass.recalcNextBreachAndEstimatedClosureDates(	i, actualDays,
	                																								sts.Swimline_End_Date__c,
	                																								opp, sellerTATBreach, holidaysList);
								flag = true;	                																							
							}
	                	}	
	                }
    			}
    		}
    		update sellerTATBreach;
		}// updateOppList2 end
    }// Trigger.isUpdate end
}// Trigger end