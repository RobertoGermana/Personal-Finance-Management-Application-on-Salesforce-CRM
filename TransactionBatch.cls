public with sharing class TransactionBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
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
      List<Transazione__c> transactionsToInsert = new List<Transazione__c>();
      Set<String> accountIds = new Set<String>();

      // Prepare the account data
      Map<String, Account> accounts = new Map<String, Account>();
      for (SObject sObj : scope) {
          Account a = (Account) sObj;
          accounts.put(a.Bank_Account_Id__c, a);
          accountIds.add(a.Bank_Account_Id__c);
      }

      // Process each account's transactions
      for (Account a : accounts.values()) {
          try {
              String authorization = 'Bearer ' + a.Access_Token__c;
              String accountId = a.Bank_Account_Id__c;

              HttpRequest req = new HttpRequest();
              req.setEndpoint('https://bankaccountdata.gocardless.com/api/v2/accounts/' + accountId + '/transactions/');
              req.setMethod('GET');
              req.setHeader('accept', 'application/json');
              req.setHeader('Authorization', authorization);

              Http http = new Http();
              HttpResponse res = http.send(req);

              if (res.getStatusCode() == 200) {
                  List<TransactionJsonParser> parsers = TransactionJsonParser.parseTransactions(res.getBody());

                  // Query for existing transactions outside the loop
                  Set<String> existingTransactionIds = new Set<String>();
                  for (Transazione__c existingTransaction : [
                      SELECT Name
                      FROM Transazione__c
                  ]) {
                      existingTransactionIds.add(existingTransaction.Name);
                  }

                  for (TransactionJsonParser parser : parsers) {
                      if (parser != null && parser.transactionId != null && !existingTransactionIds.contains(parser.transactionId)) {
                          Transazione__c trans = new Transazione__c();
                          trans.Amount__c = parser.amount;
                          trans.Name = parser.transactionId;
                          trans.Value_Date__c = Date.valueOf(parser.valueDate);
                          trans.Descrizione__c = parser.remittanceInformation;
                          trans.Account__c = a.Id; // Use the Account ID from the loop

                          transactionsToInsert.add(trans);
                      }
                  }
              } else {
                  System.debug('Error: ' + res.getStatusCode() + ' - ' + res.getStatus());
              }
          } catch (Exception e) {
              System.debug('Exception: ' + e.getMessage());
          }
      }

      if (!transactionsToInsert.isEmpty()) {
          insert transactionsToInsert;
      }
  }

  public void finish(Database.BatchableContext context) {
      // Perform any cleanup or post-processing if necessary
  }

}