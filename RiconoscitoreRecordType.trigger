trigger RiconoscitoreRecordType on Transazione__c (before insert) {
    List<Transazione__c> transactionToUpdate= trigger.new;
    for(Transazione__c trans: transactionToUpdate){
       if(trans.Amount__c>0){
           trans.RecordTypeId=Schema.getGlobalDescribe().get('Transazione__c').getDescribe().getRecordTypeInfosByName().get('Entrata').getRecordTypeId();
       }else{
           trans.RecordTypeId=Schema.getGlobalDescribe().get('Transazione__c').getDescribe().getRecordTypeInfosByName().get('Uscita').getRecordTypeId();  
       }
    }
   
   }