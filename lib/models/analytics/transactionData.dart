import '../../jsonModels/TransactionHistories.dart';
import '../../jsonModels/TransactionHistory.dart';

void main() async{
  // Map<String, dynamic> expenseTransaction = {"expenseId": 15, "amount": 5.6};
  // bool success = await TransactionHistories.addTransaction(expenseTransaction, "expense");
  // Map<String, dynamic> savingtransaction = {"savingId": 2, "amount": 145.3};
  // bool success = await TransactionHistories.addTransaction(savingtransaction, "saving");

  // bool success = await TransactionHistories.deleteTransaction(27);
  //
  // if(success) {
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
      print("date: ${tr.createdAt}");
    }
    // }
  }
}