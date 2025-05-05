import 'dart:convert';

import 'package:flutter_frontend/config/AppConfig.dart';
import 'package:flutter_frontend/jsonModels/PendingIncome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PendingIncomes{
  final List<PendingIncome> pendingIncomes;
  
  PendingIncomes({required this.pendingIncomes});
  
  factory PendingIncomes.fromJson(List<dynamic> jsonList){
    List<PendingIncome> pendingIncomeList = jsonList.map((json) =>PendingIncome.fromJson(json)).toList();
    return PendingIncomes(pendingIncomes: pendingIncomeList);
  }
  
  static Future<List<PendingIncome>?> fetchPendingIncomes() async{
    final url = Uri.parse(AppConfig.pendingIncomesEndPoint);
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if(userId!=null){
      try{
        final response = await http.get(url,
          headers: {
            // 'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // If using authentication
            'user-id': userId,
            // 'user-id': userId,
            'Content-Type': 'application/json',
          },
        );
        if(response.statusCode == 200){
          print("pending transactions ${response.body}");
          List<dynamic> data = jsonDecode(response.body);
          return data.map((pending) => PendingIncome.fromJson(pending)).toList();
        }
      }catch(e){
        print("error with fetching pending incomes $e");
      }
    }
  }
}