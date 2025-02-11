import 'package:flutter/material.dart';

void main() => runApp(const BankCardsApp());

class BankCardsApp extends StatelessWidget {
  const BankCardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Bank Cards')),
        body: const BankCardsView(),
      ),
    );
  }
}

class BankCardsView extends StatefulWidget {
  const BankCardsView({super.key});

  @override
  State<BankCardsView> createState() => _BankCardsViewState();
}

class _BankCardsViewState extends State<BankCardsView> {
  late PageController _pageViewController;

  final List<Map<String, String>> _cards = [
    {"bank": "Visa", "balance": "\$1,250.75", "cardNumber": "**** 5678"},
    {"bank": "MasterCard", "balance": "\$3,420.00", "cardNumber": "**** 1234"},
    {"bank": "American Express", "balance": "\$980.50", "cardNumber": "**** 9876"},
  ];

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(viewportFraction: 0.85); // Видим часть следующей карты
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 250,
        child: PageView.builder(
      controller: _pageViewController,
      itemCount: _cards.length,
      itemBuilder: (context, index) {
        final card = _cards[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: BankCard(
            bankName: card["bank"]!,
            balance: card["balance"]!,
            cardNumber: card["cardNumber"]!,
          ),
        );
      },
    ));
  }
}

class BankCard extends StatelessWidget {
  final String bankName;
  final String balance;
  final String cardNumber;

  const BankCard({
    super.key,
    required this.bankName,
    required this.balance,
    required this.cardNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: Colors.blueAccent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(bankName, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
            Text("Income", style: TextStyle(fontSize: 16, color: Colors.white70)),
            Text(balance, style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(height: 10,)
          ],
        ),
      ),
    )
    );
  }
}
