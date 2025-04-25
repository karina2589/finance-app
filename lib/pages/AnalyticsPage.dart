import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/jsonModels/Analytics.dart';
import 'package:flutter_frontend/jsonModels/AnalyticsProvider.dart';
import 'package:flutter_frontend/models/analytics/LineChart.dart';
import 'package:flutter_frontend/models/analytics/PieChart.dart';
import 'package:flutter_frontend/jsonModels/transactionData.dart';
import 'package:google_fonts/google_fonts.dart';

import '../jsonModels/BankCard.dart';
import '../jsonModels/BankCards.dart';
import '../jsonModels/BankStatement.dart';
import '../jsonModels/StatementTransaction.dart';
import '../models/analytics/DottedButton.dart';

void main() {
  runApp(MaterialApp(
    home: AnalyticsPage(),
    // theme: AppTheme.lightTheme,
  ));
}

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<StatefulWidget> createState() => AnalyticsPageState();
}

class AnalyticsPageState extends State<AnalyticsPage> {
  List<bool> _isSelected = [true, false, false ];
  final List<String> _labels = ['1 Month', '6 Month', '1 Year'];

  bool isUploading = false; // Для отслеживания процесса загрузки
  String statusMessage = ""; // Для отображения статуса
  late BankStatement statement;
  List<BankCard>? cards = [];
  bool fileChosen = false;
  String? filePath;
  String? fileName;
  bool readingFile = false;
  bool readingDone = false;

  List<Map<String, dynamic>> expenses = [];
  List<Map<String, dynamic>> savings = [];

  List<Map<String, dynamic>> transactionByPeriod = [];

  List<Map<String, dynamic>> transactionsSummary = [];
  int period = 1 ;
  double totalIncome = 0;


  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadTransactionsSummary();
    loadCards();
    getDataByPeriod();
    loadTransactionsSummaryByPeriod();
  }

  void getDataByPeriod() async{
    List<Map<String, dynamic>>? data = await TransactionData.loadTransactionsByPeriod(period);
    if(data!=null){
      setState(() {
        transactionByPeriod = data;
      });
    }
  }

  void loadTransactionsSummaryByPeriod() async {
    TransactionsSummary? summary =
    await AnalyticsProvider.fetchTotalsByPeriod(period);
    if (summary != null) {
      setState(() {
        totalIncome = summary.totalIncome;
        transactionsSummary = [
                // {"category": "Income", "amount": transactionSummary.totalIncome},
                {"category": "Saving", "amount": summary.totalSaving},
                {"category": "Spending", "amount": summary.totalSpending},
                {"category": "Not used money", "amount": summary.totalIncome - (summary.totalSaving + summary.totalSpending)},
                // {"category": "Income", "amount": transactionSummary.totalIncome},

              ];
      });
    }
  }

  Future<BankStatement?> uploadFile(int cardId, String filePath, String bank) async {
    BankStatement? statementTr =
    await BankStatement.uploadFile(filePath, cardId, bank);
    if (statementTr != null) {
      setState(() {
        statement = statementTr;
        statusMessage = "file was successfully read";
        readingFile = false;
        readingDone = true;
        for (var tr in statement.statementTransactions) {
          print("Statement transaction ");
          print(tr.title);
          print(tr.type);
          print(tr.amount);
        }
      });
      // Даем системе немного времени после setState
      await Future.delayed(Duration(milliseconds: 100));

      // Вызываем после фрейма, чтобы избежать ошибок навигации
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showConfirmationDialog();
      });
    } else {
      if (context.mounted) {
        Navigator.of(context).pop(); // Закрыть диалог
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload file')),
        );
      }
    }
  }


  Future<void> loadCards() async {
    List<BankCard>? cardsLoad = await BankCards.fetchCards();
    if (cardsLoad != null) {
      setState(() {
        cards = cardsLoad;
      });
    }
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 15,
                ),
                //button to upload PDF file
                DashedBorderButton(
                  iconData: Icons.cloud_upload_outlined,
                  text: "  Upload bank statement",
                  onPressed: _showFileUploadDialog,
                ),
                SizedBox(height: 20,),
                //period choosing
                _periodChoose(),

                SizedBox(
                  height: 25,
                ),
                //total info
                // _transactionsSummary(),
                PieChart(transactionsSummary: transactionsSummary, period: period, totalIncome: totalIncome,),
                SizedBox(
                  height: 10,
                ),
                LineChart(transactions: transactionByPeriod, period: period,),
                SizedBox(
                  height: 20,
                )

                // Divider(
                //   color: AppTheme.widgetColor,
                //   thickness: 2.0,
                //   indent: 50,
                //   // Space before the divider starts
                //   endIndent: 50,
                // ),
              ]),
        )));
  }

