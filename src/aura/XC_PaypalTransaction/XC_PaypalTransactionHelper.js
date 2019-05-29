
({
    callToast : function(title, type, msg) {
        var resultsToast = $A.get("e.force:showToast");

        resultsToast.setParams({
            "title": title,
            "type": type,
            "message": msg
        });

        resultsToast.fire();
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})