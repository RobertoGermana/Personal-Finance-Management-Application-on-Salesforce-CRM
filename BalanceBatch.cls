public with sharing class BalanceBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
  public Database.QueryLocator start(Database.BatchableContext context) {
    // Query for accounts with non-empty Bank_Account_Id__c
    return Database.getQueryLocator(
      [
        SELECT Id, Access_Token__c, Bank_Account_Id__c
        FROM Account
        WHERE Bank_Account_Id__c != ''
      ]
    );
  }

  public void execute(Database.BatchableContext context, List<SObject> scope) {
    List<Account> accountsToUpdate = new List<Account>();

    for (SObject sObj : scope) {
      Account a = (Account) sObj;
      try {
        String authorization = 'Bearer ' + a.Access_Token__c;
        String accountId = a.Bank_Account_Id__c;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(
          'https://bankaccountdata.gocardless.com/api/v2/accounts/' +
            accountId +
            '/balances/'
        );
        req.setMethod('GET');
        req.setHeader('accept', 'application/json');
        req.setHeader('Authorization', authorization);
        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
          String jsonResponse = res.getBody();
          BalanceJsonParser parser = BalanceJsonParser.parseFirstBalance(
            jsonResponse
          );

          if (parser != null) {
            a.Balance__c = parser.balanceAmount;
            accountsToUpdate.add(a);
          } else {
            System.debug(
              'No balance information found for Account Id: ' + a.Id
            );
          }
        } else {
          System.debug(
            'Error: ' + res.getStatusCode() + ' - ' + res.getStatus()
          );
        }
      } catch (Exception e) {
        System.debug('Exception: ' + e.getMessage());
      }
    }

    if (!accountsToUpdate.isEmpty()) {
      update accountsToUpdate;
    }
  }

  public void finish(Database.BatchableContext context) {
  }}