import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/bloc/cards_bloc/cards_bloc.dart';
import 'package:flutter_frontend/bloc/expenses_bloc/expense_bloc.dart';
import 'package:flutter_frontend/bloc/expenses_bloc/expense_event.dart';
import 'package:flutter_frontend/bloc/expenses_bloc/expense_state.dart';
import 'package:flutter_frontend/bloc/income_bloc/income_bloc.dart';
import 'package:flutter_frontend/bloc/income_transaction_bloc/income_transaction_bloc.dart';
import 'package:flutter_frontend/bloc/income_transaction_bloc/income_transaction_event.dart';
import 'package:flutter_frontend/bloc/income_transaction_bloc/income_transaction_state.dart';
import 'package:flutter_frontend/bloc/savings_bloc/savings_bloc.dart';
import 'package:flutter_frontend/bloc/savings_bloc/savings_event.dart';
import 'package:flutter_frontend/bloc/savings_bloc/savings_state.dart';
import 'package:flutter_frontend/jsonModels/BankCard.dart';
import 'package:flutter_frontend/jsonModels/BankCards.dart';
import 'package:flutter_frontend/jsonModels/Expense.dart';
import 'package:flutter_frontend/config/ExpenseCategories.dart';
import 'package:flutter_frontend/jsonModels/PendingIncome.dart';
import 'package:flutter_frontend/models/AppTheme.dart';
import 'package:flutter_frontend/models/BankCardSwiper.dart';
import 'package:google_fonts/google_fonts.dart';
import '../jsonModels/CardDetail.dart';
import 'package:intl/intl.dart';
import '../jsonModels/Saving.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized(); // Добавь эту строку
//   runApp(
//     MultiBlocProvider(
//         providers: [
//           BlocProvider<IncomeBloc>(create: (context) => IncomeBloc()),
//           BlocProvider<ExpenseBloc>(create: (context) => ExpenseBloc()),
//           BlocProvider<SavingBloc>(create: (context) => SavingBloc()),
//           BlocProvider<CardBloc>(
//             create: (context) => CardBloc(BlocProvider.of<IncomeBloc>(context)),
//           ),
//         ],
//         child: MaterialApp(
//           home: Scaffold(body: BudgetPlanner()),
//           theme: AppTheme.lightTheme,
//         )),
//   );
// }

class BudgetPlanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BudgetPlannerState();
}

class _BudgetPlannerState extends State<BudgetPlanner> {
  // expense controllers
  TextEditingController expenseTitleController = TextEditingController();
  TextEditingController expenseAmountController = TextEditingController();
  TextEditingController expenseDescriptionController = TextEditingController();

  //savings controllers
  TextEditingController savingTitleController = TextEditingController();
  TextEditingController savingDescriptionController = TextEditingController();
  TextEditingController savingTargetAmountController = TextEditingController();
  TextEditingController savingDueDate = TextEditingController();

