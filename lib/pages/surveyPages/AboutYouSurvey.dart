import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/surveyPages/surveyModels/ScrollableDate.dart';
import 'package:flutter_frontend/pages/surveyPages/surveyModels/SelectableOptions.dart';
import 'package:flutter_frontend/pages/surveyPages/surveyModels/TextFieldQuestions.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutYouSurvey extends StatefulWidget {
  final VoidCallback updateState;
  final Map<String, String> aboutYouQA;
  AboutYouSurvey({required this.aboutYouQA, required this.updateState});
  @override
  State<StatefulWidget> createState() => _AboutYouSurveyState();
}

class _AboutYouSurveyState extends State<AboutYouSurvey> {
  //final Map<String, dynamic> aboutYouQA = {};
  Set<String> financeLiteracy = {};
  TextEditingController _birthDayController = TextEditingController();

  // TextEditingController _ageController = TextEditingController();
  TextEditingController _incomeController = TextEditingController();
  final List<String> options = [
    "I'm just starting to learn",
    "I have an average level of knowledge",
    "I feel confident"
  ];

  @override
  void initState() {
    super.initState();
    financeLiteracy = (widget.aboutYouQA['Finance Literacy']?.replaceAll(RegExp(r'[\{\}]'), '').split(',').map((e) => e.trim()).toSet() ?? {});
    _incomeController = TextEditingController(text: widget.aboutYouQA['Income']);
    _birthDayController = TextEditingController(text: widget.aboutYouQA['Birthday']);
  }



  void _handleSelectionChanged(Set<String> newSelection) {
    setState(() {
      financeLiteracy = newSelection;
      widget.aboutYouQA['Finance Literacy'] = financeLiteracy.join(', '); // Сохраняем корректный формат
      widget.updateState();
    });
  }

  void _handleIncomeChange(String value) {
    setState(() {
     widget.aboutYouQA['Income'] = value;
     widget.updateState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: Text(
              "About You",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          _datePicker(
              context, _birthDayController, "Date of birth", "Birthday"),
          TextFieldQuestion(
            onAnswer: _handleIncomeChange,
              controller: _incomeController,
              question: 'Monthly Income (USD)',
              questionKey: 'Income',
              errorMessage:  "Write any type of your incomes(scholarship, freelance, salary, etc)"),

          SizedBox(
            height: 320,
            child: SelectableOptions(
              initialSelection: financeLiteracy,
              options: options,
              allowMultipleSelectedOptions: false,
              onSelectionChanged: _handleSelectionChanged,
              question: "Financial literacy level",
            ),
          )
        ],
      ),
    );
  }

  Widget _datePicker(BuildContext context, TextEditingController controller,
      String question, String questionKey) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.7,
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.grey.shade300)),
        child: Column(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Text(
                question,
                style: GoogleFonts.ubuntu(
                  color: Colors.black,
                    fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 35,
              width: MediaQuery.of(context).size.width * 0.5,
              child: ScrollableDate(
                date: controller,
                onDateSelected: (selectedDate) {
                  setState(() {
                    widget.aboutYouQA[questionKey] = selectedDate;
                  });
                },
              ),
            )
          ],
        ));
  }
}
