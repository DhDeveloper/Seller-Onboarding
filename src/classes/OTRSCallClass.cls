global class OTRSCallClass {
	@future(callout=true)
  	public static void callOTRSTest() {
	 	
	 	Httprequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('http://172.17.78.32/otrs/index.pl');
        String header = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tic="http://www.otrs.org/TicketConnector/"><soapenv:Header/><soapenv:Body>';
        String footer = '  </soapenv:Body></soapenv:Envelope>';

        String XML = header+'<SessionCreate><UserLogin>admin</UserLogin> <Password>admin</Password></SessionCreate>'+footer;
        request.setHeader('Content-Type', 'text/xml');
        request.setBody(XML);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        
        String resp = response.getBody();  
        System.debug('======================================================>>>>>>>>>>>>>>>>>>>>>Response: '+resp);
  	}
}