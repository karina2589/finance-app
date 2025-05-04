import 'dart:convert';

import 'package:flutter_frontend/config/AppConfig.dart';
import 'package:flutter_frontend/jsonModels/Expense.dart';

//import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Expenses {
  final List<Expense> expenses;

  Expenses({required this.expenses});

  factory Expenses.fromJson(List<dynamic> jsonList) {
    List<Expense> expenseList =
    jsonList.map((json) => Expense.fromJson(json)).toList();
    return Expenses(expenses: expenseList);
  }

  static Future<List<Expense>?> fetchExpenses() async {
    final Uri url = Uri.parse(AppConfig.expensesEndPoint);
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
    try {
      final response = await http.get(
        url,
        headers: {
          // 'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // If using authentication
          // Adding User-ID in the header
          'user-id': userId,
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
       // print(response.body);
        List<dynamic> expensesData = jsonDecode(response.body);
        return expensesData
            .map((expense) => Expense.fromJson(expense))
            .toList();
      }
    } catch (e) {
      print("Fetching expenses error $e");
        }
    }
  }

  static Future<bool> addExpense(Map<String, dynamic> newExpense) async {
    /*
    title
    amount
    frequency
    description
    category
     */
    bool success = false;
    final Uri url = Uri.parse(AppConfig.expensesEndPoint);
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if(userId!=null){
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'user-id': userId,
          },
          body: jsonEncode({
            "title": newExpense['title'],
            "amount": newExpense['amount'],
            "description": newExpense['description'],
            "frequency": newExpense['frequency'],
            "category": newExpense['category']
          }),
        );
        if (response.statusCode == 200) {
          print('expense created: ${response.body}');

          success = true;
          //success = false;
        }
      } catch (e) {
        print("add expense error ${e}");
        success = false;
      }
    }
    return success;
  }

  static Future<bool> deleteExpense(int id) async {
    final String url = "${AppConfig.expensesEndPoint}/$id";
    bool success = false;
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if(userId!=null){
      try {
        final response = await http.delete(Uri.parse(url),
            headers: {
              'user-id': userId,
            });

        if (response.statusCode == 200 || response.statusCode == 204) {
          success = true; // Successfully deleted
        } else {
          print("Failed to delete expense: ${response.body}");
          return false;
        }
      } catch (e) {
        print("Error deleting expense: $e");
        success = false;
      }
    }
    return success;
  }

  static Future<bool> updateExpense(int id, Map<String, dynamic> newExpense) async {
    bool success = false;
    final String url = "${AppConfig.expensesEndPoint}/$id";
    Map<String, dynamic> filteredExpense = newExpense..removeWhere((key, value) => value == null);

    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');


    if(userId!=null){
      try {
        final response = await http.put(
          Uri.parse(url),
          headers: {
            'user-id': userId,
            'Content-Type': 'application/json',
          },
          body: jsonEncode(filteredExpense),
        );

        if (response.statusCode == 200) {
          success = true;
        }
      } catch (e) {
        print("Error updating expense: $e");
      }
    }
    return success;
  }

}


void main() async {
  int id = 23;
  Map<String, dynamic> newExp = {
    "title": "old expense"
  };
  List<Expense>? expenses = await Expenses.fetchExpenses();
  if(expenses!= null){
    for(var expense in expenses){
      print(expense.id);
      print(expense.title);
      print(expense.amount);
      print(expense.usedAmount);
    }
  }
}
