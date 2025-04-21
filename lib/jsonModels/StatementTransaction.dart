class StatementTransaction {
  /*
  "transactions": [
        {
            "createdAt": "2025-02-17T00:00:00.000Z",
            "amount": 1900,
            "type": "EXPENSE",
            "title": "ХОЗТОВАРЫ"
        },
        {
            "createdAt": "2025-02-17T00:00:00.000Z",
            "amount": 1900,
            "type": "INCOME",
            "title": "From Kaspi Deposit"
        }
    ]
   */

  final String createdAt;
  final double amount;
  final String type;
  final String title;

  StatementTransaction({required this.createdAt,
    required this.amount,
    required this.type,
    required this.title});

  factory StatementTransaction.fromJson(Map<String, dynamic> json){
    return StatementTransaction(
        createdAt: json['createdAt'],
        amount: (json['amount'] as num).toDouble(),
        type: json['type'],
        title: json['title']);
  }

  static List<StatementTransaction> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((item) => StatementTransaction.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
