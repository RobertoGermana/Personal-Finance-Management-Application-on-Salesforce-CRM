public with sharing class CategoryField {
  public static void category(List<Transazione__c> transactions) {
    for (Transazione__c trans : transactions) {
      if (trans.Amount__c < 0) {
        if (
          trans.Descrizione__c != null &&
          (trans.Descrizione__c.contains('MD') ||
           trans.Descrizione__c.contains('LIDL') ||
           trans.Descrizione__c.contains('CONAD') ||
           trans.Descrizione__c.contains('FAMILA') ||
           trans.Descrizione__c.contains('DECÒ') ||
           trans.Descrizione__c.contains('EUROSPIN') ||
           trans.Descrizione__c.contains('SUPERMERCATO') ||
           trans.Descrizione__c.contains('D&D'))
        ) {
          trans.Category__c = 'Spesa';
        } else if (
          trans.Descrizione__c != null &&
          (trans.Descrizione__c.contains('TABACCHI') ||
           trans.Descrizione__c.contains('MARIO SAMPERI') ||
           trans.Descrizione__c.contains('BOTTEGA DELLO SVAPO') ||
           trans.Descrizione__c.contains('BERTE ANGELA'))
        ) {
          trans.Category__c = 'Sigarette';
        } else if (
          trans.Descrizione__c != null &&
          (trans.Descrizione__c.contains('PAYPAL') ||
           trans.Descrizione__c.contains('AMAZON'))
        ) {
          trans.Category__c = 'Acquisti Online';
        } else if (trans.Descrizione__c != null && trans.Descrizione__c.contains('CHINATOWN')) {
          trans.Category__c = 'Bazar';
        } else if (
          trans.Descrizione__c != null &&
          (trans.Descrizione__c.contains('FRATELLI LA BUFALA') ||
           trans.Descrizione__c.contains('MERCURY') ||
           trans.Descrizione__c.contains('CANTINA SOLFERINO') ||
           trans.Descrizione__c.contains('MCDONALD') ||
           trans.Descrizione__c.contains('MC DONALD') ||
           trans.Descrizione__c.contains('LA CORTE DEI MARI') ||
           trans.Descrizione__c.contains('BURGER KING') ||
           trans.Descrizione__c.contains('RISTORANTE') ||
           trans.Descrizione__c.contains('TRATTORIA') ||
           trans.Descrizione__c.contains('BIRROTECA') ||
           trans.Descrizione__c.contains('SUSHI') ||
           trans.Descrizione__c.contains('BAR'))
        ) {
          trans.Category__c = 'Ristorante';
        } else if (trans.Descrizione__c != null && trans.Descrizione__c.contains('GENTILE GROUP')) {
          trans.Category__c = 'Barbiere';
        } else if (trans.Descrizione__c != null && trans.Descrizione__c.contains('GOLDBET')) {
          trans.Category__c = 'Scommesse';
        } else if (
          trans.Descrizione__c != null &&
          (trans.Descrizione__c.contains('ESSO') ||
           trans.Descrizione__c.contains('ESS') ||
           trans.Descrizione__c.contains('ENI') ||
           trans.Descrizione__c.contains('Q8') ||
           trans.Descrizione__c.contains('IP'))
        ) {
          trans.Category__c = 'Benzina';
        } else {
          trans.Category__c = 'Generico';
        }
      } else if (trans.Amount__c == 0) {
        trans.Category__c = 'Operazioni Banca';
      } else {
        if (trans.Descrizione__c != null && trans.Descrizione__c.contains('STIPENDIO')) {
          trans.Category__c = 'Stipendio';
        } else {
          trans.Category__c = 'Accredito';
        }
      }
    }
  }
}
