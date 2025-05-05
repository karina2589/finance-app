import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/bloc/cards_bloc/cards_bloc.dart';
import 'package:flutter_frontend/bloc/cards_bloc/cards_event.dart';
import 'package:flutter_frontend/bloc/cards_bloc/cards_state.dart';
import 'package:flutter_frontend/bloc/income_bloc/income_bloc.dart';
import 'package:flutter_frontend/bloc/income_bloc/income_event.dart';
import 'package:flutter_frontend/bloc/income_bloc/income_state.dart';
import 'package:flutter_frontend/jsonModels/BankCard.dart';
import 'package:flutter_frontend/jsonModels/BankCards.dart';
import 'package:flutter_frontend/jsonModels/CardDetail.dart';
import 'package:flutter_frontend/jsonModels/CardDetails.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/income_transaction_bloc/income_transaction_bloc.dart';
import '../bloc/income_transaction_bloc/income_transaction_event.dart';
import '../bloc/income_transaction_bloc/income_transaction_state.dart';
import '../config/Frequency.dart';
import '../config/IncomeCategories.dart';
import '../jsonModels/Income.dart';
import '../jsonModels/Incomes.dart';
import '../jsonModels/PendingIncome.dart';

class BankCardSwiper extends StatefulWidget {
  //final VoidCallback updateUI;

  //BankCardSwiper({required this.updateUI});
  @override
  State<StatefulWidget> createState() => _BankCardSwiperState();
}

class _BankCardSwiperState extends State<BankCardSwiper> {
  List<CardDetail>? cardDetails = [];
  List<BankCard>? cards = [];
  List<BankCard>? fetchedCards = [];
  bool isLoading = true;
  final PageController _pageController = PageController(viewportFraction: 0.5);

  //incomes controllers
  TextEditingController incomeTitleController = TextEditingController();
  TextEditingController incomeDescriptionController = TextEditingController();
  TextEditingController incomeAmountController = TextEditingController();

  //card name controller
  TextEditingController cardNameController = TextEditingController();

