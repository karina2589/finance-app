abstract class SavingEvent{}

//initial savings events
class SavingsInitialEvent extends SavingEvent{}
class LoadSavingsEvent extends SavingEvent{}

//events for savings changing
class AddSavingEvent extends SavingEvent{
  final Map<String, dynamic> newSaving;
  AddSavingEvent({required this.newSaving});
}

class UpdateSavingsEvent extends SavingEvent{
  final int savingId;
  final Map<String, dynamic> updatedSaving;
  UpdateSavingsEvent({required this.savingId, required this.updatedSaving});
}

class DeleteSavingEvent extends SavingEvent{
  final int savingId;
  DeleteSavingEvent({required this.savingId});
}

