abstract class IncomeEvent{}

//initial income event
class IncomeInitialEvent extends IncomeEvent{}
//load income is for updating values after changing operations
class LoadIncomeEvent extends IncomeEvent{}

// events for incomes changing
class AddIncomeEvent extends IncomeEvent{
  final Map<String, dynamic> newIncome;
  AddIncomeEvent({required this.newIncome});
}

class UpdateIncomeEvent extends IncomeEvent{
  final int incomeId;
  final Map<String, dynamic> updatedIncome;
  UpdateIncomeEvent({required this.incomeId, required this.updatedIncome});
}

class DeleteIncomeEvent extends IncomeEvent{
  final int incomeId;
  DeleteIncomeEvent({required this.incomeId});
}

