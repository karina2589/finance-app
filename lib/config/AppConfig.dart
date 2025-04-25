class AppConfig {
  static const String baseUrl = "https://financemanager-tor6.onrender.com/api/v1";

  // Endpoints
  static const String usersEndpoint = "$baseUrl/users";
  static const String registrationendPoint = "$baseUrl/auth/register";
  static const String loginEndPoint = "$baseUrl/auth/login";
  static const String profileEndPoint = "$baseUrl/profile";
  static const String incomesEndPoint = "$baseUrl/incomes";
  static const String expensesEndPoint = "$baseUrl/expenses";
  static const String savingsEndPoint = "$baseUrl/savings";
  static const String cardsEndPoint = "$baseUrl/cards";
  static const String cardsDetailsEndPoint = "$baseUrl/cards/details";
  static const String transactionsEndPoint = "$baseUrl/transactions";
  static const String expenseTransactionsEndPoint = "$baseUrl/transactions/expense";
  static const String savingTransactionsEndPoint = "$baseUrl/transactions/saving";
  static const String transactionsSummaryEndPoint = "$baseUrl/analytics/transaction-summary";
  static const String statementUploadEndPoint = "$baseUrl/document/bankstatement";
  static const String transactionsByPeriod = "$baseUrl/analytics/transactions";
  static const String balanceOverviewEndPoint = "$baseUrl/analytics/balance-overview";

//https://financemanager-tor6.onrender.com/api/v1/users

}
