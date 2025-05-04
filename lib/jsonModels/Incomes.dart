import 'dart:convert';

import 'package:flutter_frontend/config/AppConfig.dart';
import 'package:flutter_frontend/jsonModels/Income.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class Incomes {
  final List<Income> incomes;

  Incomes({required this.incomes});

  factory Incomes.fromJson(List<dynamic> jsonList) {
    List<Income> incomeList =
        jsonList.map((json) => Income.fromJson(json)).toList();
    return Incomes(incomes: incomeList);
  }

  static Future<List<Income>?> fetchIncomes() async {
    final url = Uri.parse(AppConfig.incomesEndPoint);
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if(userId != null){
    try {
      final response = await http.get(
        url,
        headers: {
          // 'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // If using authentication
          'user-id': userId,
          // 'user-id': userId,
          // Adding User-ID in the header
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        print("incomes: ${response.body}");
        List<dynamic> data = jsonDecode(response.body);
        return data.map((income) => Income.fromJson(income)).toList();
        // }
        // else{
        //   throw Exception('error');
      }
    } catch (e) {
      print("fetching incomes error $e");
    }
  }

  }

  static Future<bool> addNewIncome(Map<String, dynamic> newIncome) async {
    bool success = false;
    final Uri url = Uri.parse(AppConfig.incomesEndPoint);

    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    /*
    title              String
  description        String?
  amount             Float
  frequency          Frequency?
  date               DateTime?
  category           IncomeCategory?
  userId             String
  TransactionHistory TransactionHistory[]
  cardId             Int?
     */

    Map<String, dynamic> filteredIncome = newIncome
      ..removeWhere((key, value) => value == null);

    if(userId!=null){
      try {
        final response = await http.post(url,
            headers: {
              'Content-Type': 'application/json',
              'user-id': userId,
            },
            body: jsonEncode(filteredIncome));

        if (response.statusCode == 200) {
          success = true;
          print("income added successfully");
        } else {
          print("problem with adding new income ${response.body}");
        }
      } catch (e) {
        print("error with adding new income $e");
      }
    }
    return success;
  }

  static Future<bool> deleteIncome(int id) async {
    String url = "${AppConfig.incomesEndPoint}/$id";
    bool succes = false;

    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        succes = true;
        print("income deleted successfully");
      } else {
        print("error with deleting income ${response.body}");
      }
    } catch (e) {
      print("error with deleting income $e");
    }
    return succes;
  }

  static Future<bool> updateIncome(Map<String, dynamic> updatedIncome, int id) async{
    bool success = false;
    String url = "${AppConfig.incomesEndPoint}/$id";
    Map<String, dynamic> filteredIncome = updatedIncome..removeWhere((key, value) => value == null);

    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if(userId!= null){
      try{
        final response = await http.put(Uri.parse(url),
            headers: {
              'user-id': userId,
              'Content-Type': 'application/json',
            },
            body: jsonEncode(filteredIncome)
        );
        if(response.statusCode == 200){
          success = true;
          print("income successfully updated");
        }else{
          print("error with updating income ${response.body}");
        }
      }catch(e){
        print("error with updating income $e");
      }
    }

    return success;
  }
}

void main() async {
  // Map<String, dynamic> newIncome = {
  //   "title": "new income test",
  //   "description": "smth",
  //   "amount": 560.0,
  //   "frequency": "MONTHLY",
  //   "category": "OTHER",
  //
  // };
  //
  // bool success = await Incomes.addNewIncome(newIncome);

  // bool success = await Incomes.deleteIncome(27);

  Map<String, dynamic> updatedIncome = {"title": "updated sdu fee"};
  bool success = await Incomes.updateIncome(updatedIncome, 26);

  if (success) {
    List<Income>? incomes = await Incomes.fetchIncomes();
    if (incomes != null) {
      for (var income in incomes) {
        print("title ${income.title}");
        print("id ${income.id}");
        print("amount ${income.amount}");
      }
    }
  }
}
