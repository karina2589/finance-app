import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/config/AppConfig.dart';
import 'package:flutter_frontend/jsonModels/Analytics.dart';
import 'package:http/http.dart' as http;

class AnalyticsProvider{
  
  static Future<TransactionsSummary?> fetchTransactionsSummary() async{
    final url = Uri.parse(AppConfig.transactionsSummaryEndPoint);
    // final prefs = await SharedPreferences.getInstance();
    // String? userId = prefs.getString('userId');

    try{
      final response = await http.get(url,
        headers: {
          // 'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // If using authentication
          'User-ID': "2cbbbf55-81f0-4475-8fe0-e29c664b6aa3",
          // Adding User-ID in the header
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TransactionsSummary.fromJson(data);
      } else {
        print('error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
    }
}

// void main() async{
//   TransactionsSummary? summary = await AnalyticsProvider.fetchTransactionsSummary();
//   if(summary!= null){
//     print(summary.totalSaving);
//     print(summary.totalSpending);
//     print(summary.totalIncome);
//   }
// }