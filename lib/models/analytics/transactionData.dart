import 'package:intl/intl.dart';
import '../../jsonModels/TransactionHistories.dart';
import '../../jsonModels/TransactionHistory.dart';

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
  return updatedData;
 }
}
