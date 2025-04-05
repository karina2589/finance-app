abstract class SavingsTransactionEvent{}

//initial expenses events
class SavingsTransactionInitialEvent extends SavingsTransactionEvent{}
class LoadSavingsTransactionEvent extends SavingsTransactionEvent{}

//events for expense changing
class AddSavingsTransactionEvent extends SavingsTransactionEvent{
  final Map<String, dynamic> newSavingTransaction;
  AddSavingsTransactionEvent({required this.newSavingTransaction});
}

class UpdateSavingsTransactionEvent extends SavingsTransactionEvent{
  final int savingId;
  final Map<String, dynamic> updatedSavingTransaction;
  UpdateSavingsTransactionEvent({ required this.updatedSavingTransaction, required this.savingId});
}

class DeleteSavingsTransactionEvent extends SavingsTransactionEvent{
  final int savingTransactionId;
  DeleteSavingsTransactionEvent({required this.savingTransactionId});
}