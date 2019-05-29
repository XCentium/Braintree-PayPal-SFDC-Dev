public with sharing class XC_DeleteSetting {

    @Future(callout=true)
    public static void deleteSetting(String developerName){
        system.debug(developerName);
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        MetadataService.DeleteResult [] results = new MetadataService.DeleteResult []{};
        List<String> recordsToDelete = new List<String>();
        recordsToDelete.add('XC_Paypal_Setting__mdt' + '.' + developerName);
        results = service.deleteMetadata('CustomMetadata', recordsToDelete);
        system.debug(results);

    }

}