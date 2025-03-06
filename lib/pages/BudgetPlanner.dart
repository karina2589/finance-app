import 'package:flutter/material.dart';
import 'package:flutter_frontend/config/AppConfig.dart';
import 'package:flutter_frontend/config/Frequency.dart';
import 'package:flutter_frontend/config/IncomeCategories.dart';
import 'package:flutter_frontend/jsonModels/Expense.dart';
import 'package:flutter_frontend/config/ExpenseCategories.dart';
import 'package:flutter_frontend/jsonModels/Expenses.dart';
import 'package:flutter_frontend/jsonModels/Incomes.dart';
import 'package:flutter_frontend/jsonModels/Savings.dart';
import 'package:flutter_frontend/models/AppTheme.dart';
import 'package:flutter_frontend/models/CardSwiper.dart';
import 'package:flutter_frontend/models/IncomeCardSwiper.dart';
import 'package:flutter_frontend/pages/draft.dart';
import 'package:flutter_frontend/pages/surveyPages/surveyModels/ScrollableDate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../jsonModels/Income.dart';
import '../jsonModels/Saving.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Добавь эту строку
  runApp(MaterialApp(
    home: Scaffold(body: BudgetPlanner()),
    theme: AppTheme.lightTheme,
  ));
}

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

  //incomes controllers
  TextEditingController incomeTitleController = TextEditingController();
  TextEditingController incomeDescriptionController = TextEditingController();
  TextEditingController incomeAmountController = TextEditingController();

  List<Expense>? expenses = [];
  List<Saving>? savings = [];
  List<Income>? incomes = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchIncomes();
    fetchExpenses();
    fetchSavings();
    fetchIncomes();
  }

  Future<void> fetchExpenses() async {
    List<Expense>? expenseData = await Expenses.fetchExpenses();
    if (mounted) {
      setState(() {
        expenses = expenseData;
        isLoading = false;
      });
    }
    print(expenses);
  }

  Future<void> fetchSavings() async {
    List<Saving>? data = await Savings.fetchSavings();
    setState(() {
      savings = data;
      isLoading = false;
    });
  }

  Future<void> fetchIncomes() async{
    List<Income>? incomeData = await Incomes.fetchIncomes();
    setState(() {
      incomes = incomeData ?? [];
      isLoading = false;
    });
  }

  Future<void> updateIncome(Map<String, dynamic> updatedIncome, int id) async{
    bool success = await Incomes.updateIncome(updatedIncome, id);
    if(success){
      fetchIncomes();
    }
  }

  Future<void> addIncome(Map<String, dynamic> newIncome) async{
    bool success = await Incomes.addNewIncome(newIncome);
    if(success){
      fetchIncomes();
    }
  }

  Future<void> deleteIncome(int id) async{
    bool success = await Incomes.deleteIncome(id);
    if(success){
      fetchIncomes();
    }
  }

  Future<void> updateExpense(int id, Map<String, dynamic> updateExpense) async {
    bool success = await Expenses.updateExpense(id, updateExpense);
    if (success) {
      fetchExpenses();
    }
  }

  Future<void> updateSaving(Map<String, dynamic> updateExpense, int id) async {
    bool success = await Savings.updateSaving(updateExpense, id);
    if (success) {
      fetchSavings();
    }
  }

  Future<void> addExpense(Map<String, dynamic> newExpense) async {
    bool success = await Expenses.addExpense(newExpense);
    if (success) {
      fetchExpenses();
    }
  }

  Future<void> addSaving(Map<String, dynamic> newSaving) async {
    bool success = await Savings.addSavings(newSaving);
    if (success) {
      fetchSavings();
    }
    savingDueDate.clear();
    savingDescriptionController.clear();
    savingTargetAmountController.clear();
    savingTitleController.clear();
  }

  Future<void> deleteExpense(int id) async {
    bool success = await Expenses.deleteExpense(id);
    if (success) {
      fetchExpenses();
      Navigator.pop(context);
    }
  }

  Future<void> deleteSaving(int id) async {
    bool success = await Savings.deleteSaving(id);
    if (success) {
      fetchSavings();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //  CardSwiper(),
          IncomeCardSwiper(),

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
                    "Incomes",
                    style: GoogleFonts.inriaSans(
                        color: Colors.black, fontSize: 20),
                  ),
                  IconButton(
                      onPressed: () => _showIncomesDialog(),
                      //display dialog
                      //update expenses list
                      icon: Icon(Icons.add_circle_outline))
                ],
              )),
          _displayListTile(
              context,
              "You don't have incomes yet. Click on the ",
              " icon and add an income to your budget",
              "No Planned Payments Yet",
              Icons.payments_outlined,
              incomes,
              _incomesDisplay()),
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
                    "Planned expenses",
                    style: GoogleFonts.inriaSans(
                        color: Colors.black, fontSize: 20),
                  ),
                  IconButton(
                      onPressed: () => _showExpenseDialog(),
                      //display dialog
                      //update expenses list
                      icon: Icon(Icons.add_circle_outline))
                ],
              )),
          _displayListTile(
              context,
              "You have not budgeted your expenses yet. Click on the ",
              " icon and add an expense to your budget",
              "No Planned Payments Yet",
              Icons.payments_outlined,
              expenses,
              _expenseDisplay()),
          SizedBox(
            height: 20,
          ),

          Divider(
            indent: 10,
            endIndent: 10,
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Goals",
                    style: GoogleFonts.inriaSans(
                        color: Colors.black, fontSize: 20),
                  ),
                  IconButton(
                      onPressed: () => _showSavingsDialog(),
                      icon: Icon(Icons.add_circle_outline))
                ],
              )),
          _displayListTile(
              context,
              "You don't have any savings goal. Click on the ",
              " icon to add new saving goal",
              "No Saving Goals Yet",
              Icons.savings,
              savings,
              _savingsDisplay()),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _displayListTile(
      BuildContext context,
      String noInfoYet1,
      String noInfoYet2,
      String noInfoTitle,
      IconData icon,
      List<dynamic>? list,
      Widget displayFunction) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (list == null || list.isEmpty) {
      // Если список пуст, показываем сообщение
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
    }

    return displayFunction;
  }

  Widget _expenseDisplay() {
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
                style: GoogleFonts.ubuntu(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
              subtitle: Text(
                "${expenses?[index].category?.toLowerCase() ?? "not specified"}",
                style: GoogleFonts.ubuntu(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400),
              ),
              trailing: Text(
                  "${((expenses?[index].amount ?? 0.0))} / ${expenses?[index].frequency?.toLowerCase()}",
                  style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400)),
            ));
      },
      // ),
    );
  }

  Widget _incomesDisplay() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: incomes?.length,
      itemBuilder: (context, index) {

        return GestureDetector(
            onTap: () => _showIncomesDialog(
                income: incomes?[index], id: incomes?[index].id),
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
                  Icons.south_east_rounded,
                  color: Colors.black, // Синий цвет иконки
                  size: 24,
                ),
              ),
              title: Text(
                "${incomes?[index].title}",
                style: GoogleFonts.ubuntu(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
              subtitle: Text(
                "${incomes?[index].category?.toLowerCase() ?? "not specified"}",
                style: GoogleFonts.ubuntu(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400),
              ),
              trailing: Text(
                  "${((incomes?[index].amount ?? 0.0))} / ${incomes?[index].frequency?.toLowerCase()}",
                  style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400)),
            ));
      },
      // ),
    );
  }

  Widget _savingsDisplay() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: savings?.length,
      itemBuilder: (context, index) {
        Map<String, IconData> expenseIcons = ExpenseCategories.expenseIcons;
        // IconData? iconToChoose = expenseIcons[savings?[index].?.toLowerCase().trim()];

        return GestureDetector(
            onTap: () => _showSavingsDialog(
                saving: savings?[index], id: savings?[index].id),
            child: ListTile(
              leading: Container(
                width: 40, // Размер квадрата
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100, // Белый фон
                  borderRadius:
                      BorderRadius.circular(8), // Можно сделать мягкие углы
                ),
                child: Icon(
                  Icons.trending_up,
                  color: Colors.black, // Синий цвет иконки
                  size: 24,
                ),
              ),
              title: Text(
                "${savings?[index].title}",
                style: GoogleFonts.ubuntu(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
              subtitle: Text(
                "${savings?[index].description?.toLowerCase() ?? "category is not specified"}",
                style: GoogleFonts.ubuntu(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400),
              ),
              trailing: Text(
                  "${(savings?[index].savedAmount ?? 0)} / ${(savings?[index].targetAmount ?? 0)}",
                  style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400)),
            ));
      },
      // ),
    );
  }

  void _showSavingsDialog({Saving? saving, int? id}) {
    savingTitleController.text = saving?.title ?? "";
    savingDescriptionController.text = saving?.description ?? "";
    savingTargetAmountController.text = saving?.targetAmount.toString() ?? "";
    savingDueDate.text = saving?.dueDate.toString() ?? "";

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
                    style: GoogleFonts.ubuntu(
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
                            deleteSaving(saving.id);
                            //Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: Text("Delete"),
                        ),
                      ElevatedButton(
                        onPressed: () async {
                          print("Button pressed");
                          if (savingTitleController.text.isNotEmpty &&
                              savingDescriptionController.text.isNotEmpty &&
                              savingTargetAmountController.text.isNotEmpty) {
                            Map<String, dynamic> newSaving = {
                              "title": savingTitleController.text,
                              "targetAmount": double.tryParse(
                                  savingTargetAmountController.text.replaceAll(',', '.')) ??
                                  0.0,
                              "description": savingDescriptionController.text,
                              "dueDate": DateTime.parse(savingDueDate.text).toUtc().toIso8601String(),
                            };

                            print("Saving data: $newSaving");

                            if (saving == null) {
                              await addSaving(newSaving);
                              print("Saving added successfully!");
                            } else {
                              await updateSaving(newSaving, saving.id);
                              print("Updating saving...");
                            }

                            if (context.mounted) Navigator.pop(context);
                          }
                        },
                        child: Text(saving == null ? "Add Saving" : "Update Saving"),
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
                  style: GoogleFonts.ubuntu(
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
                        style: GoogleFonts.ubuntu(
                            color: Colors.black, fontSize: 17),
                      ),
                      DropdownButton<String>(
                        dropdownColor: Colors.white,
                        value: selectedCategory?.toLowerCase(),
                        style: GoogleFonts.ubuntu(
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
                          style: GoogleFonts.ubuntu(
                              color: Colors.black, fontSize: 17)),
                      DropdownButton<String>(
                        dropdownColor: Colors.white,
                        style: GoogleFonts.ubuntu(
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
                          deleteExpense(expense.id);
                          //Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: Text("Delete"),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        if (expenseTitleController.text.isNotEmpty &&
                            expenseAmountController.text.isNotEmpty ) {
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
                             addExpense(newExpense); // Добавление нового расхода
                          } else {
                            updateExpense(
                                expense.id, newExpense); // Обновление расхода
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

  void _showIncomesDialog({Income? income, int? id}) {
    // Если редактируем, заполняем поля текущими данными, иначе оставляем пустыми
    incomeTitleController.text = income?.title ?? "";
    incomeAmountController.text = income?.amount.toString() ?? "";
    incomeDescriptionController.text = income?.description ?? "";
    String? selectedCategory = income?.category;
    String? selectedFrequency = income?.frequency;
    //card id

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
                  income == null ? "Add income" : "Edit income",
                  style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                SizedBox(height: 15),
                _textField(incomeTitleController, "Title", TextInputType.text),
                SizedBox(height: 10),
                _textField(
                    incomeAmountController, "Amount", TextInputType.number),
                SizedBox(height: 10),
                _textField(incomeDescriptionController, "Description",
                    TextInputType.text),
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Income category",
                        style: GoogleFonts.ubuntu(
                            color: Colors.black, fontSize: 17),
                      ),
                      DropdownButton<String>(
                        dropdownColor: Colors.white,
                        value: selectedCategory?.toLowerCase(),
                        style: GoogleFonts.ubuntu(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        items:
                        IncomeCategories.incomeCategories.map((category) {
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
                      Text("Income frequency",
                          style: GoogleFonts.ubuntu(
                              color: Colors.black, fontSize: 17)),
                      DropdownButton<String>(
                        dropdownColor: Colors.white,
                        style: GoogleFonts.ubuntu(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        value: selectedFrequency?.toLowerCase(),
                        items: Frequency.frequency.map((frequency) {
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
                    if (income != null)
                      ElevatedButton(
                        onPressed: () {
                          deleteIncome(income.id);
                          //Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: Text("Delete"),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        if (incomeTitleController.text.isNotEmpty &&
                            incomeAmountController.text.isNotEmpty ) {
                          Map<String, dynamic> newIncome = {
                            "title": incomeTitleController.text,
                            "amount":
                            double.tryParse(incomeAmountController.text) ??
                                0.0,
                            "description": incomeDescriptionController.text,
                            "frequency": selectedFrequency?.toUpperCase(),
                            "category": selectedCategory?.toUpperCase(),
                          };

                          if (income == null) {
                            addIncome(newIncome); // Добавление нового расхода
                          } else {
                           updateIncome(newIncome, income.id); // Обновление расхода
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                          income == null ? "Add Income" : "Update Income"),
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
          style: GoogleFonts.ubuntu(
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
              labelStyle: GoogleFonts.ubuntu(
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
            style: GoogleFonts.ubuntu(
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
              labelStyle: GoogleFonts.ubuntu(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
              suffixIcon: Icon(Icons.calendar_today, color: Colors.black),
              border: OutlineInputBorder(),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
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
