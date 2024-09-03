public with sharing class GetBankAccountId {
  public static String getBankAccountId() {
    String bankNameForField = 'UniCredit';
    List<Account> accts = [
      SELECT
        Name,
        Registration_Id__c,
        Bank_Account_Id__c,
        Access_Token__c,
        BNFF__c
      FROM Account
      WHERE Name = :bankNameForField
    ];
    System.debug('qui arrivo');
    String access_Token = accts[0].Access_Token__c;
    String authorization = 'Bearer ' + access_Token;
    System.debug(accts);
    String registId = accts.get(0).Registration_Id__c;
    HttpRequest req = new HttpRequest();
    req.setEndpoint(
      'https://bankaccountdata.gocardless.com/api/v2/requisitions/' +
        registId +
        '/'
    );
    System.debug('qui anche ');
    req.setMethod('GET');
    req.setHeader('accept', 'application/json');
    req.setHeader('Authorization', authorization);

    Http http = new Http();
    HttpResponse res = http.send(req);
    if (res.getStatusCode() == 200) {
      // Deserialize the JSON response into a Map<String, Object>
      Map<String, Object> requisition = (Map<String, Object>) JSON.deserializeUntyped(
        res.getBody()
      );

      // Debug statement to ensure the map is deserialized correctly
      System.debug('qui spero');

      // Retrieve the value associated with the key 'accounts'
      Object accountsValue = requisition.get('accounts');
      System.debug(accountsValue);

      // Convert the value to a string
      String bankAccountId = String.valueOf(accountsValue).replaceAll('\\)', '').replaceAll('\\(', '');

      

      // Output the string value
      System.debug(bankAccountId);
      System.debug(bankAccountId);

      accts.get(0).Bank_Account_Id__c = bankAccountId;
      update accts;
      return bankAccountId;
    } else {
      System.debug('Error: ' + res.getStatusCode() + ' - ' + res.getStatus());

      return null;
    }
  }
}