void _showFileUploadDialog() {
  fileName = null;
  filePath = null;
  fileChosen = false;

  Map<int, String> cardsWithNames = {
    for (var card in cards ?? []) card.id: card.title
  };
  print(cardsWithNames);
  List<String>? cardsName = cards?.map((card) => card.title).toList();
  print(cardsName);

  // Переменные, которые будут создаваться заново при каждом открытии окна
  String? selectedCardName;
  int? selectedCardId;
  List<String> banks = ['kaspi', 'halyk'];

  String? selectedBank;

  showDialog(
    context: context,
    barrierDismissible: true, // позволяет закрывать диалог по тапу вне окна
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // чтобы диалог не был на весь экран
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Uplaod your Bank Statement',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Card Name",
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontSize: 17),
                        ),
                        DropdownButton<String>(
                          dropdownColor: Colors.white,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          hint: Text("Select a card"),
                          value: selectedCardName,
                          // Теперь значение сбрасывается при каждом новом вызове диалога
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
                        ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Bank Name",
                              style: GoogleFonts.poppins(
                                  color: Colors.black, fontSize: 17),
                            ),
                        DropdownButton<String>(
                          dropdownColor: Colors.white,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          hint: Text("Select bank"),
                          value: selectedBank,
                          // Теперь значение сбрасывается при каждом новом вызове диалога
                          items: banks.map((card) {
                            return DropdownMenuItem(
                              value: card,
                              child: Text(card),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedBank = value;
                              // selectedCardId = cardsWithNames.entries
                              //     .firstWhere((entry) => entry.value == value)
                              //     .key;
                            });
                          },
                        ),
                            ]),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: (fileChosen && filePath != null)
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.grey.shade300)),
                                height: 40,
                                width:
                                MediaQuery.of(context).size.width *
                                    0.8,
                                child: Padding(
                                  padding:
                                  EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    "$fileName",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black),
                                onPressed: () {
                                  setState((){
                                    readingFile = true;
                                    uploadFile(
                                        selectedCardId!, filePath!, selectedBank! );
                                  });
                                },
                                child:Center(
                                  child:
                                  readingFile
                                      ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : Text(
                                    "Scan Transactions",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            )
                          ],
                        )
                            : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black),
                            onPressed: () async {
                              FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type: FileType.custom,
                                allowedExtensions: ['pdf'],
                              );
                              if (result != null &&
                                  result.files.first.path != null) {
                                print("FILE PATH IS \n");
                                print(result.files.first.path);

                                setState(() {
                                  filePath = result.files.first.path;
                                  fileChosen = true;
                                  fileName = result.files.first.name;
                                });
                                // uploadFile(9, result.files.first.path!);
                              }
                            },
                            child: Text(
                              "Upload file from device",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ))
                      //   ],
                      // )
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

void showConfirmationDialog() async{
  //Navigator.pop(context); // закрываем старый диалог
  await Future.delayed(Duration(milliseconds: 200)); // немного подождать
  List<StatementTransaction>? transactions = statement.statementTransactions;

  showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                children: [
                  Text("Statement transactions", style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),),
                  SizedBox(height: 15,),
                  Expanded(child:
                  ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      String amount = "";
                      String type =
                      transactions[index].type == "INCOME" ? "+" : "-";
                      MaterialColor color = type == "+" ? Colors.green : Colors.red;

                      if (transactions[index].type == "INCOME") {
                        amount = " + ${transactions[index].amount}";
                      } else {
                        amount = " - ${transactions[index].amount}";
                      }
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(15),
                          // border: Border.all(color: Colors.grey.shade300)
                        ),
                        // height: 50,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(2.5),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          title: Text("${transactions[index].title}", style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          )),
                          subtitle: Text("${transactions[index].createdAt}", style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          )),
                          trailing: Text("$amount", style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: color,
                          )),
                        ),
                      );
                    },
                  ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // закрывает модалку после подтверждения
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Confirm",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ),
        );
      });
}


  Widget _periodChoose() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose period of analytics:",
          style: GoogleFonts.poppins(
              fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        SizedBox(height: 10),
        ToggleButtons(
          isSelected: _isSelected,
          onPressed: (int index) {
            setState(() {
              for (int i = 0; i < _isSelected.length; i++) {
                _isSelected[i] = i == index;
              }
              String selectedPeriod = _labels[index];
              print(selectedPeriod);
              int numOfmonths = index == 0? 1: index == 1? 6 : 12;
              period = numOfmonths;
              getDataByPeriod();
              loadTransactionsSummaryByPeriod();
              // fetchDataForPeriod(selectedPeriod);
            });
          },
          borderRadius: BorderRadius.circular(12),
          selectedColor: Colors.white,
          fillColor: Colors.black,
          color: Colors.black,
          constraints: BoxConstraints(minWidth: 120, minHeight: 40),
          children: _labels
              .map((label) => Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w400)))
              .toList(),
        ),
      ],
    );
  }
}
