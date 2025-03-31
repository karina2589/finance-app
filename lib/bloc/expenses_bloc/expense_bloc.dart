import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/bloc/expenses_bloc/expense_event.dart';
import 'package:flutter_frontend/bloc/expenses_bloc/expense_state.dart';
import 'package:flutter_frontend/jsonModels/Expense.dart';
import 'package:flutter_frontend/jsonModels/Expenses.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState>{
  ExpenseBloc(): super(ExpenseInitialState()){
    on<LoadExpenseEvent>((event, emit) async{
      emit(ExpenseLoadingState());
      try{
        final List<Expense>? expenses = await Expenses.fetchExpenses();
        if(expenses == null || expenses.isEmpty){
          emit(ExpenseEmptyState());
        }else{
          emit(ExpenseLoadedState(expenses: expenses));
        }
      }catch(e){
        emit(ExpenseLoadingErrorState());
      }
    });
    on<AddExpenseEvent>((event, emit) async{
      //emit(ExpenseLoadingState());
      try{
        bool success = await Expenses.addExpense(event.newExpense);
        if(success){
          emit(ExpenseUpdatedState());
          add(LoadExpenseEvent());
        }
      }catch(e){
        emit(ExpenseLoadingErrorState());
      }
    });
    on<UpdateExpenseEvent>((event, emit) async{
     // emit(ExpenseLoadingState());
      try{
        bool success = await Expenses.updateExpense(event.expenseId,event.updatedExpense);
        if(success){
          emit(ExpenseUpdatedState());
          add(LoadExpenseEvent());
        }
      }catch(e){
        emit(ExpenseLoadingErrorState());
      }
    });
    on<DeleteExpenseEvent>((event, emit) async{
     // emit(ExpenseLoadingState());
      try{
        bool success = await Expenses.deleteExpense(event.expenseId);
        if(success){
          emit(ExpenseUpdatedState());
          add(LoadExpenseEvent());
        }
      }catch(e){
        emit(ExpenseLoadingErrorState());
      }
    });
  }
}