import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/bloc/savings_bloc/savings_event.dart';
import 'package:flutter_frontend/bloc/savings_bloc/savings_state.dart';
import 'package:flutter_frontend/jsonModels/Saving.dart';
import 'package:flutter_frontend/jsonModels/Savings.dart';

class SavingBloc extends Bloc<SavingEvent, SavingState>{
  SavingBloc(): super(SavingInitialState()){
    on<LoadSavingsEvent>((event, emit) async{
      emit(SavingsLoadingState());
      try{
        final List<Saving>? savings = await Savings.fetchSavings();
        if(savings == null || savings.isEmpty){
          emit(SavingEmptyState());
        }else{
          emit(SavingsLoadedState(savings: savings));
        }
      }catch(e){
        emit(SavingsLoadingErrorState());
      }
    });
    on<AddSavingEvent>((event, emit) async{
    //  emit(SavingsLoadingState());
      try{
        bool success = await Savings.addSavings(event.newSaving);
        if(success){
          emit(SavingUpdateState());
          add(LoadSavingsEvent());
        }else{
          emit(SavingsLoadingErrorState());
        }
      }catch(e){
        emit(SavingsLoadingErrorState());
      }
    });
    on<UpdateSavingsEvent>((event, emit) async{
    //  emit(SavingsLoadingState());
      try{
        bool success = await Savings.updateSaving(event.updatedSaving, event.savingId);
        if(success){
          emit(SavingsLoadingState());
          add(LoadSavingsEvent());
        }else{
          emit(SavingsLoadingErrorState());
        }
      }catch(e){
        emit(SavingsLoadingErrorState());
      }
    });
    on<DeleteSavingEvent>((event, emit) async{
      //emit(SavingsLoadingState());
      try{
        bool success = await Savings.deleteSaving(event.savingId);
        if(success){
          emit(SavingsLoadingState());
          add(LoadSavingsEvent());
        }else{
          emit(SavingsLoadingErrorState());
        }
      }catch(e){
        emit(SavingsLoadingErrorState());
      }
    });
  }
}