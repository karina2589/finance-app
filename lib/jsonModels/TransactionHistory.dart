import 'package:flutter_frontend/jsonModels/Expense.dart';
import 'package:flutter_frontend/jsonModels/Saving.dart';

import 'BankCard.dart';

class TransactionHistory {
/*
model TransactionHistory {
  id        Int             @id @default(autoincrement())
  amount    Float
  type      TransactionType
  createdAt DateTime        @default(now())
  updatedAt DateTime        @updatedAt
  expenseId Int?
  expense   Expense?        @relation(fields: [expenseId], references: [id])
  savingId  Int?
  saving    Saving?         @relation(fields: [savingId], references: [id])
  userId    String
  user      User            @relation(fields: [userId], references: [id])
  incomeId  Int?
  income    Income?         @relation(fields: [incomeId], references: [id])
  cardId    Int?
  card      Card?           @relation(fields: [cardId], references: [id])
}

 */

  final int id;
  final double amount;
  final String type;
  final String createdAt;
  final String updatedAt;
  final int? expenseId;
  final int? savingId;
  final String userId;
  final int? incomeId;
  final int? cardId;
  final Map<String, dynamic>? expense;
  final Map<String, dynamic>? saving;
  final Map<String, dynamic>? card;
  final Map<String, dynamic>? income;

  TransactionHistory(
      {required this.id,
      required this.amount,
      required this.type,
      required this.createdAt,
      required this.updatedAt,
      required this.expenseId,
       this.expense,
      required this.savingId,
      required this.incomeId,
       this.saving,
        this.income,
      required this.userId,
      required this.cardId,
       this.card});

  /*

        "id": 20,
        "amount": 20.5,
        "type": "EXPENSE",
        "createdAt": "05 Mar 2025",
        "updatedAt": "2025-03-05T10:29:23.137Z",
        "expenseId": 15,
        "savingId": null,
        "userId": "2cbbbf55-81f0-4475-8fe0-e29c664b6aa3",
        "incomeId": null,
        "cardId": null,
        "card": null,
        "expense": {
            "title": "Meeting with friends"
        }
    }
   */

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    return TransactionHistory(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      type: json['type'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      expenseId: json['expenseId'] == null ? null: json['expenseId'],
      savingId: json['savingId'] == null ? null : json['savingId'],
      incomeId: json['incomeId'] == null ? null : json['incomeId'],
      cardId: json['cardId'] == null ? null : json['cardId'],
      userId: json['userId'],
      expense: json['expense'] != null ? Map<String, dynamic>.from(json['expense']) : null,
      saving: json['saving'] != null ? Map<String, dynamic>.from(json['saving']) : null,
      card: json['card'] != null ? Map<String, dynamic>.from(json['card']) : null,
      income: json['income'] != null ? Map<String, dynamic>.from(json['income']) : null,
    );
  }
}


