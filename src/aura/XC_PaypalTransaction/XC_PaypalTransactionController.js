({
    myAction : function(component, event, helper) {
        var action = component.get("c.getPaymentTransaction");

        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(data) {
            component.set("v.ccTransaction", data.getReturnValue());
        });
        $A.enqueueAction(action);
    },

    voidTransaction : function(component, event, helper){
        var action = component.get("c.voidTrans");

        action.setParams({
            transPayment: component.get("v.ccTransaction")
        });

        action.setCallback(this, function(response){
            var resp = response.getReturnValue();
            if(resp.success){
                helper.callToast('Success', 'success', 'Your transaction has been successfully voided.');
            }else{
                helper.callToast('Error', 'error', 'We encountered an error while processing your request.');
            }

        });
        $A.enqueueAction(action);
    },

    chargeTransaction : function(component, event, helper){
        var action = component.get("c.chargeTrans");

        action.setParams({
            transPayment: component.get("v.ccTransaction")
        });

        action.setCallback(this, function(response){
            var resp = response.getReturnValue();
            if(resp.success){
                helper.callToast('Success', 'success', 'Your transaction has been successfully charged.');
            }else{
                helper.callToast('Error', 'error', 'We encountered an error while processing your request.');
            }

        });
        $A.enqueueAction(action);
    },

    refundTransaction : function(component, event, helper){
        var action = component.get("c.refundTrans");
        alert(component.find("amountId").get("v.value"));

        action.setParams({
            transPayment: component.get("v.ccTransaction"),
            refundAmount: component.find("amountId").get("v.value")
        });

        action.setCallback(this, function(response){
            var resp = response.getReturnValue();
            if(resp.success){
                helper.callToast('Success', 'success', 'Your transaction has been successfully charged.');
            }else{
                helper.callToast('Error', 'error', 'We encountered an error while processing your request.');
            }

        });
        $A.enqueueAction(action);
    }
})