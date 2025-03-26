import 'dart:convert';

class Income {
  /*
  [
  {
    "id": 1,
    "amount": 5000,
    "description": "Salary for January",
    "frequency": "MONTHLY",
    "date": null,
    "category": "SALARY",
    "createdAt": "2025-01-20T10:00:00Z",
    "updatedAt": "2025-01-20T10:00:00Z",
    "userId": "28c20116-f286-47ac-a301-16a63d742671"
  }
]
   */

  final int id;
  final String title;
  final double amount;
  final String? description;
  final String? frequency;
  final String? date;
  final String? category;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? userId;
  final int? cardId;

  Income({
    required this.id,
    required this.title,
    required this.amount,
    required this.description,
    required this.frequency,
    required this.date,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.cardId
  });

  factory Income.fromJson(Map<String, dynamic> json){
    return Income(id: json['id'],
        title: json['title'],
        amount: (json['amount'] as num).toDouble(),
        description: json['description'],
        frequency: json['frequency'],
        date: json['date'],
        category: json['category'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        cardId: json['cardId'],
        userId: json['userId']);
  }
}