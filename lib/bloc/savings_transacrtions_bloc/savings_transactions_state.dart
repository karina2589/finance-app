import 'package:equatable/equatable.dart';
import 'package:flutter_frontend/jsonModels/BankCard.dart';
import 'package:flutter_frontend/jsonModels/Saving.dart';

abstract class SavingsTransactionState extends Equatable{
  @override
  List<Object> get props => [];
}
class SavingTransactionLoadingState extends SavingsTransactionState{}

class SavingTransactionLoadedState extends SavingsTransactionState{
  final List<Saving>? saving;
  final List<BankCard>? cards;
  SavingTransactionLoadedState({required this.saving, required this.cards});
}

class SavingTransactionLoadingErrorState extends SavingsTransactionState{}
class SavingTransactionInitialState extends SavingsTransactionState{}
class SavingTransactionEmptyState extends SavingsTransactionState{}
class SavingTransactionUpdatedState extends SavingsTransactionState{}

class SavingTransactionsErrorMessageState extends SavingsTransactionState{
  final String message;
  SavingTransactionsErrorMessageState({required this.message});
}
