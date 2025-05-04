import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/config/AppConfig.dart';
import 'package:flutter_frontend/jsonModels/Analytics.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsProvider {
  static Future<TransactionsSummary?> fetchTransactionsSummary() async {
    final url = Uri.parse(AppConfig.transactionsSummaryEndPoint);
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if(userId!= null){
      try {
        final response = await http.get(
          url,
          headers: {
            // 'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // If using authentication
            'User-ID': userId,
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

  static Future<TransactionsSummary?> fetchTotalsByPeriod(int period) async {
    final url = Uri.parse(AppConfig.transactionsSummaryEndPoint).replace(queryParameters: {
      'period': period.toString(), 
    });
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if(userId!=null){
      try {
        final response = await http.get(
          url,
          headers: {
            // 'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // If using authentication
            'User-ID': userId,
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

  static Future<Map<String, dynamic>?> balanceOverview() async{
    final url = Uri.parse(AppConfig.balanceOverviewEndPoint);
/*

{totalIncome: 89737, totalExpenses: 652, currentBalance: 893310}
 */
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if(userId!=null){
      try{
        final response = await http.get(
          url,
          headers: {
            // 'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // If using authentication
            'User-ID': userId,
            // Adding User-ID in the header
            'Content-Type': 'application/json',
          },
        );
        if(response.statusCode == 200){
          // print(response.body);
          final data = jsonDecode(response.body);
          if (data is Map<String, dynamic>) {
            return data;
          } else {
            print("Unexpected data format: ${response.body}");
            return null;
          }
        } else {
          print("Failed to load data. Status code: ${response.body}");
          return null;
        }
      }catch(e){
        print("exception with fetching balance overview $e");
      }
    }
  }
  }

void main() async{
  // TransactionsSummary? summary = await AnalyticsProvider.fetchTotalsByPeriod(6);
  // if(summary!= null){
  //   print(summary.totalSaving);
  //   print(summary.totalSpending);
  //   print(summary.totalIncome);
  // }

  Map<String, dynamic>? data = await AnalyticsProvider.balanceOverview();
  if(data!=null){
    print(data);
  }
}
