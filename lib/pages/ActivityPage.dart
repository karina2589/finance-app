import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/bloc/expense_transactions_bloc/expense_transactions_bloc.dart';
import 'package:flutter_frontend/bloc/expense_transactions_bloc/expense_transactions_event.dart';
import 'package:flutter_frontend/bloc/expense_transactions_bloc/expense_transactions_state.dart';
import 'package:flutter_frontend/bloc/savings_transacrtions_bloc/savings_transactions_bloc.dart';
import 'package:flutter_frontend/bloc/savings_transacrtions_bloc/savings_transactions_event.dart';
import 'package:flutter_frontend/bloc/savings_transacrtions_bloc/savings_transactions_state.dart';
import 'package:flutter_frontend/jsonModels/BankCard.dart';
import 'package:flutter_frontend/jsonModels/BankCards.dart';
import 'package:flutter_frontend/jsonModels/Expense.dart';
import 'package:flutter_frontend/jsonModels/Expenses.dart';
import 'package:flutter_frontend/jsonModels/Saving.dart';
import 'package:flutter_frontend/jsonModels/Savings.dart';
import 'package:flutter_frontend/jsonModels/TransactionHistories.dart';
import 'package:google_fonts/google_fonts.dart';

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       body: ActivityPage(),
//     ),
//   ));
// }

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  TextEditingController expensesCardNameController = TextEditingController();
  TextEditingController expenseAmountController = TextEditingController();

  List<Expense>? expenses = [];
  List<Saving>? savings = [];
  List<BankCard>? cards = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ExpenseTransactionBloc>().add(LoadExpenseTransactionEvent());
    context.read<SavingTransactionBloc>().add(LoadSavingsTransactionEvent());

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Align(
              alignment: Alignment.centerLeft, // Выравнивает влево
              child: Text(
                "My Spendings",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  // fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          _displayExpenseTransactionBloc(
            context,
            "No expenses yet. Please plan you expenses on the BUDGETING PAGE",
            Icons.shopping_cart_outlined,
          ),
          // _displayListTile(
          //     context,
          //     "No expenses yet. Please plan you expenses on the BUDGETING PAGE",
          //     Icons.shopping_cart_outlined,
          //     expenses,
          //     _listOfExpenseProgress()),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Align(
              alignment: Alignment.centerLeft, // Выравнивает влево
              child: Text(
                "My Savings",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  // fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          _displaySavingTransactionBloc(
              context,
              "No savings yet. Please plan you savings on the BUDGETING PAGE",
              Icons.savings,
              ),
        ],
      ),
    );
  }

  Widget _displayExpenseTransactionBloc(BuildContext context, String noInfoYet1,
      IconData icon){
    return BlocListener<ExpenseTransactionBloc, ExpenseTransactionState>(
        listener: (context, state) {
      print("State changed: $state");
      if (state is ExpenseTransactionLoadedState) {
        setState(() {});  // Принудительное обновление UI
      }
    },
    child: BlocBuilder<ExpenseTransactionBloc, ExpenseTransactionState>(
    builder: (context, state){
      if(state is ExpenseTransactionLoadingState){
        return Center(child: CircularProgressIndicator());
      }else if (state is ExpenseTransactionEmptyState) {
        return Center(
          child: SizedBox(
            width: double.infinity, // Растягивает Column на всю ширину
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Icon(icon, size: 50, color: Colors.grey),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    noInfoYet1,
                    textAlign: TextAlign.center, // Центрируем сам текст
                    style: GoogleFonts.inder(fontSize: 18, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if(state is ExpenseTransactionLoadedState){
        //print("Rendering UI with incomes: ${state.incomes}");
        return _listOfExpenseProgress(state.expenses, state.cards);
      }
      else{
        return Text("error");
      }
    }
    )
    );
  }
  Widget _displaySavingTransactionBloc(BuildContext context, String noInfoYet1,
      IconData icon){
    return BlocListener<SavingTransactionBloc, SavingsTransactionState>(
        listener: (context, state) {
          print("State changed: $state");
          if (state is SavingTransactionLoadedState) {
            setState(() {});  // Принудительное обновление UI
          }
        },
        child: BlocBuilder<SavingTransactionBloc, SavingsTransactionState>(
            builder: (context, state){
              if(state is SavingTransactionLoadingState){
                return Center(child: CircularProgressIndicator());
              }else if (state is SavingTransactionEmptyState) {
                return Center(
                  child: SizedBox(
                    width: double.infinity, // Растягивает Column на всю ширину
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Icon(icon, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Text(
                            noInfoYet1,
                            textAlign: TextAlign.center, // Центрируем сам текст
                            style: GoogleFonts.inder(fontSize: 18, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if(state is SavingTransactionLoadedState){
                //print("Rendering UI with incomes: ${state.incomes}");
                return _listOfSavingProgress(state.saving, state.cards);
              }
              else{
                return Text("error");
              }
            }
        )
    );
  }


  Widget _listOfExpenseProgress(List<Expense>? expenses, List<BankCard>? cards) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: expenses?.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: ()=> _showSpendingTransactionDialog(expenses![index], expenses![index].id, cards),
          child: _linearProgressIndicator(
              expenses?[index].amount ?? 0.0,
              expenses?[index].usedAmount ?? 0.0,
              expenses?[index].title ?? "",
              expenses?[index].category),
        );
      },
    );
  }

  Widget _listOfSavingProgress(List<Saving>? savings, List<BankCard>? cards) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: savings?.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: ()=> _showSpendingTransactionDialog(savings![index], savings[index].id, cards),
          child: _linearProgressIndicator(
              savings?[index].targetAmount ?? 0.0,
              savings?[index].savedAmount ?? 0.0,
              savings?[index].title ?? "",
              null),
        );
      },
    );
  }

  void _showSpendingTransactionDialog(Object item, int id, List<BankCard>? cards) {
    // Очищаем контроллер перед открытием окна
    expenseAmountController.clear();

    String title = "";
    double targetAmount = 0.0;
    double usedAmount = 0.0;

    //обработка как сбережений так и расходов
    if (item is Expense){
      title = item.title;
      targetAmount = item.amount;
      usedAmount = item.usedAmount;
    }else if(item is Saving){
      title = item.title;
      targetAmount = item.targetAmount;
      usedAmount = item.savedAmount ?? 0.0;
    }else{
      return;
    }

    // Создаем список карт (проверяем на null)
    Map<int, String> cardsWithNames = {
      for (var card in cards ?? []) card.id: card.title
    };
    print(cardsWithNames);
    List<String>? cardsName = cards?.map((card) => card.title).toList();
    print(cardsName);

    // Переменные, которые будут создаваться заново при каждом открытии окна
    String? selectedCardName;
    int? selectedCardId;

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add "${title}" Transaction',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 15),

                  // Поле ввода суммы
                  _textField(expenseAmountController, "Amount", TextInputType.number),
                  SizedBox(height: 10),

                  // Выпадающий список карт
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Card Name",
                        style: GoogleFonts.poppins(color: Colors.black, fontSize: 17),
                      ),
                      DropdownButton<String>(
                        dropdownColor: Colors.white,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        hint: Text("Select a card"),
                        value: selectedCardName, // Теперь значение сбрасывается при каждом новом вызове диалога
                        items: cardsName?.map((card) {
                          return DropdownMenuItem(
                            value: card,
                            child: Text(card),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCardName = value;
                            selectedCardId = cardsWithNames.entries
                                .firstWhere((entry) => entry.value == value)
                                .key;
                          });
                        },
                      ),
                    ],
                  ),

                  // Кнопка добавления транзакции
                  ElevatedButton(
                    onPressed: () async {
                      final rawInput = expenseAmountController.text.trim();
                      final normalizedInput = rawInput.replaceAll(',', '.');

                      if(item is Expense){

                        if (expenseAmountController.text.isNotEmpty && selectedCardId != null) {
                          Map<String, dynamic> newExpenseTransaction = {
                            "amount": double.tryParse(normalizedInput) ?? 0.0,
                            "expenseId": id,
                            "cardId": selectedCardId // добавляем ID карты в транзакцию
                          };
                          context.read<ExpenseTransactionBloc>().add(AddExpenseTransactionEvent(newExpenseTransaction: newExpenseTransaction));
                          Navigator.pop(context); // Закрываем диалог после успешного добавления
                        }
                      }else if(item is Saving){
                        if (expenseAmountController.text.isNotEmpty && selectedCardId != null) {
                          Map<String, dynamic> newSavingTransaction = {
                            "amount": double.tryParse(normalizedInput) ?? 0.0,
                            "savingId": id,
                            "cardId": selectedCardId // добавляем ID карты в транзакцию
                          };
                          context.read<SavingTransactionBloc>().add(AddSavingsTransactionEvent(newSavingTransaction: newSavingTransaction));
                          Navigator.pop(context); // Закрываем диалог после успешного добавления
                        }
                      }
                    },
                    child: Text("Add Transaction"),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Widget _linearProgressIndicator(
      double targetValue, double actualValue, String target, String? category) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        padding: EdgeInsets.all(10),
        height: 100,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(target,
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w400)),
                  Text(category?.toLowerCase() ?? "",
                      style: GoogleFonts.poppins(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                ]),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "\$ $actualValue",
                        style: GoogleFonts.poppins(
                          color: Colors.black, // Different color
                          fontSize: 16,
                          fontWeight: FontWeight.w500, // Bold for emphasis
                        ),
                      ),
                      TextSpan(
                        text: " / ",
                        style: GoogleFonts.poppins(
                          color: Colors.black, // Default color
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: "$targetValue",
                        style: GoogleFonts.poppins(
                          color: Colors.black, // Different color for target
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: LinearProgressIndicator(
                value: actualValue / targetValue,
                color: Colors.green,
                backgroundColor: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                minHeight: 5,
              ),
            )
          ],
        ));
  }
  Widget _textField(
      TextEditingController controller, String title, TextInputType type) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 38,
      child: TextField(
          keyboardType: type,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          controller: controller,
          style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              // Reduce height

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.grey.shade500,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.grey.shade700,
                ),
              ),
              labelText: title,
              labelStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey))),
    );
  }

}
