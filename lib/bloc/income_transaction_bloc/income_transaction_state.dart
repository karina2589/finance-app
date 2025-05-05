import 'package:equatable/equatable.dart';
import 'package:flutter_frontend/jsonModels/PendingIncome.dart';

abstract class IncomeTransactionState extends Equatable{
  @override
  List<Object> get props => [];
}

class IncomeTransactionLoadingState extends IncomeTransactionState{}

class IncomeTransactionLoadedState extends IncomeTransactionState{
  final List<PendingIncome>? pendingIncomes;
  IncomeTransactionLoadedState({required this.pendingIncomes});
}

class IncomeTransactionLoadingErrorState extends IncomeTransactionState{}
class IncomeTransactionInitialState extends IncomeTransactionState{}
class IncomeTransactionEmptyState extends IncomeTransactionState{}
class IncomeTransactionUpdatedState extends IncomeTransactionState{}
class IncomeTransactionErrorMessageState extends IncomeTransactionState{
  final String message;
  IncomeTransactionErrorMessageState({required this.message});
}