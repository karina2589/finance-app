import 'package:equatable/equatable.dart';

import '../../jsonModels/Saving.dart';


abstract class SavingState extends Equatable{
  @override
  List<Object> get props => [];
}

//savings states
class SavingsLoadingState extends SavingState{}

class SavingsLoadedState extends SavingState{
  final List<Saving>? savings;
  SavingsLoadedState({required this.savings});
}

class SavingsLoadingErrorState extends SavingState{}
class SavingInitialState extends SavingState{}
class SavingEmptyState extends SavingState{}
class SavingUpdateState extends SavingState{}