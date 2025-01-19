import 'package:flutter/material.dart';

void main() => runApp(const SavingsApp());

class SavingsApp extends StatelessWidget {
  const SavingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SavingsPage(),
    );
  }
}

class SavingsPage extends StatelessWidget {
  final double currentSavings = 2000.0;
  final double savingsGoal = 5000.0;

  @override
  Widget build(BuildContext context) {
    double progress = currentSavings / savingsGoal;

    return Scaffold(
      appBar: AppBar(title: const Text('Savings Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Savings Goal Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                Container(

                  width: (MediaQuery.of(context).size.width * 0.8) * progress,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${currentSavings.toStringAsFixed(0)}\$ / ${savingsGoal.toStringAsFixed(0)}\$',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
