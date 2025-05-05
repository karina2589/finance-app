import 'package:equatable/equatable.dart';
import 'package:flutter_frontend/jsonModels/BankCard.dart';

import '../../jsonModels/Expense.dart';

abstract class ExpenseTransactionState extends Equatable{
  @override
  List<Object> get props => [];
}
class ExpenseTransactionLoadingState extends ExpenseTransactionState{}

class ExpenseTransactionLoadedState extends ExpenseTransactionState{
  final List<Expense>? expenses;
  final List<BankCard>? cards;
  ExpenseTransactionLoadedState({required this.expenses, required this.cards});
}

class ExpenseTransactionLoadingErrorState extends ExpenseTransactionState{}
class ExpenseTransactionInitialState extends ExpenseTransactionState{}
class ExpenseTransactionEmptyState extends ExpenseTransactionState{}
class ExpenseTransactionUpdatedState extends ExpenseTransactionState{}
class ExpenseTransactionErrorMessageState extends ExpenseTransactionState{
  final String message;
  ExpenseTransactionErrorMessageState({required this.message});
}
class ExpenseTransactionClearErrorState extends ExpenseTransactionState{}