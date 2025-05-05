class PendingIncome {
  /*
     {
        "id": 57,
        "title": "Additional scholarship",
        "description": "data engineering course",
        "amount": 50000,
        "frequency": "MONTHLY",
        "date": null,
        "category": "OTHER",
        "userId": "d5a01baa-8502-4aa6-a3fb-246f5415f162",
        "cardId": 42,
        "createdAt": "2025-05-05T06:48:10.558Z",
        "updatedAt": "2025-05-05T06:48:10.558Z"
    }
   */

  final int id;
  final String title;
  final String description;
  final double amount;
  final String frequency;
  final int cardId;

  PendingIncome({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.frequency,
    required this.cardId
  });

  factory PendingIncome.fromJson(Map<String, dynamic> json){
    return PendingIncome(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        amount: (json['amount'] as num).toDouble(),
        frequency: json['frequency'],
        cardId: json['cardId']);
  }
}