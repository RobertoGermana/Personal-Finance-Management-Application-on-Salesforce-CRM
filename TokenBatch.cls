public with sharing class TokenBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
  
  // Batchable start method
  public Database.QueryLocator start(Database.BatchableContext context) {
    // Query for accounts with non-empty Refresh_Token__c and Bank_Account_Id__c not empty
    return Database.getQueryLocator(
      [SELECT Id, Refresh_Token__c, Access_Token__c 
       FROM Account 
       WHERE  Bank_Account_Id__c != '']
    );
  }

  // Batchable execute method
  public void execute(Database.BatchableContext context, List<sObject> scope) {
    List<Account> accountsToUpdate = new List<Account>();
    Http http = new Http(); // Create a single instance of Http

    for (SObject sObj : scope) {
      Account acc = (Account) sObj;
      String refreshToken = acc.Refresh_Token__c;

      if (refreshToken != null && refreshToken != '') {
        try {
          // Create and configure HttpRequest
          HttpRequest req = new HttpRequest();
          req.setEndpoint('https://bankaccountdata.gocardless.com/api/v2/token/refresh/');
          req.setMethod('POST');
          req.setHeader('Accept', 'application/json');
          req.setHeader('Content-Type', 'application/json');
          req.setBody('{"refresh": "' + refreshToken + '"}');

          // Send HTTP request and handle response
          HttpResponse res = http.send(req);

          if (res.getStatusCode() == 200) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String accessToken = (String) responseMap.get('access');

            if (accessToken != null) {
              acc.Access_Token__c = accessToken;
              accountsToUpdate.add(acc);
            } else {
              System.debug('Access token is null in response for Account Id: ' + acc.Id);
            }
          } else {
            System.debug('Error response for Account Id: ' + acc.Id + ' - Status Code: ' + res.getStatusCode() + ' - Status: ' + res.getStatus());
            System.debug('Response Body: ' + res.getBody());
          }
        } catch (Exception e) {
          System.debug('Exception while processing Account Id: ' + acc.Id + ' - ' + e.getMessage());
        }
      } else {
        System.debug('Refresh Token is empty for Account Id: ' + acc.Id);
      }
    }

    // Bulk update all modified accounts
    if (!accountsToUpdate.isEmpty()) {
      try {
        update accountsToUpdate;
      } catch (DmlException e) {
        System.debug('DML Exception during update: ' + e.getMessage());
      }
    }
  }

  // Batchable finish method
  public void finish(Database.BatchableContext context) {
    
  }

}