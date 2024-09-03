public class GoCardlessIntegration {
  // Define your secret credentials
  private static final String SECRET_ID = '';
  private static final String SECRET_KEY = '';//You can get this from the GoCardless App Dashboard

  // Static variables to store the access token
  public static String accessToken;
  public static String refreshToken;
  public static Integer expirationTime;
  public static Datetime receivedTime;
  public static String bankId;
  public static String agreementId;
  public static String link;
  public static String bankNameForField;
  public static String registrationId;

  // Method to get the access token

  public static String getAccessToken() {
    if (accessToken == null || isExpired()) {
      // Token not yet retrieved or expired, fetch it from GoCardless API
      String payload =
        '{"secret_id":"' +
        SECRET_ID +
        '","secret_key":"' +
        SECRET_KEY +
        '"}';

      HttpRequest req = new HttpRequest();
      req.setEndpoint(
        'https://bankaccountdata.gocardless.com/api/v2/token/new/'
      );
      req.setMethod('POST');
      req.setHeader('accept', 'application/json');
      req.setHeader('Content-Type', 'application/json');
      req.setBody(payload);

      Http http = new Http();
      HttpResponse res = http.send(req);

      if (res.getStatusCode() == 200) {
        // Successful request, parse the response body
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(
          res.getBody()
        );
        accessToken = (String) responseMap.get('access');
        expirationTime = (Integer) responseMap.get('access_expires');
        refreshToken=(String) responseMap.get('refresh');
        receivedTime = Datetime.now();
        System.debug(expirationTime);
        System.debug(receivedTime);
        System.debug('Access Token received and stored: ' + accessToken);
      } else {
        // Request failed
        System.debug('Error: ' + res.getStatusCode() + ' - ' + res.getStatus());
        System.debug('Response: ' + res.getBody());
      }
    }

    return accessToken;
  }

  // Method to check if access token is expired
  private static Boolean isExpired() {
    if (accessToken == null || expirationTime == null || receivedTime == null) {
      return true;
    }
    Datetime expiryTime = receivedTime.addSeconds(expirationTime);
    return Datetime.now().getTime() >= expiryTime.getTime();
  }

  // Method to get the bank ID for a given bank name
  public static String getBankId(String bankName) {
    if (accessToken == null || isExpired()) {
      accessToken = getAccessToken();
    }

    String authorization = 'Bearer ' + accessToken;
    System.debug(authorization);
    HttpRequest bankIdReq = new HttpRequest();
    bankIdReq.setEndpoint(
      'https://bankaccountdata.gocardless.com/api/v2/institutions/?country=it'
    );
    bankIdReq.setMethod('GET');
    bankIdReq.setHeader('accept', 'application/json');
    bankIdReq.setHeader('Authorization', authorization);

    Http http = new Http();
    HttpResponse res = http.send(bankIdReq);

    if (res.getStatusCode() == 200) {
      // Deserialize the JSON string into a list of maps
      List<Object> institutions = (List<Object>) JSON.deserializeUntyped(
        res.getBody()
      );
      System.debug(institutions);

      for (Object obj : institutions) {
        Map<String, Object> institution = (Map<String, Object>) obj;
        
        if (String.valueOf(institution.get('name')) == (bankName)) {

          bankId = (String) institution.get('id');
          
          bankNameForField = (String) institution.get('name');
          System.debug(bankNameForField);
          System.debug(bankId);
          return bankId;
        }
      }
    } else {
      // Request failed
      System.debug('Error: ' + res.getStatusCode() + ' - ' + res.getStatus());
      System.debug('Response: ' + res.getBody());
    }

    // Return null if no matching bank name is found
    return null;
  }
  public static String createAgreement() {
    String bodySet =
      '{"institution_id": "' +
      bankId +
      '","max_historical_days": "730","access_valid_for_days": "180","access_scope": ["balances", "details", "transactions"] }';
    String authorization = 'Bearer ' + accessToken;
    HttpRequest agreementReq = new HttpRequest();
    agreementReq.setEndpoint(
      'https://bankaccountdata.gocardless.com/api/v2/agreements/enduser/'
    );
    agreementReq.setMethod('POST');
    agreementReq.setHeader('accept', 'application/json');
    agreementReq.setHeader('Content-Type', 'application/json');
    agreementReq.setHeader('Authorization', authorization);
    agreementReq.setBody(bodySet);
    Http http = new Http();
    HttpResponse res = http.send(agreementReq);
    if (res.getStatusCode() == 201) {
      Map<String, Object> agreement = (Map<String, Object>) JSON.deserializeUntyped(
        res.getBody()
      );
      System.debug(agreement);
      System.debug(agreement.get('id'));
      agreementId = (String) agreement.get('id');
      System.debug(agreementId);
      return agreementId;
    } else {
      System.debug('Error: ' + res.getStatusCode() + ' - ' + res.getStatus());
      System.debug('Response: ' + res.getBody());
      return null;
    }
  }
  //After running this method get the link in the logs to connect your bank account
  public static String getLink() {
    String body =
      '{"redirect": "http://www.yourwebpage.com","institution_id": "' +
      bankId +
      '","agreement": "' +
      agreementId +
      '","user_language":"IT" }';
    String authorization = 'Bearer ' + accessToken;
    HttpRequest req = new HttpRequest();
    req.setEndpoint(
      'https://bankaccountdata.gocardless.com/api/v2/requisitions/'
    );
    req.setMethod('POST');
    req.setHeader('accept', 'application/json');
    req.setHeader('Content-Type', 'application/json');
    req.setHeader('Authorization', authorization);
    req.setBody(body);
    Http http = new Http();
    HttpResponse res = http.send(req);
    if (res.getStatusCode() == 201) {
      Map<String, Object> requisition = (Map<String, Object>) JSON.deserializeUntyped(
        res.getBody()
      );

      link = (String) requisition.get('link');
      registrationId = (String) requisition.get('id');
      System.debug(link);
      return link;
    } else {
      System.debug('Error: ' + res.getStatusCode() + ' - ' + res.getStatus());
      System.debug('Response: ' + res.getBody());
      return null;
    }
  }
  public static void updateAccount(
    String links,
    String registrationIds,
    String bankNames
  ) {
    links = link;
    registrationIds = registrationId;
    bankNames = bankNameForField;
    String access_Token= accessToken;

    List<Account> accList = [
      SELECT
        Name,
        Registration_Id__c,
        Registration_Link__c,
        BNFF__c,
        Access_Token__c,
        Refresh_Token__c
      FROM Account
      WHERE Name = :bankNameForField
    ];
    for (Account acc : accList) {
      acc.Registration_Link__c = links;
      acc.Registration_Id__c = registrationIds;
      acc.Access_Token__c= access_Token;
      acc.Refresh_Token__c=refreshToken;
      if (accList.size() > 0) {
        update accList;
      }
    }
  }
}