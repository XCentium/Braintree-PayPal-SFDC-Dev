public with sharing class XC_PaypalSettingController {
    @AuraEnabled public List<String> environmentTypeList {get;set;}
    @AuraEnabled public List<String> x3DSecureList {get;set;}
    @AuraEnabled public List<String> paymentModelList {get;set;}
    @AuraEnabled public List<String> paymentModelIntentList {get;set;}
    @AuraEnabled public List<String> paypalButtonDisplayList {get;set;}
    @AuraEnabled public List<XC_Paypal_Setting__mdt> currPaypalSettingList {get;set;}

    @AuraEnabled
    public static XC_PaypalSettingController initClass(){
        XC_PaypalSettingController obj = new XC_PaypalSettingController();
        obj.environmentTypeList = new List<String>();
        obj.currPaypalSettingList = new List<XC_Paypal_Setting__mdt>();
        obj.x3DSecureList = new List<String>();
        obj.paymentModelList = new List<String>();
        obj.paymentModelIntentList = new List<String>();
        obj.paypalButtonDisplayList = new List<String>();
        integer count = 0;

        for(XC_Paypal_Setting__mdt ps : [SELECT Id,DeveloperName, XC_Environment__c, XC_Storefront__c, XC_Private_Key__c, XC_Endpoint__c, XC_Merchant_Account_Id__c,XC_Merchant_Id__c,
                XC_Public_Key__c, XC_Username__c, XC_Password__c, XC_Tokenization_Key__c FROM XC_Paypal_Setting__mdt]){

            obj.currPaypalSettingList.add(ps);
        }

        Schema.DescribeFieldResult fieldResult = XC_Paypal_Setting__mdt.XC_Environment__c.getDescribe();
        List<Schema.PicklistEntry> ft = fieldResult.getPicklistValues();

        for(Schema.PicklistEntry f : ft){
            obj.environmentTypeList.add(f.getValue());
        }

        fieldResult = XC_Paypal_Setting__mdt.XC_3DSecure__c.getDescribe();
        ft = fieldResult.getPicklistValues();

        for(Schema.PicklistEntry f : ft){
            obj.x3DSecureList.add(f.getValue());
        }

        fieldResult = XC_Paypal_Setting__mdt.XC_Payment_Model__c.getDescribe();
        ft = fieldResult.getPicklistValues();

        for(Schema.PicklistEntry f : ft){
            obj.paymentModelList.add(f.getValue());
        }

        fieldResult = XC_Paypal_Setting__mdt.XC_Payment_Model_Intent__c.getDescribe();
        ft = fieldResult.getPicklistValues();

        for(Schema.PicklistEntry f : ft){
            obj.paymentModelIntentList.add(f.getValue());
        }

        fieldResult = XC_Paypal_Setting__mdt.XC_Paypal_Express_Button__c.getDescribe();
        ft = fieldResult.getPicklistValues();

        for(Schema.PicklistEntry f : ft){
            obj.paypalButtonDisplayList.add(f.getValue());
        }

        return obj;
    }

    @AuraEnabled
    public static void deleteSetting(String developerName) {
        XC_DeleteSetting.deleteSetting(developerName);

    }

    @AuraEnabled
    public static void insertUpdateSetting(Map<String, Object> valuesMap){

        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        Metadata.CustomMetadata paypalSetting = new Metadata.CustomMetadata();
        paypalSetting.fullName = 'XC_Paypal_Setting__mdt' + '.' + (String)valuesMap.get('developername');
        paypalSetting.label = (String)valuesMap.get('masterlabel');

        for(String s : valuesMap.keySet()){
            if(s != 'developername' && s != 'masterlabel'){
                Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
                customField.field = s;
                customField.value = (String)valuesMap.get(s);

                paypalSetting.values.add(customField);
                mdContainer.addMetadata(paypalSetting);
            }
        }

        XC_CustomMetadataCallback callback = new XC_CustomMetadataCallback();
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
    }

    @AuraEnabled
    public static void insertUpdateSetting(String metadataName){
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        mdContainer.removeMetadataByFullname('XC_Paypal_Setting__mdt.'+metadataName);
        XC_CustomMetadataCallback callback = new XC_CustomMetadataCallback();
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
    }


    @AuraEnabled
    public static XC_Paypal_Setting__mdt paypalSettingChange(String envType){
        XC_Paypal_Setting__mdt psObj  = new XC_Paypal_Setting__mdt();
        psObj   = [SELECT Id,DeveloperName, XC_Environment__c, XC_Storefront__c, XC_Private_Key__c, XC_Endpoint__c, XC_Merchant_Account_Id__c,XC_Merchant_Id__c,
                XC_Public_Key__c, XC_Username__c, XC_Password__c, XC_Tokenization_Key__c, XC_3DSecure__c,XC_Billing_Agreement_Description__c,XC_Descriptor_Name__c,
                XC_Descriptor_Phone__c,XC_Descriptor_URL__c,XC_Merchant_Name__c,XC_Payment_Model__c,XC_Payment_Model_Intent__c,XC_Paypal_Express_Button__c
        FROM XC_Paypal_Setting__mdt WHERE DeveloperName =: envType LIMIT 1];
        return psObj ;
    }

}