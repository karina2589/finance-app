import 'dart:convert';

class Expense {
  /*

model Expense {
  id                 Int                  @id @default(autoincrement())
  title              String
  description        String?
  amount             Float
  frequency          Frequency?
  date               DateTime?
  category           ExpenseCategory?
  createdAt          DateTime             @default(now())
  updatedAt          DateTime             @updatedAt
  user               User                 @relation(fields: [userId], references: [id])
  userId             String
  TransactionHistory TransactionHistory[]
}

        "id": 7,
        "title": "Necessities",
        "description": "Random things that come up",
        "amount": 20000,
        "frequency": "MONTHLY",
        "date": null,
        "category": "OTHER",
        "createdAt": "2025-02-26T04:23:56.475Z",
        "updatedAt": "2025-02-26T04:23:56.475Z",
        "userId": "2c78e2de-d04a-49ea-8af8-7fac68a63fe5"
   */
  final int id;
  final String title;
  final String? description;
  final double amount;
  final String? frequency;
  final String? date;
  final String? category;
  final String createdAt;
  final String updatedAt;
  final String userId;
  final double usedAmount;

  Expense(
      {required this.id,
      required this.title,
      required this.description,
      required this.amount,
      required this.frequency,
      required this.date,
      required this.category,
      required this.createdAt,
      required this.updatedAt,
      required this.userId,
      required this.usedAmount});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        amount:  (json['amount'] as num).toDouble(),
        frequency: json['frequency'],
        date: json['date'],
        category: json['category'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        userId: json['userId'],
      usedAmount: (json['usedAmount'] as num).toDouble()
    );
  }

//   @override
//   String toString() {
//     return '''
// Expense(
//   id: $id,
//   title: "$title",
//   description: ${description ?? "null"},
//   amount: $amount,
//   frequency: "$frequency",
//   date: ${date ?? "null"},
//   category: "$category",
//   createdAt: "$createdAt",
//   updatedAt: "$updatedAt",
//   userId: "$userId"
// )''';
//   }
}
