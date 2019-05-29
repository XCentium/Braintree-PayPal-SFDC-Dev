({
    initController : function(component, event, helper) {
        var action = component.get("c.initClass");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS"){
                component.set("v.paypal", response.getReturnValue());
                var paypalController = response.getReturnValue();
                var updateButton = component.find("updateId");
                var removeButton = component.find("removeId");
                updateButton.set("v.disabled",true);
                removeButton.set("v.disabled",true);
                component.set("v.paymentModelValue", paypalController.paymentModelList[0]);
                component.set("v.x3DSecureValue", paypalController.x3DSecureList[0]);
                component.set("v.paymentModelIntentValue", paypalController.paymentModelIntentList[0]);
                component.set("v.paypalExpressButtonValue", paypalController.paypalButtonDisplayList[0]);
                component.set("v.environmentValue", paypalController.environmentTypeList[0]);
            }

        });
        $A.enqueueAction(action);

    },

    deleteSetting: function(component, event, helper){
        component.set("v.spinner", true);
        var action = component.get("c.deleteSetting");
        var developerName = component.get("v.developerNameValue");
        action.setParams({
            developerName: developerName
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            var msg = "";
            var tTitle = "";
            var tType = "";
            var toastEvent = $A.get("e.force:showToast");

            if(state == "ERROR"){
                msg = "Please try again!";
                tTitle = "Error";
                tType = "error";

            }else{
                msg = "Your record has been successfully deleted!";
                tTitle = "Success";
                tType = "success";
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
                component.set("v.envSelectedValue", "new");

            }

            toastEvent.setParams({
                "title": tTitle,
                "message": msg,
                "type": tType
            });
            toastEvent.fire();

        });
        $A.enqueueAction(action);
    },

    insertUpdateSetting : function(component, event, helper) {
        component.set("v.spinner", true);
        var self = this;
        var action = component.get("c.insertUpdateSetting");
        var buttonId = event.getSource().getLocalId();
        var developerName = component.get("v.developerNameValue");
        var masterLabel = "";
        var hasError = false;
        var phoneRegexFormat = /^\(?\d{3}\)?[.\0\-]?\d{3}[.\0\-]?\d{4}$/;
        var urlRegexFormat = /^[a-zA-Z0-9.]+$/;
        var phoneValue = component.get("v.descriptorPhoneValue");
        var phoneCmp = component.find("descriptorPhoneId");
        var urlCmp = component.find("descriptorURLId");
        var urlValue = component.get("v.descriptorURLValue");

        if(!urlCmp.get("v.validity").valid){
            urlCmp.showHelpMessageIfInvalid();
            hasError = true;
        }else{
            if(!urlValue.match(urlRegexFormat)) {
                urlCmp.setCustomValidity("URL can only contain letters, numbers and periods");
                urlCmp.showHelpMessageIfInvalid();
                hasError = true;
            }else{
                urlCmp.setCustomValidity("");
            }
        }

        if(!phoneCmp.get("v.validity").valid){
            phoneCmp.showHelpMessageIfInvalid();
            hasError = true;
        }else {
            if(!phoneValue.match(phoneRegexFormat)) {
                phoneCmp.setCustomValidity("Enter valid phone number");
                phoneCmp.showHelpMessageIfInvalid();
                hasError = true;
            }else{
                phoneCmp.setCustomValidity("");
            }
        }

        if(!component.find("merchantNameId").get("v.validity").valid){
            component.find("merchantNameId").showHelpMessageIfInvalid();
            hasError = true;
        }

        if(!component.find("billingAgreementDescriptionId").get("v.validity").valid){
            component.find("billingAgreementDescriptionId").showHelpMessageIfInvalid();
            hasError = true;
        }

        if(!component.find("descriptorNameId").get("v.validity").valid){
            component.find("descriptorNameId").showHelpMessageIfInvalid();
            hasError = true;
        }

        if(!component.find("storeFrontId").get("v.validity").valid){
            component.find("storeFrontId").showHelpMessageIfInvalid();
            hasError = true;
        }

        if(!component.find("privateKeyId").get("v.validity").valid){
            component.find("privateKeyId").showHelpMessageIfInvalid();
            hasError = true;
        }

        if(!component.find("endpointId").get("v.validity").valid){
            component.find("endpointId").showHelpMessageIfInvalid();
            hasError = true;
        }

        if(!component.find("merchantId").get("v.validity").valid){
            component.find("merchantId").showHelpMessageIfInvalid();
            hasError = true;
        }

        if(!component.find("publicKeyId").get("v.validity").valid){
            component.find("publicKeyId").showHelpMessageIfInvalid();
            hasError = true;
        }

        if(!component.find("userNameId").get("v.validity").valid){
            component.find("userNameId").showHelpMessageIfInvalid();
            hasError = true;
        }

        if(!component.find("passWordId").get("v.validity").valid){
            component.find("passWordId").showHelpMessageIfInvalid();
            hasError = true;
        }

        if(!component.find("tokenizationKeyId").get("v.validity").valid){
            component.find("tokenizationKeyId").showHelpMessageIfInvalid();
            hasError = true;
        }

        if(!hasError){

            var storefront = component.get("v.storeFrontValue");
            var environment = component.find("envTypeId").get("v.value");
            developerName = storefront.replace(/\s/g, '') + "_" + environment.replace(/\s/g, '');
            masterLabel = storefront + " " + environment;

            action.setParams(
                {
                    "valuesMap": {
                        "XC_Storefront__c": component.get("v.storeFrontValue"),
                        "XC_Environment__c": component.find("envTypeId").get("v.value"),
                        "masterlabel": masterLabel,
                        "XC_Public_Key__c": component.get("v.publicKeyValue"),
                        "XC_Endpoint__c": component.get("v.endpointValue"),
                        "XC_Merchant_Account_Id__c": component.get("v.merchantAccountIdValue"),
                        "XC_Merchant_Id__c": component.get("v.merchantIdValue"),
                        "XC_Private_Key__c": component.get("v.privateKeyValue"),
                        "XC_Password__c" : component.get("v.passWordValue"),
                        "XC_Username__c" : component.get("v.userNameValue"),
                        "XC_Tokenization_Key__c" : component.get("v.tokenizationKeyValue"),
                        "developername": developerName,
                        "XC_3DSecure__c" : component.find("x3DSecureId").get("v.value"),
                        "XC_Billing_Agreement_Description__c" : component.get("v.billingAgreementDescriptionValue"),
                        "XC_Descriptor_Name__c" : component.get("v.descriptorNameValue"),
                        "XC_Descriptor_Phone__c" : component.get("v.descriptorPhoneValue"),
                        "XC_Descriptor_URL__c" : component.get("v.descriptorURLValue"),
                        "XC_Merchant_Name__c" : component.get("v.merchantNameValue"),
                        "XC_Payment_Model__c" : component.find("paymentModelId").get("v.value"),
                        "XC_Payment_Model_Intent__c" : component.find("paymentModelIntentId").get("v.value"),
                        "XC_Paypal_Express_Button__c" : component.find("paypalExpressButtonId").get("v.value")

                    }
                }
            );

            action.setCallback(this, function(result) {
                var state = result.getState();
                var msg = "";
                var tTitle = "";
                var tType = "";
                var toastEvent = $A.get("e.force:showToast");

                if(buttonId == "createId"){
                    msg = "Your record has been successfully created!";
                    if(state != "ERROR"){
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
                    }

                }else{
                    msg = "Your record has been successfully updated!";
                }

                if(state == "ERROR"){
                    msg = "Please try again!";
                    tTitle = "Error";
                    tType = "error";

                }else{
                    tTitle = "Success";
                    tType = "success";

                }

                toastEvent.setParams({
                    "title": tTitle,
                    "message": msg,
                    "type": tType
                });
                toastEvent.fire();

            });
            $A.enqueueAction(action);
        }else{

            //error message
        }

    }
})