({
    doInit : function(component, event, helper) {
        helper.initController(component, event, helper);

    },

    insertUpdateClick:function(component, event, helper){
        helper.insertUpdateSetting(component, event, helper);
    },

    deleteClick:function(component, event, helper){
        helper.deleteSetting(component, event, helper);
    },

    evnOnChange: function(component, event, helper){
        component.set("v.spinner", true);
        var selectedValue = event.getSource().get("v.value");
        var updateButton = component.find("updateId");
        var createButton = component.find("createId");
        var removeButton = component.find("removeId");

        var action = component.get("c.paypalSettingChange");
        action.setParams({
            envType: event.getSource().get("v.value")
        });

        action.setCallback(this, function(response){


            if(selectedValue != 'new'){
                createButton.set("v.disabled",true);
                updateButton.set("v.disabled",false);
                removeButton.set("v.disabled", false);
                var currSetting = response.getReturnValue();

                component.set("v.storeFrontValue", currSetting.XC_Storefront__c);
                component.set("v.environmentValue", currSetting.XC_Environment__c);
                component.set("v.masterLabelValue", currSetting.MasterLabel);
                component.set("v.publicKeyValue", currSetting.XC_Public_Key__c);
                component.set("v.endpointValue", currSetting.XC_Endpoint__c);
                component.set("v.privateKeyValue", currSetting.XC_Private_Key__c);
                component.set("v.merchantAccountIdValue", currSetting.XC_Merchant_Account_Id__c);
                component.set("v.merchantIdValue", currSetting.XC_Merchant_Id__c);
                component.set("v.userNameValue", currSetting.XC_Username__c);
                component.set("v.passWordValue", currSetting.XC_Password__c);
                component.set("v.tokenizationKeyValue", currSetting.XC_Tokenization_Key__c);
                component.set("v.developerNameValue", currSetting.DeveloperName);
                component.set("v.x3DSecureValue", currSetting.XC_3DSecure__c);
                component.set("v.billingAgreementDescriptionValue", currSetting.XC_Billing_Agreement_Description__c);
                component.set("v.descriptorNameValue", currSetting.XC_Descriptor_Name__c);
                component.set("v.descriptorURLValue", currSetting.XC_Descriptor_URL__c);
                component.set("v.merchantNameValue", currSetting.XC_Merchant_Name__c);
                component.set("v.paymentModelValue", currSetting.XC_Payment_Model__c);
                component.set("v.paymentModelIntentValue", currSetting.XC_Payment_Model_Intent__c);
                component.set("v.paypalExpressButtonValue", currSetting.XC_Paypal_Express_Button__c);
                component.set("v.descriptorPhoneValue", currSetting.XC_Descriptor_Phone__c);

            }else{
                component.set("v.storeFrontValue", "");
                component.set("v.masterLabelValue", "");
                component.set("v.publicKeyValue", "");
                component.set("v.errorMSGValue", "");
                component.set("v.endpointValue", "");
                component.set("v.privateKeyValue", "");
                component.set("v.merchantAccountIdValue", "");
                component.set("v.merchantIdValue", "");
                component.set("v.userNameValue", "");
                component.set("v.passWordValue", "");
                component.set("v.tokenizationKeyValue", "");
                component.set("v.developerNameValue", "");
                component.set("v.billingAgreementDescriptionValue", "");
                component.set("v.descriptorNameValue", "");
                component.set("v.descriptorPhoneValue", "");
                component.set("v.descriptorURLValue", "");
                component.set("v.merchantNameValue", "");
                createButton.set("v.disabled",false);
                updateButton.set("v.disabled",true);
                removeButton.set("v.disabled",true);
            }

        });
        $A.enqueueAction(action);

    },
    showSpinner: function(component, event, helper) {
        component.set("v.spinner", true);
    },

    hideSpinner : function(component,event,helper){
        component.set("v.spinner", false);
    }

})