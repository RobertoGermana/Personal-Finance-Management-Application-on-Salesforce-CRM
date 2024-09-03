public with sharing class TransactionJsonParser {
    public Decimal amount { get; set; }
    public String transactionId { get; set; }
    public String valueDate { get; set; }
    public String remittanceInformation { get; set; }

    public static List<TransactionJsonParser> parseTransactions(String jsonResponse) {
        List<TransactionJsonParser> parsers = new List<TransactionJsonParser>();

        // Deserialize JSON response
        Map<String, Object> parsedJson = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);

        // Access booked transactions
        List<Object> bookedTransactions = (List<Object>) parsedJson.get('booked');
        if (bookedTransactions != null) {
            for (Object obj : bookedTransactions) {
                Map<String, Object> transactions = (Map<String, Object>) obj;
                TransactionJsonParser parser = new TransactionJsonParser();
                parser.transactionId = (String) transactions.get('transactionId');
                Map<String, Object> transactionAmount = (Map<String, Object>) transactions.get('transactionAmount');
                parser.amount = transactionAmount != null ? Decimal.valueOf((String) transactionAmount.get('amount')) : null;
                parser.valueDate = (String) transactions.get('valueDate');
                parser.remittanceInformation = (String) transactions.get('remittanceInformationUnstructured');
                parsers.add(parser);
            }
        }

        // Access pending transactions
        List<Object> pendingTransactions = (List<Object>) parsedJson.get('pending');
        if (pendingTransactions != null) {
            for (Object obj : pendingTransactions) {
                Map<String, Object> transactions = (Map<String, Object>) obj;
                TransactionJsonParser parser = new TransactionJsonParser();
                Map<String, Object> transactionAmount = (Map<String, Object>) transactions.get('transactionAmount');
                parser.amount = transactionAmount != null ? Decimal.valueOf((String) transactionAmount.get('amount')) : null;
                parser.valueDate = (String) transactions.get('valueDate');
                parser.remittanceInformation = (String) transactions.get('remittanceInformationUnstructured');
                parsers.add(parser);
            }
        }

        return parsers;
    }
}