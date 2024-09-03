public class BalanceJsonParser {
  public Decimal balanceAmount { get; set; }

  public BalanceJsonParser(Decimal balanceAmount) {
      this.balanceAmount = balanceAmount;
  }

  public static BalanceJsonParser parseFirstBalance(String jsonResponse) {
      BalanceJsonParser parser = null;
      
      try {
          Map<String, Object> parsedJson = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
          List<Object> balances = (List<Object>) parsedJson.get('balances');
          
          if (balances != null && !balances.isEmpty()) {
              Map<String, Object> firstBalance = (Map<String, Object>) balances.get(0);
              Map<String, Object> balanceAmountMap = (Map<String, Object>) firstBalance.get('balanceAmount');
              String amountString = (String) balanceAmountMap.get('amount');
              Decimal amount = Decimal.valueOf(amountString);
              
              parser = new BalanceJsonParser(amount);
          }
      } catch (Exception e) {
          System.debug('Error parsing balance information: ' + e.getMessage());
      }
      
      return parser;
  }
}