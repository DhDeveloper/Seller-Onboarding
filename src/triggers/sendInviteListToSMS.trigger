trigger sendInviteListToSMS on Opportunity (after Update) {
    
    Integer count = 0;
    String finalData = '\tOpp Name \t Reg Email';
    
    if(Trigger.isAfter){
        for(Opportunity opp: Trigger.new){
            if(opp.Is_Invited__c == 1){
                finalData+='\t'+opp.Name+'\t'+opp.Seller_Registration_Email__c;
                count++;
            }
            finalData+='\n';
        }
    }
    
    if(count > 0){
        //Commit current transaction, reserver email capacity
        Messaging.reserveSingleEmailCapacity(1);
        //Create an email message object
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
        List<Messaging.SendEmailResult> results = new list<Messaging.SendEmailResult>();
        //hold email address
        String[] toAddresses = new String[] {'murali.dharnala@in.pwc.com'};
    
        //Assign new address string
        mail.setToAddresses(toAddresses);
        //sender name
        mail.setSenderDisplayName('Seller Onboarding Salesforce System');
        //Subject Specification
        mail.setSubject('List of Invited people');
        //And... the content
        mail.setPlainTextBody('Invited List \n'+finalData);
        results = Messaging.sendEmail(new Messaging.Email[] { mail });
    }
}