  List<Income>? incomes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCards();
    context.read<IncomeBloc>().add(LoadIncomeEvent());
    context.read<CardBloc>().add(LoadCardEvent());
    context.read<IncomeTransactionBloc>().add(LoadIncomeTransactionEvent());
  }

  void fetchCards() async{
    List<BankCard>? data = await BankCards.fetchCards();
    if(data!=null){
      setState(() {
        cards = data;
      });
    }
  }

  //
  // String _formattedNumber(int value){
  //   final formatter = NumberFormat('#,##0', 'ru_RU'); // Используем русскую локаль
  //   return formatter.format(value).replaceAll(',', ' ');
  // }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 180,
        child: BlocBuilder<CardBloc, CardState>(builder: (context, state){
          if(state is CardLoadingState){
            return Center(child: CircularProgressIndicator(),);
          }
          else if(state is CardLoadedState){

            final List<BankCard>? cards = state.cards;
            return PageView.builder(
              padEnds: false,
              controller: _pageController,
              itemCount: (cards?.length ?? 0) + 1,
              itemBuilder: (context, index) {
                if (cards == null || index >= cards.length) {
                  // Последний индекс для кнопки добавления
                  return _buildAddButton();
                }

                final card = cards[index];
                return _buildIncomeCard(card);
              },
            );
          }else if(state is CardEmptyState){
            return _buildAddButton();
          }
          else{
            return Text("Cards loading error. Please check your connection");
          }
        })
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
                "Incomes",
                style: GoogleFonts.poppins(
                    color: Colors.black, fontSize: 20),
              ),
              IconButton(
                  onPressed: () => _showIncomesDialog(cards: cards),
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
          Icons.payments_outlined),
      SizedBox(
        height: 20,
      ),
    ]);
  }

  /// Создает карточку дохода
  Widget _buildIncomeCard(BankCard? card) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: GestureDetector(
          onTap: () => _showCardDialog(card: card, id: card?.id),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            color: Colors.blueAccent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        // colors: [Colors.white60, Colors.white70, Colors.white],
                        colors: [
                          Colors.blue.shade300,
                          Colors.blue.shade400,
                          Colors.blue.shade500
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      textAlign: TextAlign.start,
                      "${card?.title ?? ""}",
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(("Total balance"),
                      style:
                      GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
                  Text("\$ ${card?.balance ?? 0}",
                      style: GoogleFonts.poppins(
                          fontSize: 18, color: Colors.white)),

                ],
              ),
            ),
          ),
        )
    );
  }

  void _showCardDialog({BankCard? card, int? id}) {
    // Если редактируем, заполняем поля текущими данными, иначе оставляем пустыми
    cardNameController.text = card?.title ?? "";
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
              bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  card == null ? "Add Card" : "Edit Card",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                SizedBox(height: 15),
                _textField(cardNameController, "Title", TextInputType.text),
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (card != null)
                      ElevatedButton(
                        onPressed: () {
                          context.read<CardBloc>().add(DeleteCardEvent(cardId: card.id));
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: Text("Delete"),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        if (cardNameController.text.isNotEmpty) {
                          String newCard = cardNameController.text;

                          if (card == null) {
                            context.read<CardBloc>().add(AddCardEvent(cardName: newCard));
                            fetchCards();
                          } else {
                            context.read<CardBloc>().add(UpdateCardEvent(updatedCardName: newCard, cardId: card.id));
                            fetchCards();
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                          card == null ? "Add Card" : "Update Card"),
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

  Widget _buildAddButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: GestureDetector(
        onTap: () => _showCardDialog(),
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
          color: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width* 0.45,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black26, width: 2),
            ),
            child: Center(
              child: Icon(Icons.add, size: 40, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget _displayListTile(BuildContext context,
      String noInfoYet1,
      String noInfoYet2,
      String noInfoTitle,
      IconData icon,
      ) {
    return BlocListener<IncomeBloc, IncomeState>(
        listener: (context, state) {
      print("State changed: $state");
      if (state is IncomeLoadedState) {
        setState(() {});  // Принудительное обновление UI
      }
    },
    child: BlocBuilder<IncomeBloc, IncomeState>(
        builder: (context, state) {
          print("UI updated with state: $state");
          if (state is IncomeLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is IncomeEmptyState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text((noInfoYet1),
                    style: GoogleFonts.poppins(
                        fontSize: 18, color: Colors.black54),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.black54),
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

          else if(state is IncomeLoadedState){
            print("Rendering UI with incomes: ${state.incomes}");
            return _incomesDisplay(state.incomes, state.cards);
          }
          else{
            return Text("error");
          }
        }
    )
    );
  }



Widget _incomesDisplay(List<Income>? incomes, List<BankCard>? cards) {
  return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: incomes?.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () =>
                _showIncomesDialog(
                    income: incomes?[index], id: incomes?[index].id, cards: cards),
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
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
              subtitle: Text(
                "${incomes?[index].category?.toLowerCase() ?? "not specified"}",
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400),
              ),
              trailing: Text(
                  "${((incomes?[index].amount ?? 0.0))} / ${incomes?[index]
                      .frequency?.toLowerCase()}",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400)),
            )
        );
      }
        );
      }




      void _showIncomesDialog({Income? income, int? id, required List<BankCard>? cards})
  {
    // Если редактируем, заполняем поля текущими данными, иначе оставляем пустыми
    incomeTitleController.text = income?.title ?? "";
    incomeAmountController.text = income?.amount.toString() ?? "";
    incomeDescriptionController.text = income?.description ?? "";
    String? selectedCategory = income?.category;
    String? selectedFrequency = income?.frequency;

    // Сопоставление карт (ID -> Название)
    Map<int, String> cardWithNames = {
      for (var card in cards ?? []) card.id: card.title
    };

    // Список названий карт
    List<String>? cardsName = cards?.map((card) => card.title).toList();

    // Выбранная карта (храним ID!)
    int? selectedCardId = income?.cardId;

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
              bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom,
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
                  style: GoogleFonts.poppins(
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
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontSize: 17)),
                      DropdownButton<String>(
                        dropdownColor: Colors.white,
                        style: GoogleFonts.poppins(
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
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontSize: 17)),
                      DropdownButton<String>(
                        dropdownColor: Colors.white,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        value: selectedCardId != null
                            ? cardWithNames[selectedCardId]
                            : null,
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
                          context.read<IncomeBloc>().add(DeleteIncomeEvent(incomeId: income.id));
                         // deleteIncome(income.id);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: Text("Delete"),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        if (incomeTitleController.text.isNotEmpty &&
                            incomeAmountController.text.isNotEmpty) {
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
                            context.read<IncomeBloc>().add(AddIncomeEvent(newIncome: newIncome));
                            //addIncome(newIncome); // Добавление нового расхода
                          } else {
                            context.read<IncomeBloc>().add(UpdateIncomeEvent(incomeId: income.id, updatedIncome: newIncome));
                            // updateIncome(
                            //     newIncome, income.id); // Обновление расхода
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


  Widget _textField(TextEditingController controller, String title,
      TextInputType type) {
    return SizedBox(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.85,
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
