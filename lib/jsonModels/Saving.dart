class Saving {
  /*
   "id": 1,
        "title": "Car",
        "description": "My dream car",
        "targetAmount": 70000,
        "savedAmount": 0,
        "monthlySaving": null,
        "dueDate": null,
        "createdAt": "2025-03-03T10:14:18.638Z",
        "updatedAt": "2025-03-03T10:14:18.638Z",
        "userId": "2cbbbf55-81f0-4475-8fe0-e29c664b6aa3"
        
          id                 Int                  @id @default(autoincrement())
  title              String
  description        String?
  targetAmount       Float
  savedAmount        Float?
  monthlySaving      Float?
  dueDate            DateTime?
  createdAt          DateTime             @default(now())
  updatedAt          DateTime             @updatedAt
  user               User                 @relation(fields: [userId], references: [id])
  userId             String
   */

  final int id;
  final String title;
  final String? description;
  final double targetAmount;
  final double? savedAmount;
  final double? monthlySaving;
  final String? dueDate;
  final String? createdDate;
  final String? updatedAt;
  final String userId;

  Saving({
    required this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
    required this.savedAmount,
    required this.monthlySaving,
    required this.dueDate,
    required this.createdDate,
    required this.updatedAt,
    required this.userId
  });

  factory Saving.fromJson(Map<String, dynamic> json){
    return Saving(id: json['id'],
        title: json['title'],
        description: json['description'],
        targetAmount: (json['targetAmount'] as num).toDouble(), // 👈 Приводим к double
        savedAmount: (json['savedAmount'] as num).toDouble(), // 👈 Приводим к double
        monthlySaving: json['monthlySaving'] != null ? (json['monthlySaving'] as num).toDouble() : null,
        dueDate: json['dueDate'],
        createdDate: json['createdDate'],
        updatedAt: json['updatedAt'],
        userId: json['userId']);
  }
}