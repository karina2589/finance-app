import 'package:equatable/equatable.dart';
import 'package:flutter_frontend/jsonModels/BankCard.dart';

abstract class CardState extends Equatable{
  @override
  List<Object> get props => [];
}

class CardLoadingState extends CardState{}
class CardEmptyState extends CardState{}
class CardInitialState extends CardState{}
class CardUpdatedState extends CardState{}
class CardLoadingErrorState extends CardState{}

class CardLoadedState extends CardState{
  final List<BankCard>? cards;
  CardLoadedState({required this.cards});
}