  List<BankCard>? cards = [];
  List<CardDetail>? cardDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(LoadExpenseEvent());
    context.read<SavingBloc>().add(LoadSavingsEvent());
  }

  Future<void> fetchCards() async {
    List<BankCard>? cardsData = await BankCards.fetchCards();
    if (mounted) {
      setState(() {
        cards = cardsData;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //  CardSwiper(),
          BankCardSwiper(),
          Divider(
            indent: 10,
            endIndent: 10,
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Planned expenses",
                    style:
                        GoogleFonts.poppins(color: Colors.black, fontSize: 20),
                  ),
                  IconButton(
                      onPressed: () => _showExpenseDialog(),
                      //display dialog
                      //update expenses list
                      icon: Icon(Icons.add_circle_outline))
                ],
              )),
          _expenseBlocDisplay(
              context,
              "You have not budgeted your expenses yet. Click on the ",
              " icon and add an expense to your budget",
              "No Planned Payments Yet",
              Icons.payments_outlined,
             ),
          SizedBox(
            height: 20,
          ),

          Divider(
            indent: 10,
            endIndent: 10,
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Goals",
                    style:
                        GoogleFonts.poppins(color: Colors.black, fontSize: 20),
                  ),
                  IconButton(
                      onPressed: () => _showSavingsDialog(),
                      icon: Icon(Icons.add_circle_outline))
                ],
              )),
          _savingBlocDisplay(
              context,
              "You don't have any savings goal. Click on the ",
              " icon to add new saving goal",
              "No Saving Goals Yet",
              Icons.savings
             ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _expenseBlocDisplay(
      BuildContext context,
      String noInfoYet1,
      String noInfoYet2,
      String noInfoTitle,
      IconData icon,
      ) {
    return BlocListener<ExpenseBloc, ExpenseState>(
        listener: (context, state){
          print("Expense state changed: $state");
          if(state is ExpenseLoadedState){
            setState(() {});
          }
        },
      child: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state){
            if(state is ExpenseLoadingState){
              return Center(child: CircularProgressIndicator());
            }else if(state is ExpenseLoadedState){
              return _expenseDisplay(state.expenses);
            }else if(state is ExpenseEmptyState){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      "No expenses yet",
                      style: GoogleFonts.inder(fontSize: 18, color: Colors.black54),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.inder(fontSize: 16, color: Colors.black54),
                          children: [
                            TextSpan(text: noInfoYet1),
                            WidgetSpan(
                              child: Icon(Icons.add_circle_outline,
                                  size: 20, color: Colors.black54),
                            ),
                            TextSpan(text: noInfoYet2),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }else{
              return Text("Expense error");
            }
          }
      ),
    );


  }

  Widget _savingBlocDisplay(
      BuildContext context,
      String noInfoYet1,
      String noInfoYet2,
      String noInfoTitle,
      IconData icon,
      ) {
    return BlocListener<SavingBloc, SavingState>(
      listener: (context, state){
        print("Expense state changed: $state");
        if(state is SavingsLoadedState){
          setState(() {});
        }
      },
      child: BlocBuilder<SavingBloc, SavingState>(
          builder: (context, state){
            if(state is SavingsLoadingState){
              return Center(child: CircularProgressIndicator(color: Colors.black));
            }else if(state is SavingsLoadedState){
              return _savingsDisplayRounded(state.savings);
            }else if(state is SavingEmptyState){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      "No savings yet",
                      style: GoogleFonts.poppins(fontSize: 18, color: Colors.black54),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
                          children: [
                            TextSpan(text: noInfoYet1),
                            WidgetSpan(
                              child: Icon(Icons.add_circle_outline,
                                  size: 20, color: Colors.black54),
                            ),
                            TextSpan(text: noInfoYet2),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }else{
              return Text("Savings error");
            }
          }
      ),
    );


  }

  Widget _expenseDisplay(List<Expense>? expenses) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: expenses?.length,
      itemBuilder: (context, index) {
        Map<String, IconData> expenseIcons = ExpenseCategories.expenseIcons;
        IconData? iconToChoose =
            expenseIcons[expenses?[index].category?.toLowerCase().trim()];

        return GestureDetector(
            onTap: () => _showExpenseDialog(
                expense: expenses?[index], id: expenses?[index].id),
            child: ListTile(
              leading: Container(
                width: 45, // Размер квадрата
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100, // Белый фон
                  borderRadius:
                      BorderRadius.circular(8), // Можно сделать мягкие углы
                ),
                child: Icon(
                  iconToChoose,
                  color: Colors.black, // Синий цвет иконки
                  size: 24,
                ),
              ),
              title: Text(
                "${expenses?[index].title}",
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
              subtitle: Text(
                "${expenses?[index].category?.toLowerCase() ?? "not specified"}",
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400),
              ),
              trailing: Text(
                  "${((expenses?[index].amount ?? 0.0))} / ${expenses?[index].frequency?.toLowerCase()}",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400)),
            ));
      },
      // ),
    );
  }

  Widget _savingsDisplayRounded(List<Saving>? savings) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      // Отключаем скролл внутри родителя
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 10,
        childAspectRatio: 2,
      ),
      itemCount: savings?.length ?? 0,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showSavingsDialog(
            saving: savings?[index],
            id: savings?[index].id,
          ),
          child: Container(
            //height: 200,
            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              //color: Colors.grey.shade50,
              gradient: LinearGradient(colors: [
                Colors.grey.shade100,
                Colors.grey.shade200,
                Colors.grey.shade300,
                // Colors.grey.shade400
              ]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.savings_outlined),
                Text(
                  "${savings?[index].title}",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "${savings?[index].targetAmount}",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatDate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  void _showSavingsDialog({Saving? saving, int? id}) {
    savingTitleController.text = saving?.title ?? "";
    savingDescriptionController.text = saving?.description ?? "";
    savingTargetAmountController.text = saving?.targetAmount.toString() ?? "";
    savingDueDate.text = saving?.dueDate.toString() == null ? "" : formatDate(saving!.dueDate.toString());

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
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
                    saving == null ? "Add Saving Goal" : "Edit Saving",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  SizedBox(height: 15),
                  _textField(
                      savingTitleController, "Title", TextInputType.text),
                  SizedBox(height: 10),
                  _textField(savingTargetAmountController, "Amount",
                      TextInputType.number),
                  SizedBox(height: 10),
                  _textField(savingDescriptionController, "Description",
                      TextInputType.text),
                  SizedBox(height: 10),
                  _datePicker(context, "Due date", savingDueDate),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (saving != null)
                        ElevatedButton(
                          onPressed: () {
                            context.read<SavingBloc>().add(DeleteSavingEvent(savingId: saving.id));
                            //Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: Text("Delete"),
                        ),
                      ElevatedButton(
                        onPressed: () {
                          print("Button pressed");
                          if (savingTitleController.text.isNotEmpty &&
                              //savingDescriptionController.text.isNotEmpty &&
                              savingTargetAmountController.text.isNotEmpty) {
                            Map<String, dynamic> newSaving = {
                              "title": savingTitleController.text,
                              "targetAmount": double.tryParse(
                                      savingTargetAmountController.text
                                          .replaceAll(',', '.')) ??
                                  0.0,
                              "description": savingDescriptionController.text,
                              "dueDate": DateTime.parse(savingDueDate.text)
                                  .toUtc()
                                  .toIso8601String(),
                            };

                            print("Saving data: $newSaving");

                            if (saving == null) {
                              context.read<SavingBloc>().add(AddSavingEvent(newSaving: newSaving));

                              print("Saving added successfully!");
                            } else {
                              context.read<SavingBloc>().add(UpdateSavingsEvent(savingId: saving.id, updatedSaving: newSaving));
                              print("Updating saving...");
                            }

                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                            saving == null ? "Add Saving" : "Update Saving"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          });
        });
  }

  void _showExpenseDialog({Expense? expense, int? id}) {
    // Если редактируем, заполняем поля текущими данными, иначе оставляем пустыми
    expenseTitleController.text = expense?.title ?? "";
    expenseAmountController.text = expense?.amount.toString() ?? "";
    expenseDescriptionController.text = expense?.description ?? "";
    String? selectedCategory = expense?.category;
    String? selectedFrequency = expense?.frequency;

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
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
                  expense == null ? "Add Expense" : "Edit Expense",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                SizedBox(height: 15),
                _textField(expenseTitleController, "Title", TextInputType.text),
                SizedBox(height: 10),
                _textField(
                    expenseAmountController, "Amount", TextInputType.number),
                SizedBox(height: 10),
                _textField(expenseDescriptionController, "Description",
                    TextInputType.text),
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Expense category",
                        style: GoogleFonts.poppins(
                            color: Colors.black, fontSize: 17),
                      ),
                      DropdownButton<String>(
                        dropdownColor: Colors.white,
                        value: selectedCategory?.toLowerCase(),
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        items:
                            ExpenseCategories.expenseCategories.map((category) {
                          return DropdownMenuItem(
                              value: category.toLowerCase(),
                              child: Text(category.toLowerCase()));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Expense frequency",
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontSize: 17)),
                      DropdownButton<String>(
                        dropdownColor: Colors.white,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        value: selectedFrequency?.toLowerCase(),
                        items: ExpenseCategories.frequency.map((frequency) {
                          return DropdownMenuItem(
                              value: frequency.toLowerCase(),
                              child: Text(frequency.toLowerCase()));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedFrequency = value!;
                          });
                        },
                      ),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (expense != null)
                      ElevatedButton(
                        onPressed: () {
                          context.read<ExpenseBloc>().add(DeleteExpenseEvent(expenseId: expense.id));
                          //Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: Text("Delete"),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        if (expenseTitleController.text.isNotEmpty &&
                            expenseAmountController.text.isNotEmpty) {
                          Map<String, dynamic> newExpense = {
                            "title": expenseTitleController.text,
                            "amount":
                                double.tryParse(expenseAmountController.text) ??
                                    0.0,
                            "description": expenseDescriptionController.text,
                            "frequency": selectedFrequency?.toUpperCase(),
                            "category": selectedCategory?.toUpperCase(),
                          };

                          if (expense == null) {
                            context.read<ExpenseBloc>().add(AddExpenseEvent(newExpense: newExpense));
                          } else {
                            context.read<ExpenseBloc>().add(UpdateExpenseEvent(expenseId: expense.id, updatedExpense: newExpense));
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                          expense == null ? "Add Expense" : "Update Expense"),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        });
      },
    );
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

  Widget _datePicker(
      BuildContext context, String label, TextEditingController controller) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 40,
      child: TextField(
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        style: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        readOnly: true,
        // Запрещаем ручной ввод
        decoration: InputDecoration(
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
          labelText: label,
          labelStyle: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
          suffixIcon: Icon(Icons.calendar_today, color: Colors.black),
          border: OutlineInputBorder(),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            builder: (context, child) {
              return Theme(
                data: ThemeData(
                  primaryColor: Colors.deepPurple, // Основной цвет
                  hintColor: Colors.amber, // Цвет выделения
                  textTheme: TextTheme(
                    bodyLarge: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  dialogBackgroundColor: Colors.black87, // Цвет фона
                  colorScheme: ColorScheme.light( // Темный стиль
                    primary: Colors.green, // Цвет кнопок
                    onPrimary: Colors.white, // Цвет текста кнопок
                    surface: Colors.white, // Фон календаря
                    onSurface: Colors.black, // Цвет цифр дней
                  ),
                ),
                child: child!,
              );
            },
          );

          if (pickedDate != null) {
            // Форматируем дату в "YYYY-MM-DD"
            controller.text =
                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
          }
        },
      ),
    );
  }
}
