import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/bloc/savings_bloc/savings_bloc.dart';
import 'package:flutter_frontend/bloc/savings_bloc/savings_event.dart';
import 'package:flutter_frontend/bloc/savings_bloc/savings_state.dart';
import 'package:flutter_frontend/bloc/savings_transacrtions_bloc/savings_transactions_event.dart';
import 'package:flutter_frontend/bloc/savings_transacrtions_bloc/savings_transactions_state.dart';
import 'package:flutter_frontend/jsonModels/Saving.dart';
import 'package:flutter_frontend/jsonModels/Savings.dart';

import '../../jsonModels/BankCard.dart';
import '../../jsonModels/BankCards.dart';
import '../../jsonModels/TransactionHistories.dart';

class SavingTransactionBloc extends Bloc<SavingsTransactionEvent, SavingsTransactionState>{
  late final StreamSubscription savingBlocSubscription;

  SavingTransactionBloc(SavingBloc savingBloc): super(SavingTransactionInitialState()){
    savingBlocSubscription = savingBloc.stream.listen((savingState){
      if(savingState is SavingsLoadedState){
        print("SavingsBloc изменился → обновляем карточки");
        add(LoadSavingsTransactionEvent());
      }
    });
    on<LoadSavingsTransactionEvent>((event, emit) async{
      emit(SavingTransactionLoadingState());
      try{
        final List<Saving>? savings = await Savings.fetchSavings();
        final List<BankCard>? cards = await BankCards.fetchCards();

        if(savings == null || savings.isEmpty){
          emit(SavingTransactionEmptyState());
        }else{
          emit(SavingTransactionLoadedState(saving: savings, cards: cards));
        }
      }catch(e){
        emit(SavingTransactionLoadingErrorState());
      }
    });
    on<AddSavingsTransactionEvent>((event, emit) async{
      //emit(ExpenseLoadingState());
      try{
        bool success = await TransactionHistories.addTransaction(event.newSavingTransaction, "saving");
        if(success){
          emit(SavingTransactionUpdatedState());
          add(LoadSavingsTransactionEvent());
        }
      }catch(e){
        emit(SavingTransactionLoadingErrorState());
      }
    });
    on<UpdateSavingsTransactionEvent>((event, emit) async{
      // emit(ExpenseLoadingState());
      try{
        bool success = await TransactionHistories.updateTransaction(event.updatedSavingTransaction, event.savingId);
        if(success){
          emit(SavingTransactionUpdatedState());
          add(LoadSavingsTransactionEvent());
        }
      }catch(e){
        emit(SavingTransactionLoadingErrorState());
      }
    });
    on<DeleteSavingsTransactionEvent>((event, emit) async{
      // emit(ExpenseLoadingState());
      try{
        bool success = await TransactionHistories.deleteTransaction(event.savingTransactionId);
        if(success){
          emit(SavingTransactionUpdatedState());
          add(LoadSavingsTransactionEvent());
        }
      }catch(e){
        emit(SavingTransactionLoadingErrorState());
      }
    });
  }
}