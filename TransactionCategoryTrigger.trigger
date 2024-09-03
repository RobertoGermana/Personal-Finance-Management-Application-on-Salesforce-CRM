trigger TransactionCategoryTrigger on Transazione__c(before insert) {
  CategoryField.category(Trigger.new);
}