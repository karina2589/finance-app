abstract class IncomeTransactionEvent{}

class IncomeTransactionInitialEvent extends IncomeTransactionEvent{}
class LoadIncomeTransactionEvent extends IncomeTransactionEvent{}

class AddIncomeTransactionEvent extends IncomeTransactionEvent{
  final Map<String, dynamic> newIncomeTransaction;
  AddIncomeTransactionEvent({required this.newIncomeTransaction});
}
