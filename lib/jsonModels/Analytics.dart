class TransactionsSummary {
  /*
  {
    "totalSpending": 652,
    "totalSaving": 9462,
    "totalIncome": 89737
}
   */
  final double totalSpending;
  final double totalSaving;
  final double totalIncome;

  TransactionsSummary({required this.totalSpending,
    required this.totalSaving,
    required this.totalIncome});

  factory TransactionsSummary.fromJson(Map<String, dynamic> json){
    return TransactionsSummary(
        totalSpending: (json['totalSpending'] ?? 0).toDouble(),
        totalSaving:  (json['totalSaving'] ?? 0).toDouble(),
        totalIncome:  (json['totalIncome'] ?? 0).toDouble());
  }
}
