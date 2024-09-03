trigger BigTransactionTrigger on Transazione__c(after insert) {
  List<Transazione__c> transazioni = Trigger.new;
  for (Transazione__c trans : transazioni) {
    if (trans.Amount__c < -100) {
      EmailUtility.sendBigTransEmail(
        'robertogermana07@gmail.com',
        trans.Amount__c
      );
    } else if (trans.Descrizione__c.contains('Stipendio')&& trans.Amount__c > 100) {
      EmailUtility.sendSalaryEmail(
        'robertogermana07@gmail.com',
        trans.Amount__c
      );
    } else if (
      !trans.Descrizione__c.contains('Stipendio') && trans.Amount__c > 100
    ) {
      EmailUtility.sendBigIncomeEmail(
        'robertogermana07@gmail.com',
        trans.Amount__c
      );
    }
  }

}