import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/Frequency.dart';
import '../config/IncomeCategories.dart';
import '../jsonModels/BankCard.dart';
import '../jsonModels/BankCards.dart';
import '../jsonModels/Income.dart';
import '../jsonModels/Incomes.dart';

class IncomesListTile extends StatefulWidget{
  final VoidCallback updateUI;
  final List<Income>? incomes;
  const IncomesListTile({super.key, required this.updateUI, required this.incomes});

  @override
  State<StatefulWidget> createState() => _IncomesListTileState();
}

class _IncomesListTileState extends State<IncomesListTile>{

  //incomes controllers
  TextEditingController incomeTitleController = TextEditingController();
  TextEditingController incomeDescriptionController = TextEditingController();
  TextEditingController incomeAmountController = TextEditingController();

  bool isLoading = true;

  List<Income>? incomes = [];
  List<BankCard>? cards = [];


  @override
  void initState() {
    super.initState();
    incomes = widget.incomes;
    fetchCards();
  }

  // Future<void> fetchIncomes() async{
  //   List<Income>? incomeData = await Incomes.fetchIncomes();
  //   setState(() {
  //     incomes = incomeData ?? [];
  //     isLoading = false;
  //     // updateDetails();
  //   });
  // }

  Future<void> fetchCards() async{
    List<BankCard>? cardsData = await BankCards.fetchCards();
    if(mounted){
      setState(() {
        cards = cardsData;
        isLoading = false;
      });
    }
  }

  Future<void> updateIncome(Map<String, dynamic> updatedIncome, int id) async{
    bool success = await Incomes.updateIncome(updatedIncome, id);
    if(success){
      widget.updateUI();
    }
  }

  Future<void> addIncome(Map<String, dynamic> newIncome) async{
    bool success = await Incomes.addNewIncome(newIncome);
    if(success){
      widget.updateUI();
    }
  }

  Future<void> deleteIncome(int id) async{
    bool success = await Incomes.deleteIncome(id);
    if(success){
     // fetchIncomes();
      widget.updateUI();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
            Text( (noInfoYet1),
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


  void _showIncomesDialog({Income? income, int? id}) {
    // Если редактируем, заполняем поля текущими данными, иначе оставляем пустыми
    incomeTitleController.text = income?.title ?? "";
    incomeAmountController.text = income?.amount.toString() ?? "";
    incomeDescriptionController.text = income?.description ?? "";
    String? selectedCategory = income?.category;
    String? selectedFrequency = income?.frequency;

    // Сопоставление карт (ID -> Название)
    Map<int, String> cardWithNames = {for (var card in cards ?? []) card.id: card.title};

    // Список названий карт
    List<String>? cardsName = cards?.map((card) => card.title).toList();

    // Выбранная карта (храним ID!)
    int? selectedCardId = income?.cardId;

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
                      Text("Choose card",
                          style: GoogleFonts.ubuntu(
                              color: Colors.black, fontSize: 17)),
                      DropdownButton<String>(
                        dropdownColor: Colors.white,
                        style: GoogleFonts.ubuntu(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        value: selectedCardId != null? cardWithNames[selectedCardId]: null,
                        items: cardsName?.map((card) {
                          return DropdownMenuItem(
                              value: card,
                              child: Text(card));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCardId = cardWithNames.entries
                                .firstWhere((entry) => entry.value == value)
                                .key;
                          });
                        },
                      ),
                    ]
                ),
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
                            "cardId": selectedCardId
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
}