class CardDetail{
  /*
   {
        "id": 9,
        "title": "Kaspi",
        "balance": 5000
    },
   */
  final int id;
  final String title;
  final double balance;

  CardDetail({required this.id, required this.title, required this.balance});

  factory CardDetail.fromJson(Map<String, dynamic> json){
    return CardDetail(id: json['id'],
        title: json['title'],
        balance: (json['balance'] as num).toDouble());
  }
}