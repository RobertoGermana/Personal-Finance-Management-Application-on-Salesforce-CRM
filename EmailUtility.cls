public with sharing class EmailUtility {
  public static void sendBigTransEmail(
    String recipientEmail,
    Decimal transactionAmount
  ) {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setToAddresses(new List<String>{ recipientEmail });
    mail.setSenderDisplayName('Your Bank Org');
    mail.setSubject('Big transaction detected');

    String formattedAmount = '€' + String.valueOf(transactionAmount.abs());
    String body = 'Dear User,<br><br>';
    body +=
      'A big transaction of ' +
      formattedAmount +
      ' has been detected in your bank account.<br>';
    body += 'Please check it out.<br><br>';
    body += 'Thanks.';

    mail.setHtmlBody(body);
    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }
  public static void sendSalaryEmail(
    String recipientEmail,
    Decimal transactionAmount
  ) {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setToAddresses(new List<String>{ recipientEmail });
    mail.setSenderDisplayName('Your Bank Org');
    mail.setSubject('Salary charged');
    String body = 'Dear User,<br><br>';
    body += 'Your salary has been charged for €' + transactionAmount + '.<br>';
    body += 'Thanks.';
    mail.setHtmlBody(body);

    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }
  public static void sendBigIncomeEmail(
    String recipientemail,
    Decimal transactionAmount
  ) {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setToAddresses(new List<String>{ recipientemail });
    mail.setSenderDisplayName('Your Bank Org');
    mail.setSubject('Big income detected');
    String body = 'Dear User,<br><br>';
    body +=
      'We detected a big income that is not salary on your bank account of €' +
      transactionAmount +
      '.<br>';
    body += 'Thanks.';
    mail.setHtmlBody(body);
    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }
}