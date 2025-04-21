// import 'package:flutter/material.dart';
// import 'package:flutter_frontend/models/analytics/LineChart.dart';
// import 'package:flutter_frontend/models/analytics/transactionData.dart';
//
//
// void main(){
//   runApp(MaterialApp(home: TogglePageViewExample(),));
// }
// class TogglePageViewExample extends StatefulWidget {
//   @override
//   _TogglePageViewExampleState createState() => _TogglePageViewExampleState();
// }
//
// class _TogglePageViewExampleState extends State<TogglePageViewExample> {
//   PageController _pageController = PageController();
//   List<bool> _selected = [true, false, false];
//   List<Map<String, dynamic>> expenses = [];
//   List<Map<String, dynamic>> savings = [];
//   bool isLoading = true;
//
//   void getData() async {
//     final transactionData = TransactionData();
//     await transactionData.loadTransactions();
//     print("FETCHING TRANSACTIONS....");
//     print(transactionData);
//
//     setState(() {
//       print("Expense:");
//       expenses = _aggregateByDate(transactionData.expenseTransactions);
//       print(transactionData.expenseTransactions);
//       print(expenses);
//
//       print("Saving:");
//       savings = _aggregateByDate(transactionData.savingTransactions);
//       print(transactionData.savingTransactions);
//       print(savings);
//       isLoading = false;
//     });
//   }
//
//   List<Map<String, dynamic>> _aggregateByDate(
//       List<Map<String, dynamic>> transactions) {
//     final Map<String, double> aggregated = {};
//
//     for (var tx in transactions) {
//       final date = tx['Date'].toString() ?? null;
//       final amount = tx['Amount'];
//
//       if (date == null || amount == null) continue;
//
//       final parsedAmount = (amount as num).toDouble();
//
//       if (aggregated.containsKey(date)) {
//         aggregated[date] = aggregated[date]! + parsedAmount;
//       } else {
//         aggregated[date] = parsedAmount;
//       }
//     }
//     print(aggregated);
//
// // Преобразуем в List<Map<String, double>>
//     List<Map<String, dynamic>> result =
//     aggregated.entries.map<Map<String, dynamic>>((entry) {
//       return {
//         "Date": entry.key,
//         "Amount": entry.value.toDouble(), // обязательно приведение к double
//       };
//     }).toList();
//
//     return result;
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getData();
//     print("GETTING DATA - LOADING...");
//   }
//
//
//
//   void _onTogglePressed(int index) {
//     setState(() {
//       for (int i = 0; i < _selected.length; i++) {
//         _selected[i] = i == index;
//       }
//       _pageController.animateToPage(index,
//           duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
//     });
//   }
//
//   void _onPageChanged(int index) {
//     setState(() {
//       for (int i = 0; i < _selected.length; i++) {
//         _selected[i] = i == index;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Toggle PageView")),
//       body: Column(
//         children: [
//           SizedBox(height: 20),
//           ToggleButtons(
//             isSelected: _selected,
//             onPressed: _onTogglePressed,
//             children: [
//               Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   child: Text("Page 1")),
//               Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   child: Text("Page 2")),
//               Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   child: Text("Page 3")),
//             ],
//           ),
//           Expanded(
//             child: PageView(
//               controller: _pageController,
//               onPageChanged: _onPageChanged,
//               children: [
//                 LineChart(transactions1: expenses, transactions2: savings),
//                 Center(child: Text("Page 2")),
//                 LineChart(transactions1: expenses, transactions2: savings),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
