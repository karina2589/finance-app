import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/bloc/income_bloc/income_event.dart';
import 'package:flutter_frontend/bloc/income_bloc/income_state.dart';
import 'package:flutter_frontend/jsonModels/BankCard.dart';
import 'package:flutter_frontend/jsonModels/BankCards.dart';
import 'package:flutter_frontend/jsonModels/Incomes.dart';

import '../../jsonModels/Income.dart';

class IncomeBloc extends Bloc<IncomeEvent, IncomeState>{
  IncomeBloc(): super(IncomeInitialState()){
    on<LoadIncomeEvent>((event, emit) async{
      print("LoadIncomeEvent triggered");
      emit(IncomeLoadingState());
      try{
        final List<Income>? incomes = await Incomes.fetchIncomes();
        final List<BankCard>? cards = await BankCards.fetchCards();
        if(incomes == null || incomes.isEmpty){
          emit(IncomeEmptyState());
        }else {
          print("Emitting IncomeLoadedState with ${incomes.length} incomes");
          emit(IncomeLoadedState(incomes: incomes, cards:  cards));
        }
      }catch(e){
        emit(IncomeLoadingErrorState());
      }
    });

    on<AddIncomeEvent>((event, emit) async {
      //emit(IncomeLoadingState());
      try {
        bool success = await Incomes.addNewIncome(event.newIncome);
        if (success) {
          print("Income added successfully");
          emit(IncomeUpdatedState());
          print("Emitted: IncomeUpdatedState");
          add(LoadIncomeEvent());
        } else {
          emit(IncomeLoadingErrorState());
        }
      } catch (e) {
        emit(IncomeLoadingErrorState());
      }
    });

    on<UpdateIncomeEvent>((event, emit) async {
      try {
        bool success = await Incomes.updateIncome(event.updatedIncome, event.incomeId);
        if (success) {
          emit(IncomeUpdatedState()); // Обновляем UI
          await Future.delayed(Duration(milliseconds: 500)); // Ожидание обновления БД
          add(LoadIncomeEvent());
        } else {
          emit(IncomeLoadingErrorState());
        }
      } catch (e) {
        emit(IncomeLoadingErrorState());
      }
    });

    on<DeleteIncomeEvent>((event, emit) async {
     // emit(IncomeLoadingState());
      try {
        bool success = await Incomes.deleteIncome(event.incomeId);
        if (success) {
          emit(IncomeUpdatedState());
          await Future.delayed(Duration(milliseconds: 500));
          add(LoadIncomeEvent());
        } else {
          emit(IncomeLoadingErrorState());
        }
      } catch (e) {
        emit(IncomeLoadingErrorState());
      }
    });


  }
}