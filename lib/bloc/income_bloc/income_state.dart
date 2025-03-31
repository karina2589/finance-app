import 'package:equatable/equatable.dart';

import '../../jsonModels/Income.dart';

abstract class IncomeState extends Equatable{
  @override
  List<Object> get props => [];
}

//income states
class IncomeLoadingState extends IncomeState{}

class IncomeLoadedState extends IncomeState{
  final List<Income>? incomes;
  IncomeLoadedState({required this.incomes});
}

class IncomeInitialState extends IncomeState{}

class IncomeLoadingErrorState extends IncomeState{}

class IncomeUpdatedState extends IncomeState{

}

class IncomeEmptyState extends IncomeState{}