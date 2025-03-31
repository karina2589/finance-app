import '../jsonModels/Expense.dart';
import '../jsonModels/Saving.dart';
import '../jsonModels/Income.dart';

abstract class BudgetingState{}

//income states
class IncomeLoadingState extends BudgetingState{}

class IncomeLoadedState extends BudgetingState{
  List<Income> incomes;
  IncomeLoadedState({required this.incomes});
}

class IncomeLoadingErrorState extends BudgetingState{}

//expense states
class ExpenseLoadingState extends BudgetingState{}

class ExpenseLoadedState extends BudgetingState{
  List<Expense> expenses;
  ExpenseLoadedState({required this.expenses});
}

class ExpenseLoadingErrorState extends BudgetingState{}

//savings states
class SavingsLoadingState extends BudgetingState{}

class SavingsLoadedState extends BudgetingState{
  List<Saving> savings;
  SavingsLoadedState({required this.savings});
}

class SavingsLoadingErrorState extends BudgetingState{}