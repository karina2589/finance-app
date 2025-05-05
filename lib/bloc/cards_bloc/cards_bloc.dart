import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/bloc/cards_bloc/cards_event.dart';
import 'package:flutter_frontend/bloc/cards_bloc/cards_state.dart';
import 'package:flutter_frontend/bloc/expense_transactions_bloc/expense_transactions_bloc.dart';
import 'package:flutter_frontend/bloc/expense_transactions_bloc/expense_transactions_state.dart';
import 'package:flutter_frontend/bloc/income_bloc/income_event.dart';
import 'package:flutter_frontend/bloc/income_transaction_bloc/income_transaction_bloc.dart';
import 'package:flutter_frontend/bloc/income_transaction_bloc/income_transaction_state.dart';
import 'package:flutter_frontend/bloc/savings_transacrtions_bloc/savings_transactions_bloc.dart';
import 'package:flutter_frontend/bloc/savings_transacrtions_bloc/savings_transactions_state.dart';
import 'package:flutter_frontend/jsonModels/BankCard.dart';
import 'package:flutter_frontend/jsonModels/BankCards.dart';

import '../income_bloc/income_state.dart';

class CardBloc extends Bloc<CardEvent, CardState>{
  late final StreamSubscription incomeTransactionBlocSubscription; // Подписка на доходы
  late final StreamSubscription expenseTransactionBlocSubscription;
  late final StreamSubscription savingTransactionBlocSubscription;

  CardBloc(IncomeTransactionBloc incomeTransactionBloc, ExpenseTransactionBloc expenseTransactionBloc, SavingTransactionBloc savingTransactionBloc) : super(CardInitialState()) {
    incomeTransactionBlocSubscription = incomeTransactionBloc.stream.listen((incomeState) {
      if (incomeState is IncomeTransactionUpdatedState) {
        print("IncomeTransactionBloc изменился → обновляем карточки");
        add(LoadCardEvent());
      }
    });

    expenseTransactionBlocSubscription = expenseTransactionBloc.stream.listen((expenseTransactionState){
      if( expenseTransactionState is ExpenseTransactionLoadedState){
        print("ExpenseTransactionBloc изменился → обновляем карточки");
        add(LoadCardEvent());
      }
    });

    savingTransactionBlocSubscription = savingTransactionBloc.stream.listen((savingTransactionState){
      if(savingTransactionState is SavingTransactionLoadedState){
        print("SavingTransactionBloc изменился → обновляем карточки");
        add(LoadCardEvent());
      }
    });
    on<LoadCardEvent>((event, emit) async{
      print("Load Card event is triggered");
      emit(CardLoadingState());
      try{
        final List<BankCard>? cards = await BankCards.fetchCards();
        if(cards == null || cards.isEmpty){
          emit(CardEmptyState());
        }else{
          print("emmiting cards loaded state");
          emit(CardLoadedState(cards: cards));
        }
      }catch(e){
        emit(CardLoadingState());
      }
    });

    on<AddCardEvent>((event, emit) async {
      //emit(IncomeLoadingState());
      try {
        bool success = await BankCards.addCard(event.cardName);
        if (success) {
          print("Income added successfully");
          emit(CardUpdatedState());
          print("Emitted: CardUpdatedState");
          add(LoadCardEvent());
        } else {
          emit(CardLoadingState());
        }
      } catch (e) {
        emit(CardLoadingErrorState());
      }
    });

    on<UpdateCardEvent>((event, emit) async {
      try {
        bool success = await BankCards.updateCard(event.updatedCardName, event.cardId);
        if (success) {
          emit(CardLoadingState()); // Обновляем UI
          print("cards updating state");
          await Future.delayed(Duration(milliseconds: 500)); // Ожидание обновления БД
          add(LoadCardEvent());
        } else {
          emit(CardLoadingErrorState());
        }
      } catch (e) {
        emit(CardLoadingErrorState());
      }
    });

    on<DeleteCardEvent>((event, emit) async {
      // emit(IncomeLoadingState());
      try {
        bool success = await BankCards.deleteCard(event.cardId);
        if (success) {
          emit(CardLoadingState());
          print("card deleting");
          await Future.delayed(Duration(milliseconds: 500));
          add(LoadCardEvent());
        } else {
          emit(CardLoadingErrorState());
        }
      } catch (e) {
        emit(CardLoadingErrorState());
      }
    });
  }
}