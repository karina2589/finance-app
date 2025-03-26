import 'Income.dart';
import 'TransactionHistory.dart';

class BankCard {
  /*
  model Card {
  id                 Int                  @id @default(autoincrement())
  title              String
  createdAt          DateTime             @default(now())
  updatedAt          DateTime             @updatedAt
  Income             Income[]
  userId             String
  user               User                 @relation(fields: [userId], references: [id])
  TransactionHistory TransactionHistory[]
}

   */
  final int id;
  final String title;
  final String? createdAt;
  final String? updatedAt;
  final List<Income> incomes;
  final String userId;
  final List<TransactionHistory> transactionHistory;

  BankCard({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.incomes,
    required this.userId,
    required this.transactionHistory
  });

  factory BankCard.fromJson(Map<String, dynamic> json){
    return BankCard(id: json['id'],
        title: json['title'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        incomes: (json['Income'] as List<dynamic>?)
            ?.map((e) => Income.fromJson(e))
            .toList() ?? [],
        userId: json['userId'],
        transactionHistory: (json['TransactionHistory'] as List<dynamic>?)
            ?.map((e) => TransactionHistory.fromJson(e))
            .toList() ?? []);
  }

}