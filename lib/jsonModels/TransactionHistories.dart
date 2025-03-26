import 'dart:convert';

import 'package:flutter_frontend/config/AppConfig.dart';
import 'package:http/http.dart' as http;

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
    // final prefs = await SharedPreferences.getInstance();
    // String? userId = prefs.getString('userId');

    try{
      final response = await http.get(url,
        headers: {
          // 'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // If using authentication
          'user-id': '2cbbbf55-81f0-4475-8fe0-e29c664b6aa3',
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

  static Future<bool> addTransaction(Map<String, dynamic> newTransaction, String transactionType) async{
    String url = "";
    if(transactionType == "expense"){
      url = AppConfig.expenseTransactionsEndPoint;
    }
    if(transactionType == 'saving'){
      url = AppConfig.savingTransactionsEndPoint;
    }

    bool success  =false;
    Map<String, dynamic> filteredExpense = newTransaction..removeWhere((key, value) => value == null);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'user-id': '2cbbbf55-81f0-4475-8fe0-e29c664b6aa3',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(filteredExpense),
      );

      if (response.statusCode == 200) {
        success = true;
      }else{
        print(response.body);
      }
    } catch (e) {
      print("Error updating expense: $e");
    }

    return success;
  }

  static Future<bool> deleteTransaction(int id) async{
    String url = "${AppConfig.transactionsEndPoint}/$id";
    bool success = false;
    
    try{
      final response = await http.delete(Uri.parse(url));
      
      if(response.statusCode == 200){
        success = true;
        print("transaction successfully deleted");
      }else{
        print("error with deleting transaction ${response.body}");
      }
    }catch(e){
      print("error with deleting transaction $e");
    }
    return success;
  }

  static Future<bool> updateTransaction(Map<String, dynamic> updatedTransaction, int id) async{
    bool success = false;
    Map<String, dynamic> filteredTransaction = updatedTransaction..removeWhere((key, value) => value == null);

    String url = "${AppConfig.transactionsEndPoint}/$id";

    try{
      final response = await http.put(Uri.parse(url),
      headers: {
        'user-id': '2cbbbf55-81f0-4475-8fe0-e29c664b6aa3',
        'Content-Type': 'application/json',
      },
        body: jsonEncode(filteredTransaction)
      );

      if(response.statusCode == 200){
        success = true;
        print("transaction updated");
      }else{
        print("error updating transaction ${response.body}");
      }
    }catch(e){
      print("exception caught for transaction update $e");
    }
    return success;
  }

}

void main() async{
  // Map<String, dynamic> expenseTransaction = {"expenseId": 15, "amount": 5.6};
  // bool success = await TransactionHistories.addTransaction(expenseTransaction, "expense");
  // Map<String, dynamic> savingtransaction = {"savingId": 2, "amount": 145.3};
  // bool success = await TransactionHistories.addTransaction(savingtransaction, "saving");
  
  bool success = await TransactionHistories.deleteTransaction(27);

  if(success) {
    List<TransactionHistory>? transactions = await TransactionHistories
        .fetchTransactions();
    if (transactions != null) {
      for (var tr in transactions) {
        print("ID: ${tr.id}");
        print("Amount: ${tr.amount}");
        print("Card ID: ${tr.cardId}");
        print("Saving ID: ${tr.savingId}");
        print("Expense ID: ${tr.expenseId}");
        print("expense : ${tr.expense}");
        print("saving : ${tr.saving}");
      }
    }
  }
}