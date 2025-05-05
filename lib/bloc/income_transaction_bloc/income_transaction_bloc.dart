import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/bloc/income_bloc/income_bloc.dart';
import 'package:flutter_frontend/bloc/income_transaction_bloc/income_transaction_event.dart';
import 'package:flutter_frontend/bloc/income_transaction_bloc/income_transaction_state.dart';
import 'package:flutter_frontend/jsonModels/PendingIncome.dart';
import 'package:flutter_frontend/jsonModels/PendingIncomes.dart';
import 'package:flutter_frontend/jsonModels/TransactionHistories.dart';

import '../income_bloc/income_state.dart';

class IncomeTransactionBloc extends Bloc<IncomeTransactionEvent, IncomeTransactionState>{
  late final StreamSubscription incomeBlocSubscription;

  IncomeTransactionBloc(IncomeBloc incomeBloc) : super(IncomeTransactionInitialState()){
    incomeBlocSubscription = incomeBloc.stream.listen((incomeState){
      if(incomeState is IncomeUpdatedState){
        print("IncomeBloc изменился → обновляем карточки");
        add(LoadIncomeTransactionEvent());
      }
    });

    on<LoadIncomeTransactionEvent>((event, emit) async{
      emit(IncomeTransactionLoadingState());

      try{
        final List<PendingIncome>? pendingIncomes = await PendingIncomes.fetchPendingIncomes();
        if(pendingIncomes==null || pendingIncomes.isEmpty){
          emit(IncomeTransactionEmptyState());
        }else{
          emit(IncomeTransactionLoadedState(pendingIncomes: pendingIncomes));
        }
      }catch(e){
        emit(IncomeTransactionLoadingErrorState());
      }
    });

    on<AddIncomeTransactionEvent>((event, emit) async{
      try{
        String? success = await TransactionHistories.addTransaction(event.newIncomeTransaction, "income");
        if(success!=null){
          if(success == 'success') {
            emit(IncomeTransactionUpdatedState());
            add(LoadIncomeTransactionEvent());
          }else{
            IncomeTransactionErrorMessageState(message: success);
          }
        }
      }catch(e){
        emit(IncomeTransactionLoadingErrorState());
      }
    });
  }
}