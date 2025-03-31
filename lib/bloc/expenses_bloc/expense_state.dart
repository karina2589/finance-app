import 'package:equatable/equatable.dart';

import '../../jsonModels/Expense.dart';

abstract class ExpenseState extends Equatable{
  @override
  List<Object> get props => [];
}

class ExpenseLoadingState extends ExpenseState{}

class ExpenseLoadedState extends ExpenseState{
  final List<Expense>? expenses;
  ExpenseLoadedState({required this.expenses});
}

class ExpenseLoadingErrorState extends ExpenseState{}
class ExpenseInitialState extends ExpenseState{}
class ExpenseEmptyState extends ExpenseState{}
class ExpenseUpdatedState extends ExpenseState{}
