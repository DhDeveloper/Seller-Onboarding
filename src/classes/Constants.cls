/**
  * This Apex Class contains all constants used across application
**/
public class Constants {
    public static final String DELAY_REASON_SELLER_NOT_REACHABLE    = 'Seller Not Reachable';
    public static final String DELAY_REASON_SELLER_NEED_MORE_TIME   = 'Seller Need More Time';
    public static final String DELAY_REASON_OTHER                   = 'Other';
    
    public static final String OPP_STAGE_CANDIDATE                  = 'Candidate';
    public static final String OPP_STAGE_READY_TO_ONBOARD           = 'Ready to Onboard';
    public static final String OPP_STAGE_READY_TO_INVITE            = 'Ready to Invite';
    public static final String OPP_STAGE_INVITED                    = 'Invited';
    public static final String OPP_STAGE_MIN_SKU_CREATION           = 'Pending min SKU creation';
    public static final String OPP_STAGE_MIN_LISTINGS               = 'Pending min Listings';
    public static final String OPP_STAGE_SELLER_APPROVAL            = 'Pending Seller Approval';
    public static final String OPP_STAGE_STOCK_UPDATE               = 'Pending Stock Update';
    public static final String OPP_STAGE_GO_LIVE_CHECKLIST          = 'Go Live Checklist';
    public static final String OPP_STAGE_LIVE                       = 'Live';
    
    public static final String TAT_13                               = '13';
    public static final String TAT_15                               = '15';
    public static final String TAT_18                               = '18';
    public static final String TAT_25                               = '25';
    
    
    public static final String SMS_GROUP_EMAIL_ID                   = 'prasanthn@flipkart.com,murali.dharnala@in.pwc.com';//'sms-dev-ops@flipkart.com';//
    
    public static final String BD_ACTION_DROP                       = 'Drop';
    public static final String BD_ACTION_PAUSE                      = 'Continue';
    
    public static final String TRAINING_T1                          = 'Training1 (Listings)';
    public static final String TRAINING_T2                          = 'Training2 (Policy + Payments)';
    public static final String TRAINING_T3                          = 'Training3 (OM Returns Disputes)';
    
    public static final String TRAINING_NOT_DONE                    = 'Not Done';
    public static final String TRAINING_SCHEDULED                   = 'Scheduled';
    public static final String TRAINING_RESCHEDULE                  = 'Reschedule';
    public static final String TRAINING_COMPLETED                   = 'Completed';
    
    public static final Integer TAT_SWIMLINE_IN_PROGRESS            = 1;
    public static final Integer TAT_SWIMLINE_DROPPED                = 2;
    public static final Integer TAT_SWIMLINE_PAUSE                  = 3;
    public static final Integer TAT_SWIMLINE_TRAINING_T1            = 4;
    public static final Integer TAT_SWIMLINE_TRAINING_T2            = 5;
    public static final Integer TAT_SWIMLINE_TRAINING_T3            = 6;
}