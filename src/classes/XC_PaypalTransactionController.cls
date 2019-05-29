public with sharing class XC_PaypalTransactionController {
    @AuraEnabled
    public static ccrz__E_TransactionPayment__c getPaymentTransaction(Id recordId) {

        ccrz__E_TransactionPayment__c currentTransaction = new ccrz__E_TransactionPayment__c();
        for(ccrz__E_TransactionPayment__c ct : [SELECT Id, Name, ccrz__AccountType__c,ccrz__Amount__c,ccrz__ExpirationMonth__c,ccrz__ExpirationYear__c,ccrz__PaymentType__c,
                ccrz__Token__c, ccrz__TransactionCode__c, ccrz__AccountNumber__c, ccrz__CCOrder__c FROM ccrz__E_TransactionPayment__c WHERE ccrz__CCOrder__c =: recordId LIMIT 1]){

            currentTransaction = ct;
        }

        return currentTransaction;
    }

    @AuraEnabled
    public static Map<String, Object> chargeTrans(ccrz__E_TransactionPayment__c transPayment){
        Map<String, Object> resultMap = new Map<String, Object>{
                'success' => false
        };
        try{

            //if(trans.ccrz__TransactionCode__c != null || trans.ccrz__TransactionCode__c != ''){}
            Http http = new Http();
            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setTimeout(60000);
            //httpRequest.setEndpoint(endPointURL + '/merchants/ttnv5yg2vw2hr8c4/transactions');
            httpRequest.setEndpoint('https://api.sandbox.braintreegateway.com/merchants/ttnv5yg2vw2hr8c4/transactions/'+transPayment.ccrz__Token__c+'/submit_for_settlement');

            httpRequest.setMethod('PUT');
            httpRequest.setHeader('Accept', 'application/xml');
            httpRequest.setHeader('Content-Type', 'application/xml');
            httpRequest.setHeader('Authorization', 'Basic cXRoNHh6c240NnN2aDJzejo5Mzc1OTUwZWUzNjEwY2UwYjkyMmUzMGZhYjU2M2FjOQ==');
            //httpRequest.setHeader('Authorization', 'Basic ' + reqHeaderAuth);
            httpRequest.setHeader('charset', 'UTF-8');
            httpRequest.setHeader('X-ApiVersion', '4');

            HttpResponse httpResponse = http.send(httpRequest);
            //System.debug('Response : ' + httpResponse.getStatusCode() + ' ' + httpResponse.getStatus());
            String responseBody = httpResponse.getBody();
            //System.debug('ResponseBody : ' + responseBody);
            if (httpResponse.getStatusCode() == 200) {

                Dom.Document doc = new Dom.Document();
                doc.load(responseBody);

                Dom.XmlNode transNode = doc.getRootElement();
                String chargeId = transNode.getChildElement('id',null).getText();
                String status = transNode.getChildElement('status',null).getText();

                if(status == 'submitted_for_settlement') {
                    ccrz__E_Order__c order = [Select ccrz__OrderStatus__c from ccrz__E_Order__c where Id = :transPayment.ccrz__CCOrder__c];
                    order.ccrz__OrderStatus__c = 'Charge Submitted';
                    update order;
                    resultMap.put('responseMap', responseBody);
                    resultMap.put('responseTransacId', chargeId);
                    resultMap.put('success', true);
                }
            }
        }
        catch (Exception ex) {
            System.debug(System.LoggingLevel.Error, ex.getMessage());
            System.debug(System.LoggingLevel.Error, ex.getStackTraceString());
            resultMap.put('success', false);
            resultMap.put('errormsg', ex.getMessage() + '|' + ex.getStackTraceString());
        }
        return resultMap;
    }


    @AuraEnabled
    public static Map<String, Object> voidTrans(ccrz__E_TransactionPayment__c transPayment){
        Map<String, Object> resultMap = new Map<String, Object>{
                'success' => false
        };
        try{

            Http http = new Http();
            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setTimeout(60000);
            //httpRequest.setEndpoint(endPointURL + '/merchants/ttnv5yg2vw2hr8c4/transactions');
            httpRequest.setEndpoint('https://api.sandbox.braintreegateway.com/merchants/ttnv5yg2vw2hr8c4/transactions/'+transPayment.ccrz__Token__c+'/void');

            httpRequest.setMethod('PUT');
            httpRequest.setHeader('Accept', 'application/xml');
            httpRequest.setHeader('Content-Type', 'application/xml');
            httpRequest.setHeader('Authorization', 'Basic cXRoNHh6c240NnN2aDJzejo5Mzc1OTUwZWUzNjEwY2UwYjkyMmUzMGZhYjU2M2FjOQ==');
            //httpRequest.setHeader('Authorization', 'Basic ' + reqHeaderAuth);
            httpRequest.setHeader('charset', 'UTF-8');
            httpRequest.setHeader('X-ApiVersion', '4');

            HttpResponse httpResponse = http.send(httpRequest);
            //System.debug('Response : ' + httpResponse.getStatusCode() + ' ' + httpResponse.getStatus());
            String responseBody = httpResponse.getBody();
            //System.debug('ResponseBody : ' + responseBody);
            if (httpResponse.getStatusCode() == 200) {

                Dom.Document doc = new Dom.Document();
                doc.load(responseBody);

                Dom.XmlNode transNode = doc.getRootElement();
                String voidid = transNode.getChildElement('id',null).getText();
                String status = transNode.getChildElement('status',null).getText();

                if(status == 'voided') {
                    ccrz__E_Order__c order = [Select ccrz__OrderStatus__c from ccrz__E_Order__c where Id = :transPayment.ccrz__CCOrder__c];
                    order.ccrz__OrderStatus__c = 'Void Submitted';
                    update order;
                    resultMap.put('responseMap', responseBody);
                    resultMap.put('responseTransacId', voidid);
                    resultMap.put('success', true);
                }
            }
        }
        catch (Exception ex) {
            System.debug(System.LoggingLevel.Error, ex.getMessage());
            System.debug(System.LoggingLevel.Error, ex.getStackTraceString());
            resultMap.put('success', false);
            resultMap.put('errormsg', ex.getMessage() + '|' + ex.getStackTraceString());
        }
        return resultMap;
    }

    @AuraEnabled
    public static Map<String, Object> refundTrans(ccrz__E_TransactionPayment__c transPayment, Decimal refundAmount){
        Map<String, Object> resultMap = new Map<String, Object>{
                'success' => false
        };
        try{

            system.debug('amount => ' + refundAmount);
            Http http = new Http();
            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setTimeout(60000);
            //httpRequest.setEndpoint(endPointURL + '/merchants/ttnv5yg2vw2hr8c4/transactions');
            httpRequest.setEndpoint('https://api.sandbox.braintreegateway.com/merchants/ttnv5yg2vw2hr8c4/transactions/'+transPayment.ccrz__Token__c+'/refund');

            httpRequest.setMethod('POST');
            httpRequest.setHeader('Accept', 'application/xml');
            httpRequest.setHeader('Content-Type', 'application/xml');
            httpRequest.setHeader('Authorization', 'Basic cXRoNHh6c240NnN2aDJzejo5Mzc1OTUwZWUzNjEwY2UwYjkyMmUzMGZhYjU2M2FjOQ==');
            //httpRequest.setHeader('Authorization', 'Basic ' + reqHeaderAuth);
            httpRequest.setHeader('charset', 'UTF-8');
            httpRequest.setHeader('X-ApiVersion', '4');
            if(refundAmount != null){
                httpRequest.setBody('<transaction><amount>'+refundAmount+'</amount></transaction>');
            }

            HttpResponse httpResponse = http.send(httpRequest);
            //System.debug('Response : ' + httpResponse.getStatusCode() + ' ' + httpResponse.getStatus());
            String responseBody = httpResponse.getBody();
            //System.debug('ResponseBody : ' + responseBody);
            if (httpResponse.getStatusCode() == 200) {

                Dom.Document doc = new Dom.Document();
                doc.load(responseBody);

                Dom.XmlNode transNode = doc.getRootElement();
                String refundid = transNode.getChildElement('refunded-transaction-id',null).getText();
                String status = transNode.getChildElement('status',null).getText();

                if(status == 'submitted_for_settlement') {
                    ccrz__E_Order__c order = [Select ccrz__OrderStatus__c from ccrz__E_Order__c where Id = :transPayment.ccrz__CCOrder__c];
                    order.ccrz__OrderStatus__c = 'Refund Submitted';
                    update order;
                    resultMap.put('responseMap', responseBody);
                    resultMap.put('responseTransacId', refundid);
                    resultMap.put('success', true);
                }
            }
        }
        catch (Exception ex) {
            System.debug(System.LoggingLevel.Error, ex.getMessage());
            System.debug(System.LoggingLevel.Error, ex.getStackTraceString());
            resultMap.put('success', false);
            resultMap.put('errormsg', ex.getMessage() + '|' + ex.getStackTraceString());
        }
        return resultMap;
    }

}