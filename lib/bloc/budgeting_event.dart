import 'package:equatable/equatable.dart';

abstract class BudgetingEvent{}

//initial income events
class IncomeInitialEvent extends BudgetingEvent{}
//load income is for updating values after changing operations
class LoadIncomeEvent extends BudgetingEvent{}

// events for incomes changing
class AddIncomeEvent extends BudgetingEvent{
  final Map<String, dynamic> newIncome;
  AddIncomeEvent({required this.newIncome});
}

class UpdateIncomeEvent extends BudgetingEvent{
  final int incomeId;
  final Map<String, dynamic> updatedIncome;
  UpdateIncomeEvent({required this.incomeId, required this.updatedIncome});
}

class DeleteIncomeEvent extends BudgetingEvent{
  final int incomeId;
  DeleteIncomeEvent({required this.incomeId});
}


//initial expenses events
class ExpenseInitialEvent extends BudgetingEvent{}
class LoadExpenseEvent extends BudgetingEvent{}

//events for expense changing
class AddExpenseEvent extends BudgetingEvent{
  final Map<String, dynamic> newExpense;
  AddExpenseEvent({required this.newExpense});
}

class UpdateExpenseEvent extends BudgetingEvent{
  final int expenseId;
  final Map<String, dynamic> updatedExpense;
  UpdateExpenseEvent({required this.expenseId, required this.updatedExpense});
}

class DeleteExpenseEvent extends BudgetingEvent{
  final int expenseId;
  DeleteExpenseEvent({required this.expenseId});
}


//initial savings events
class SavingsInitialEvent extends BudgetingEvent{}
class LoadSavingsEvent extends BudgetingEvent{}

//events for savings changing
class AddSavingEvent extends BudgetingEvent{
  final Map<String, dynamic> newSaving;
  AddSavingEvent({required this.newSaving});
}

class UpdateSavingsEvent extends BudgetingEvent{
  final int savingId;
  final Map<String, dynamic> updatedSaving;
  UpdateSavingsEvent({required this.savingId, required this.updatedSaving});
}

class DeleteSavingEvent extends BudgetingEvent{
  final int savingId;
  DeleteSavingEvent({required this.savingId});
}


//initial cards events
class CardInitialEvent extends BudgetingEvent{}
class LoadCardEvent extends BudgetingEvent{}

//events for cards changing
class AddCardEvent extends BudgetingEvent{
  final Map<String, dynamic> newCard;
  AddCardEvent({required this.newCard});
}

class UpdateCardEvent extends BudgetingEvent{
  final int cardId;
  final Map<String, dynamic> updatedCard;
  UpdateCardEvent({required this.cardId, required this.updatedCard});
}

class DeleteCardEvent extends BudgetingEvent{
  final int cardId;
  DeleteCardEvent({required this.cardId});
}