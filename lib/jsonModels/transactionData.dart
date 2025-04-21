import 'dart:convert';

import 'package:intl/intl.dart';
import '../config/AppConfig.dart';
import 'TransactionHistories.dart';
import 'TransactionHistory.dart';
import 'package:http/http.dart' as http;

class TransactionData {
 late final List<Map<String, dynamic>> expenseTransactions;
 late final List<Map<String, dynamic>> savingTransactions;

 final DateFormat _inputFormat = DateFormat('dd MMM yyyy');
 final DateFormat _outputFormat = DateFormat('dd.MM.yyyy');

 Future<void> loadTransactions() async {
  expenseTransactions = await _fetchAndFormat("expense");
  savingTransactions = await _fetchAndFormat("saving");
 }

 // Приватный метод, работающий как прослойка между БД и представлением
 Future<List<Map<String, dynamic>>> _fetchAndFormat(String type) async {
  List<TransactionHistory>? transactions =
  await TransactionHistories.fetchTransactionsByType(type);

  if (transactions == null) return [];

  List<Map<String, dynamic>> updatedData = transactions.map((tr) {
   DateTime parsedDate = _inputFormat.parse(tr.createdAt);
   String formattedDate = _outputFormat.format(parsedDate);

   return {
    'ID': tr.id,
    'Amount': tr.amount,
    'type': tr.type,
    'Date': formattedDate,
   };
  }).toList();

  updatedData.sort((a, b) => a['ID'].compareTo(b['ID']));
  print(updatedData);
  return updatedData;
 }
 static Future<List<Map<String, dynamic>>?> loadTransactionsByPeriod(int period) async{
  Uri url = Uri.parse("${AppConfig.transactionsByPeriod}").replace(queryParameters: {
   'period': period.toString(), // e.g., 'week', 'month', 'year'
  },);

  try{
   final response = await http.get(url,  headers: {
    // 'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // If using authentication
    'user-id': '2cbbbf55-81f0-4475-8fe0-e29c664b6aa3',
    // 'user-id': userId,
    'Content-Type': 'application/json',
   },);
   if(response.statusCode == 200){
    print("analytics transactions : \n ${response.body}");
    List<dynamic> data = jsonDecode(response.body);
    String nameOfKey = period == 1? 'date' : 'month';
    List<Map<String, dynamic>> parsedData = data
        .map((item) => {

     'Date': item[nameOfKey],
     'Amount': (item['amount'] as num).toDouble(),
    })
        .toList();

    return parsedData;
   }else {
    print(response.body);
   }
  }catch(e){
   print("error with getting transactions by period ${e}");
  }
 }
}

void main() async{
 List<Map<String, dynamic>>? data = await TransactionData.loadTransactionsByPeriod(1);
 if (data!=null){
  for (var tr in data){
   print(tr['date']);
   print(tr['amount']);
  }
 }
}
