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
    public static final String RETURN_EMAIL_ID                   	= 'murali.dharnala@in.pwc.com';//'selleronboarding@flipkart.com';//
    
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
    
    //OTRS Constants
    public static final String SOAP_HEADER							= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tic="http://www.otrs.org/TicketConnector/"><soapenv:Header/><soapenv:Body>';
    public static final String SOAP_FOOTER							= '</soapenv:Body></soapenv:Envelope>';
    public static final String TICKET_CREATE_HEADER					= '<TicketCreate>';
    public static final String TICKET_CREATE_FOOTER					= '</TicketCreate>';
    
    public static final String TICKET_GET_HEADER					= '<TicketGet>';
    public static final String TICKET_GET_FOOTER					= '</TicketGet>';
    
    public static final String CONTENT_TYPE_XML						= 'text/xml';
    public static final String OTRS_URL								= 'http://172.17.78.32/otrs/index.pl';
    
    public static final String APPLICATION_NAME						= 'OTRS';
    public static final String SERVICE_NAME_TICKET_CREATE			= 'Ticket Create';
    
    public static final String OTRS_ATTRIBUTE_LOGIN					= 'tic:UserLogin';
    public static final String OTRS_ATTRIBUTE_PASSWORD				= 'tic:Password';
    
    public static final String OTRS_ATTRIBUTE_TICKET				= 'tic:Ticket';
    public static final String OTRS_ATTRIBUTE_TITLE					= 'tic:Title';
    public static final String OTRS_ATTRIBUTE_QUEUE					= 'tic:Queue';
    public static final String OTRS_ATTRIBUTE_TYPE					= 'tic:Type';
    public static final String OTRS_ATTRIBUTE_TYPE_VALUE			= 'default';
    public static final String OTRS_ATTRIBUTE_STATE					= 'tic:State';
    public static final String OTRS_ATTRIBUTE_PRIORITY				= 'tic:Priority';
    public static final String OTRS_ATTRIBUTE_CUSTOMERUSER			= 'tic:CustomerUser';
    public static final String OTRS_ATTRIBUTE_ARTICLE				= 'tic:Article';
    public static final String OTRS_ATTRIBUTE_ARTICLETYPE			= 'tic:ArticleType';
    public static final String OTRS_ATTRIBUTE_SENDERTYPE			= 'tic:SenderType';
    public static final String OTRS_ATTRIBUTE_SENDERTYPE_VALUE		= 'customer';
    public static final String OTRS_ATTRIBUTE_FROM					= 'tic:From';
    public static final String OTRS_ATTRIBUTE_SUBJECT				= 'tic:Subject';
    public static final String OTRS_ATTRIBUTE_BODY					= 'tic:Body';
    public static final String OTRS_ATTRIBUTE_CONTENTTYPE			= 'tic:ContentType';
    public static final String OTRS_ATTRIBUTE_CONTENTTYPE_VALUE		= 'text/plain; charset=utf8';
    
    public static final String OTRS_TICKET_CREATE_URL				= 'Ticket Create URL';
    public static final String OTRS_USER_NAME						= 'User Name';
    public static final String OTRS_PASSWORD						= 'Password';
    
    
    public static final Map<String,String> QUEUE_NAMES_MAP 			= new Map<String,String>{	'Registration related' => 'SMS::Seller_Registration',
    																							'Listing related' => 'SPCatalog::Listing_Issues',
    																							'Other SMS issues' => 'SMS::Other_Team_Tickets',
    																							'Any other CMS' => 'CMS::CMS Misc'};
    																							

	public static final String outputXML = '<soap:Envelope soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
   '<soap:Body><TicketCreateResponse xmlns="http://www.otrs.org/TicketConnector/"><ArticleID>25</ArticleID><TicketID>125</TicketID><TicketNumber>2014012001000012</TicketNumber>'+
      '</TicketCreateResponse></soap:Body></soap:Envelope>';    																							
    
}