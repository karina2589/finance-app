abstract class ExpenseEvent{}

//initial expenses events
class ExpenseInitialEvent extends ExpenseEvent{}
class LoadExpenseEvent extends ExpenseEvent{}

//events for expense changing
class AddExpenseEvent extends ExpenseEvent{
  final Map<String, dynamic> newExpense;
  AddExpenseEvent({required this.newExpense});
}

class UpdateExpenseEvent extends ExpenseEvent{
  final int expenseId;
  final Map<String, dynamic> updatedExpense;
  UpdateExpenseEvent({required this.expenseId, required this.updatedExpense});
}

class DeleteExpenseEvent extends ExpenseEvent{
  final int expenseId;
  DeleteExpenseEvent({required this.expenseId});
}