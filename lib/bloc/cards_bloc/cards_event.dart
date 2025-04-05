abstract class CardEvent{}

class CardInitialEvent extends CardEvent{}
class LoadCardEvent extends CardEvent{}
class AddCardEvent extends CardEvent{
  final String cardName;
  AddCardEvent({required this.cardName});
}

class UpdateCardEvent extends CardEvent{
  final String updatedCardName;
  final int cardId;
  UpdateCardEvent({required this.updatedCardName, required this.cardId});
}

class DeleteCardEvent extends CardEvent{
  final int cardId;
  DeleteCardEvent({required this.cardId});
}