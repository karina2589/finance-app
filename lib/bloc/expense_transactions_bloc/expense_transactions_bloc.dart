import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/bloc/expense_transactions_bloc/expense_transactions_event.dart';
import 'package:flutter_frontend/bloc/expense_transactions_bloc/expense_transactions_state.dart';
import 'package:flutter_frontend/bloc/expenses_bloc/expense_bloc.dart';
import 'package:flutter_frontend/bloc/expenses_bloc/expense_state.dart';
import 'package:flutter_frontend/jsonModels/TransactionHistories.dart';

import '../../jsonModels/BankCard.dart';
import '../../jsonModels/BankCards.dart';
import '../../jsonModels/Expense.dart';
import '../../jsonModels/Expenses.dart';

class ExpenseTransactionBloc extends Bloc<ExpenseTransactionEvent, ExpenseTransactionState>{
  late final StreamSubscription expenseBlocSubscription;

  ExpenseTransactionBloc(ExpenseBloc expenseBloc) : super(ExpenseTransactionInitialState()){

    expenseBlocSubscription = expenseBloc.stream.listen((expenseState){
      if(expenseState is ExpenseLoadedState){
        print("ExpenseBloc изменился → обновляем карточки");
        add(LoadExpenseTransactionEvent());
      }
    });

    on<LoadExpenseTransactionEvent>((event, emit) async{
      emit(ExpenseTransactionLoadingState());
      try{
        final List<Expense>? expenses = await Expenses.fetchExpenses();
        final List<BankCard>? cards = await BankCards.fetchCards();

        if(expenses == null || expenses.isEmpty){
          emit(ExpenseTransactionEmptyState());
        }else{
          emit(ExpenseTransactionLoadedState(expenses: expenses, cards: cards));
        }
      }catch(e){
        emit(ExpenseTransactionLoadingErrorState());
      }
    });
    on<AddExpenseTransactionEvent>((event, emit) async{
      //emit(ExpenseLoadingState());
      try{
        bool success = await TransactionHistories.addTransaction(event.newExpenseTransaction, "expense");
        if(success){
          emit(ExpenseTransactionUpdatedState());
          add(LoadExpenseTransactionEvent());
        }
      }catch(e){
        emit(ExpenseTransactionLoadingErrorState());
      }
    });
    on<UpdateExpenseTransactionEvent>((event, emit) async{
      // emit(ExpenseLoadingState());
      try{
        bool success = await TransactionHistories.updateTransaction(event.updatedExpenseTransaction, event.expenseId);
        if(success){
          emit(ExpenseTransactionUpdatedState());
          add(LoadExpenseTransactionEvent());
        }
      }catch(e){
        emit(ExpenseTransactionLoadingErrorState());
      }
    });
    on<DeleteExpenseTransactionEvent>((event, emit) async{
      // emit(ExpenseLoadingState());
      try{
        bool success = await TransactionHistories.deleteTransaction(event.expenseTransactionId);
        if(success){
          emit(ExpenseTransactionUpdatedState());
          add(LoadExpenseTransactionEvent());
        }
      }catch(e){
        emit(ExpenseTransactionLoadingErrorState());
      }
    });
  }
}