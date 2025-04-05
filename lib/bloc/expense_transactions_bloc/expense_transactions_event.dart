abstract class ExpenseTransactionEvent{}

//initial expenses events
class ExpenseTransactionInitialEvent extends ExpenseTransactionEvent{}
class LoadExpenseTransactionEvent extends ExpenseTransactionEvent{}

//events for expense changing
class AddExpenseTransactionEvent extends ExpenseTransactionEvent{
  final Map<String, dynamic> newExpenseTransaction;
  AddExpenseTransactionEvent({required this.newExpenseTransaction});
}

class UpdateExpenseTransactionEvent extends ExpenseTransactionEvent{
  final int expenseId;
  final Map<String, dynamic> updatedExpenseTransaction;
  UpdateExpenseTransactionEvent({ required this.updatedExpenseTransaction, required this.expenseId});
}

class DeleteExpenseTransactionEvent extends ExpenseTransactionEvent{
  final int expenseTransactionId;
  DeleteExpenseTransactionEvent({required this.expenseTransactionId});
}