
global with sharing class XC_Payment_Controller {

    global XC_Payment_Controller(){

    }

    @TestVisible
    private static String makePaypalCall(String payload, String endPointURL, String MerchantID, String PrivateKey, String PublicKey, String Type) {
        System.debug(' endpoint ' + endPointURL);
        System.debug(' payload ' + payload);

        String reqHeaderAuthraw = PublicKey+':'+PrivateKey;
        Blob reqHeaderAuthBlob = Blob.valueOf(reqHeaderAuthraw);
        string reqHeaderAuth = EncodingUtil.base64Encode(reqHeaderAuthBlob);

        System.debug('reqHeaderAuth :-> ' + reqHeaderAuth);

        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setTimeout(60000);
        //httpRequest.setEndpoint(endPointURL + '/merchants/ttnv5yg2vw2hr8c4/transactions');
        //if(Type == 'sale') {
        httpRequest.setEndpoint(endPointURL + '/merchants/' + MerchantID + '/transactions');
        // }else if(Type == 'void'){
        //     httpRequest.setEndpoint(endPointURL + '/merchants/' + MerchantID + '/transactions/$TRANSACTION_ID/void');
        // }
        httpRequest.setMethod('POST');
        httpRequest.setHeader('Accept', 'application/xml');
        httpRequest.setHeader('Content-Type', 'application/xml');
        httpRequest.setHeader('Authorization', 'Basic cXRoNHh6c240NnN2aDJzejo5Mzc1OTUwZWUzNjEwY2UwYjkyMmUzMGZhYjU2M2FjOQ==');
        //httpRequest.setHeader('Authorization', 'Basic ' + reqHeaderAuth);
        httpRequest.setHeader('charset', 'UTF-8');
        httpRequest.setHeader('X-ApiVersion', '4');
        httpRequest.setBody(payload);
        System.debug('httpRequest : ' + httpRequest);
        //System.debug('Request : ' + payload);
        HttpResponse httpResponse = http.send(httpRequest);
        //System.debug('Response : ' + httpResponse.getStatusCode() + ' ' + httpResponse.getStatus());
        String responseBody = httpResponse.getBody();
        //System.debug('ResponseBody : ' + responseBody);
        if (httpResponse.getStatusCode() == 201) {
            return responseBody;
        } else {
            return '';
        }
    }

    public static String getPayload(String cartId, Decimal amount, String nonce, String authSettle) {
        //LMS_PayPal__c paypalSettings =  LMS_PayPal__c.getInstance('LMS PayPal Setup');
        String payload = '';

        ccrz__E_Cart__c cartAddr = [Select
                ccrz__BillTo__r.ccrz__FirstName__c,
                ccrz__BillTo__r.ccrz__LastName__c,
                ccrz__BillTo__r.ccrz__PostalCode__c,
                ccrz__BillTo__r.ccrz__State__c,
                ccrz__BillTo__r.ccrz__City__c,
                ccrz__BillTo__r.ccrz__AddressFirstline__c,
                ccrz__BillTo__r.ccrz__AddressSecondline__c,
                ccrz__BillTo__r.ccrz__Email__c,
                ccrz__BillTo__r.ccrz__CompanyName__c,
                ccrz__BillTo__r.ccrz__HomePhone__c
        from ccrz__E_Cart__c where ccrz__EncryptedId__c = :cartId];


        if(authSettle == 'Authorization') {
            payload += '<transaction><type>sale</type><order-id>' + cartId + '</order-id><amount>'+amount+'</amount><payment-method-nonce>' + nonce + '</payment-method-nonce><customer><first-name>Drew</first-name><last-name>Smith</last-name><company>XC</company><phone>312-555-1234</phone><fax>312-555-1235</fax><website>http://www.example.com</website><email>astha.raj@xcentium.com</email></customer><billing><first-name>Paul</first-name><last-name>Smith</last-name><company>XC</company><street-address>1 E Main St</street-address><extended-address>Suite 403</extended-address><locality>Chicago</locality><region>IL</region><postal-code>60622</postal-code><country-code-alpha2>US</country-code-alpha2></billing><shipping><first-name>Jen</first-name><last-name>Smith</last-name><company>XC</company><street-address>1 E 1st St</street-address><extended-address>Suite 403</extended-address><locality>Bartlett</locality><region>IL</region><postal-code>60103</postal-code><country-code-alpha2>US</country-code-alpha2></shipping><options><store-in-vault-on-success type="boolean">true</store-in-vault-on-success></options><device-data></device-data></transaction>';
        }else if (authSettle == 'Sale'){
            payload += '<transaction><type>sale</type><order-id>' + cartId + '</order-id><amount>'+amount+'</amount><payment-method-nonce>' + nonce + '</payment-method-nonce><customer><first-name>Drew</first-name><last-name>Smith</last-name><company>XC</company><phone>312-555-1234</phone><fax>312-555-1235</fax><website>http://www.example.com</website><email>astha.raj@xcentium.com</email></customer><billing><first-name>Paul</first-name><last-name>Smith</last-name><company>XC</company><street-address>1 E Main St</street-address><extended-address>Suite 403</extended-address><locality>Chicago</locality><region>IL</region><postal-code>60622</postal-code><country-code-alpha2>US</country-code-alpha2></billing><shipping><first-name>Jen</first-name><last-name>Smith</last-name><company>XC</company><street-address>1 E 1st St</street-address><extended-address>Suite 403</extended-address><locality>Bartlett</locality><region>IL</region><postal-code>60103</postal-code><country-code-alpha2>US</country-code-alpha2></shipping><options><store-in-vault-on-success type="boolean">true</store-in-vault-on-success><submit-for-settlement>true</submit-for-settlement></options><device-data></device-data></transaction>';
        }else if (authSettle == 'stored'){
            payload += '<transaction><type>sale</type><order-id>' + cartId + '</order-id><amount>'+amount+'</amount><payment-method-token>' + nonce + '</payment-method-token><customer><first-name>Drew</first-name><last-name>Smith</last-name><company>XC</company><phone>312-555-1234</phone><fax>312-555-1235</fax><website>http://www.example.com</website><email>astha.raj@xcentium.com</email></customer><billing><first-name>Paul</first-name><last-name>Smith</last-name><company>XC</company><street-address>1 E Main St</street-address><extended-address>Suite 403</extended-address><locality>Chicago</locality><region>IL</region><postal-code>60622</postal-code><country-code-alpha2>US</country-code-alpha2></billing><shipping><first-name>Jen</first-name><last-name>Smith</last-name><company>XC</company><street-address>1 E 1st St</street-address><extended-address>Suite 403</extended-address><locality>Bartlett</locality><region>IL</region><postal-code>60103</postal-code><country-code-alpha2>US</country-code-alpha2></shipping><options><submit-for-settlement>true</submit-for-settlement></options><device-data></device-data></transaction>';
        }


        return payload;
    }

    @RemoteAction
    global static ccrz.cc_RemoteActionResult postPaypal(ccrz.cc_RemoteActionContext ctx, String nonce, String Type, Decimal amount)
    {
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success                    = false;
        res.inputContext               = ctx;
        ccrz.cc_CallContext.initRemoteContext(ctx);
        Map<String,Object> dataMap = new Map<String,Object>();

        Decimal saleAmount = amount;
        Boolean savePayment;

        // Savepoint sp = Database.setSavepoint();

        XC_Paypal_Setting__mdt settings =  [SELECT Id,DeveloperName, XC_Environment__c, XC_Storefront__c, XC_Private_Key__c, XC_Endpoint__c, XC_Merchant_Account_Id__c,XC_Merchant_Id__c,
                XC_Public_Key__c, XC_Username__c, XC_Password__c, XC_Tokenization_Key__c, XC_3DSecure__c,XC_Billing_Agreement_Description__c,XC_Descriptor_Name__c,
                XC_Descriptor_Phone__c,XC_Descriptor_URL__c,XC_Merchant_Name__c,XC_Payment_Model__c,XC_Payment_Model_Intent__c,XC_Paypal_Express_Button__c
        FROM XC_Paypal_Setting__mdt WHERE XC_Storefront__c = 'CIABBoot3' and XC_Environment__c = 'Sandbox' Limit 1];

        if (settings == null) {

            dataMap.put('STATUS', 'EXCEPTION');
            dataMap.put('theString','Missing Custom Settings.  Please contact customer service.' );
            res.success = false;
            return res;
        }
        try{

            String payload = '';
            if(Type == 'stored') {
                payload = getPayload(ctx.currentCartId, saleAmount, nonce, Type);
                System.debug(' payload remote ' + payload);
            }else{
                payload = getPayload(ctx.currentCartId, saleAmount, nonce, settings.XC_Payment_Model__c);
                System.debug(' payload remote ' + payload);
            }

            String endpointURL = 'https://api.sandbox.braintreegateway.com';
            String output = makePaypalCall(payload, settings.XC_Endpoint__c, settings.XC_Merchant_Id__c, settings.XC_Private_Key__c, settings.XC_Public_Key__c, Type);
            System.debug(' output remote ' + output );

            if(output != null && output != ''){
                system.debug('IN IF => ');
                //Read the response XML for status -
                Dom.Document doc = new Dom.Document();
                doc.load(output);

                Dom.XmlNode transNode = doc.getRootElement();
                //Dom.XmlNode transNode = rootNode.getChildElement('transaction',null);
                String ppid = transNode.getChildElement('id',null).getText();
                String status = transNode.getChildElement('status',null).getText();
                String paymentType = transNode.getChildElement('payment-instrument-type',null).getText();
                //String token = transNode.getAttribute('token',null);
                //Decimal amount = transNode.getAttribute('amount',null);

                system.debug('ID => ' + ppid);
                system.debug('Status => ' + status);

                String cardtoken;
                String last;
                String cardtype;
                String expMonth = '0';
                String expYear = '0000';
                String paymentId = '';

                String payPalDetail = transNode.getChildElement('paypal',null).getText();

                system.debug('payPalDetail => ' + payPalDetail);

                if(payPalDetail != '') {
                    Dom.XmlNode paypalNode = transNode.getChildElement('paypal', null);
                    cardtoken = paypalNode.getChildElement('authorization-id', null).getText();
                    last = paypalNode.getChildElement('payer-email', null).getText();
                    cardtype = 'paypal';
                    paymentId = paypalNode.getChildElement('payment-id', null).getText();
                    savePayment = false;
                }else{
                    Dom.XmlNode creditNode = transNode.getChildElement('credit-card', null);
                    cardtoken = creditNode.getChildElement('token', null).getText();
                    last = creditNode.getChildElement('last-4', null).getText();
                    cardtype = creditNode.getChildElement('card-type', null).getText();
                    expMonth = creditNode.getChildElement('expiration-month', null).getText();
                    expYear = creditNode.getChildElement('expiration-year', null).getText();
                    savePayment = true;
                }


                if(status == 'authorized' || status == 'submitted_for_settlement' || status == 'settling'){
                    res.success = true;
                    dataMap.put('responseMap', output);
                    //res.data = dataMap;

                    //store transaction data so CC can save this data
                    ccrz.cc_hk_Payment.TransactionPaymentParams ppTransact = new ccrz.cc_hk_Payment.TransactionPaymentParams();
                    ppTransact.subAccountNumber = last;
                    ppTransact.accountNumber = ppTransact.subAccountNumber;
                    ppTransact.paymentType = cardtype;
                    ppTransact.accountType = 'pp'; //paymentType;
                    ppTransact.transactionCode = cardtoken;
                    ppTransact.expirationMonth = Decimal.valueOf(expMonth);
                    ppTransact.expirationYear =  Decimal.valueOf(expYear);
                    ppTransact.amount = saleAmount;
                    ppTransact.requestAmount = ppTransact.amount;
                    ppTransact.storefront = 'CIABBoot3';
                    ppTransact.token = ppid;
                    ppTransact.transactionPaymentId = paymentId;
                    ppTransact.comments = payPalDetail;
                    ppTransact.transactionType = status;
                    ppTransact.saveAsStoredPayment = savePayment;
                    dataMap.put('txObject', ppTransact);
                    system.debug('Transact => ' + ppTransact);

                    res.data = dataMap;
                }
            }
        }
        catch (Exception ex) {
            System.debug(System.LoggingLevel.Error, ex.getMessage());
            System.debug(System.LoggingLevel.Error, ex.getStackTraceString());
        }

        return res;
    }

}