import 'dart:convert';

import 'package:flutter_frontend/config/AppConfig.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TransactionHistory.dart';

class TransactionHistories{
  final List<TransactionHistory> transactionHistories;
  
  TransactionHistories({required this.transactionHistories});
  
  factory TransactionHistories.fromJson(List<dynamic> jsonList){
    List<TransactionHistory> transactionsList = jsonList.map((json) => TransactionHistory.fromJson(json)).toList();
    return TransactionHistories(transactionHistories: transactionsList);
  }
  
  static Future<List<TransactionHistory>?> fetchTransactions() async{
    final url = Uri.parse(AppConfig.transactionsEndPoint);
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
          print("transactions: ${response.body}");
          List<dynamic> data = jsonDecode(response.body);
          return data.map((transaction) => TransactionHistory.fromJson(transaction)).toList();
        }else{
          print("transactions fetching error ${response.body}");
        }
      }catch(e){
        print("transaction exception ${e}");
      }
    }
  }

  static Future<List<TransactionHistory>?> fetchMonthTransactions() async{
    final url = Uri.parse(AppConfig.transactionsEndPoint).replace(queryParameters: {
      'period': "month",
    });

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
          print("transactions: ${response.body}");
          List<dynamic> data = jsonDecode(response.body);
          return data.map((transaction) => TransactionHistory.fromJson(transaction)).toList();
        }else{
          print("transactions fetching error ${response.body}");
        }
      }catch(e){
        print("transaction exception ${e}");
      }
    }
  }

  static Future<String?> addTransaction(Map<String, dynamic> newTransaction, String transactionType) async{
    String url = "";
    if(transactionType == "expense"){
      url = AppConfig.expenseTransactionsEndPoint;
    }
    if(transactionType == 'saving'){
      url = AppConfig.savingTransactionsEndPoint;
    }
    if(transactionType == "income"){
      url = AppConfig.incomeTransactionEndPoint;
    }

    Map<String, dynamic> filteredExpense = newTransaction..removeWhere((key, value) => value == null);
    String status = '';

    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if(userId!=null){
      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'user-id': userId,
            'Content-Type': 'application/json',
          },
          body: jsonEncode(filteredExpense),
        );

        if (response.statusCode == 200) {
          status = "success";
        }else{
          print(response.body);
          final errorMessage = jsonDecode(response.body);
          String message = errorMessage['message'];
          print(message);
          status = message;

        }
      } catch (e) {
        print("Error adding expense: $e");
        status =  "something went wrong, try later";
      }
      return status;
    }
  }

  static Future<String?> deleteTransaction(int id) async{

    String url = "${AppConfig.transactionsEndPoint}/$id";
    String status = '';
    
    try{
      final response = await http.delete(Uri.parse(url));
      
      if(response.statusCode == 200){
        status = "success";
        print("transaction successfully deleted");
      }else{
        print("error with deleting transaction ${response.body}");
        final errorMessage = jsonDecode(response.body);
        String message = errorMessage['message'];
        status = message;
      }
    }catch(e){
      print("error with deleting transaction $e");
    }
    return status;
  }

  static Future<String?> updateTransaction(Map<String, dynamic> updatedTransaction, int id) async{
    String status = '';
    Map<String, dynamic> filteredTransaction = updatedTransaction..removeWhere((key, value) => value == null);

    String url = "${AppConfig.transactionsEndPoint}/$id";
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if(userId!=null){
      try{
        final response = await http.put(Uri.parse(url),
            headers: {
              'user-id': userId,
              'Content-Type': 'application/json',
            },
            body: jsonEncode(filteredTransaction)
        );

        if(response.statusCode == 200){
          status = 'success';
          print("transaction updated");
        }else{
          print("error updating transaction ${response.body}");
          final errorMessage = jsonDecode(response.body);
          String message = errorMessage['message'];
          status = message;
        }
      }catch(e){
        print("exception caught for transaction update $e");
      }
    }

    return status;
  }

  static Future<List<TransactionHistory>?> fetchTransactionsByType(String type) async{
    String transactionType = type.toUpperCase();
    final url = Uri.parse(AppConfig.transactionsEndPoint).replace(queryParameters: {"type": transactionType});
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
          // print("transactions: ${response.body}");
          List<dynamic> data = jsonDecode(response.body);
          return data.map((transaction) => TransactionHistory.fromJson(transaction)).toList();
        }else{
          print("transactions fetching error ${response.body}");
        }
      }catch(e){
        print("transaction exception ${e}");
      }
    }
  }
}

void main() async{

  List<TransactionHistory>? monthTransactions = await TransactionHistories.fetchMonthTransactions();
  if(monthTransactions!=null){
    for(var tr in monthTransactions){
      print(tr.type);
      print(tr.amount);
      print(tr.createdAt);
    }
  }
  // // Map<String, dynamic> expenseTransaction = {"expenseId": 15, "amount": 5.6};
  // // bool success = await TransactionHistories.addTransaction(expenseTransaction, "expense");
  // // Map<String, dynamic> savingtransaction = {"savingId": 2, "amount": 145.3};
  // // bool success = await TransactionHistories.addTransaction(savingtransaction, "saving");
  //
  // // bool success = await TransactionHistories.deleteTransaction(27);
  // //
  // // if(success) {
  // // Предполагаем, что вы получаете список транзакций
  // var formatter = DateFormat('dd MMM yyyy'); // Исходный формат даты
  // var outputFormatter = DateFormat('dd.MM.yyyy'); // Требуемый формат
  //
  // // Получаем транзакции из вашего метода
  // List<TransactionHistory>? transactions = await TransactionHistories.fetchTransactionsByType("expense");
  //
  // // Список для хранения обновленных данных
  // List<Map<String, dynamic>> updatedData = [];
  //
  // if (transactions != null) {
  //   // Преобразуем данные в список Map с обновленными датами
  //   updatedData = transactions.map((tr) {
  //     // Парсим исходную дату и форматируем ее в нужный вид
  //     String originalDate = tr.createdAt; // Исходная дата из объекта TransactionHistory
  //     DateTime parsedDate = formatter.parse(originalDate); // Парсим строку в DateTime
  //     String formattedDate = outputFormatter.format(parsedDate); // Преобразуем в новый формат
  //
  //     // Возвращаем новый Map с обновленной датой
  //     return {
  //       'ID': tr.id,
  //       'Amount': tr.amount,
  //       'type': tr.type,
  //       'created date': formattedDate, // Обновленная дата
  //     };
  //   }).toList();
  //
  //   // Передаем обновленные данные в другой класс для визуализации
  // }
  //
  // // Выводим обновленные данные в консоль
  // updatedData.sort((a, b) => a['ID'].compareTo(b['ID']));
  // print(updatedData);
}