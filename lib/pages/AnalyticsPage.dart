import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/jsonModels/Analytics.dart';
import 'package:flutter_frontend/jsonModels/AnalyticsProvider.dart';
import 'package:flutter_frontend/models/AppTheme.dart';
import 'package:flutter_frontend/models/analytics/LineChart.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
  List<bool> _isSelected = [false, true, false];
  final List<String> _labels = ['Day', 'Month', 'Year'];

  double totalSpending = 0.0;
  double totalSavings = 0.0;
  double totalIncome = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTransactionsSummary();
  }

  void loadTransactionsSummary() async {
    TransactionsSummary? summary =
        await AnalyticsProvider.fetchTransactionsSummary();
    if (summary != null) {
      setState(() {
        totalSpending = summary.totalSpending;
        totalSavings = summary.totalSaving;
        totalIncome = summary.totalIncome;
        isLoading = false;
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

                //period choosing
                _periodChoose(),

                SizedBox(
                  height: 25,
                ),
                //total info
                _transactionsSummary(),

                SizedBox(
                  height: 10,
                ),
                //button to upload PDF file
                // ElevatedButton(
                //   onPressed: () {},
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.black,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(
                //           8), // Меньше значение = менее круглые углы
                //     ),
                //   ),
                //   child: RichText(
                //     text: TextSpan(
                //       children: [
                //         WidgetSpan(
                //           child: Icon(Icons.upload_outlined,
                //               size: 20, color: Colors.white),
                //           alignment: PlaceholderAlignment.middle,
                //         ),
                //         TextSpan(
                //           text: ' Upload bank statement',
                //           style: GoogleFonts.poppins(
                //             fontSize: 17,
                //             fontWeight: FontWeight.w400,
                //             color: Colors.white,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                LineChart(),
                SizedBox(height: 20,)

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

  Widget _transactionsSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _styledButtons("Income amount", totalIncome.toString()),
        _styledButtons("Spending amount", totalSpending.toString()),
        _styledButtons("Saved amount", totalSavings.toString())
      ],
    );
  }

  Widget _styledButtons(String name, String amount) {
    return Container(
      height: 110,
      width: MediaQuery.of(context).size.width / 3 * 0.85,
      padding: EdgeInsets.symmetric(vertical: 10),
      // margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade200, // Цвет границы
          width: 1.5, // Толщина границы
        ),
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.grey.shade100, Colors.grey.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            textAlign: TextAlign.center,
            amount,
            style: GoogleFonts.poppins(
                fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black),
          )
        ],
      ),
    );
  }

  Widget _periodChoose(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Choose period of analytics:", style: GoogleFonts.poppins(
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
            });
          },
          borderRadius: BorderRadius.circular(12),
          selectedColor: Colors.white,
          fillColor: Colors.black,
          color: Colors.black,
          constraints: BoxConstraints(minWidth: 120, minHeight: 40),
          children: _labels.map((label) => Text(label, style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w400))).toList(),
        ),
      ],
    );
  }
}
