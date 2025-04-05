import 'package:equatable/equatable.dart';
import 'package:flutter_frontend/jsonModels/BankCard.dart';

import '../../jsonModels/Income.dart';

abstract class IncomeState extends Equatable{
  @override
  List<Object> get props => [];
}

//income states
class IncomeLoadingState extends IncomeState{}

class IncomeLoadedState extends IncomeState{
  final List<Income>? incomes;
  final List<BankCard>? cards;
  IncomeLoadedState({required this.incomes, required this.cards});
}

class IncomeInitialState extends IncomeState{}

class IncomeLoadingErrorState extends IncomeState{}

class IncomeUpdatedState extends IncomeState{

}

class IncomeEmptyState extends IncomeState{}