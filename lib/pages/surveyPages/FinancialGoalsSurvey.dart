import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/surveyPages/surveyModels/SelectableOptions.dart';
import 'package:flutter_frontend/pages/surveyPages/surveyModels/TextFieldQuestions.dart';

class FinancialGoalsSurvey extends StatefulWidget {
  final Map<String, String> financialGaolsQA;
  final VoidCallback updateState;
  FinancialGoalsSurvey({required this.financialGaolsQA, required this.updateState});
  @override
  State<StatefulWidget> createState() => _FinancialGoalsSurveyState();
}

class _FinancialGoalsSurveyState extends State<FinancialGoalsSurvey> {
  Set<String> financialGoals = {};
  Set<String> features = {};
  final List<String> financialGoalsOptions = [
    "Saving money",
    "Controlling spending",
    "Budgeting",
    "Increasing savings"
  ];
  final List<String> featuresOptions = [
    "Monthly planning",
    "Savings optimization",
    "Expenses tracking",
    "Spending's analytics"
  ];
  TextEditingController _savingAmount = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    financialGoals = (widget.financialGaolsQA['Financial goals']?.replaceAll(RegExp(r'[\{\}]'), '').split(',').map((e) => e.trim()).toSet() ?? {});
    features = (widget.financialGaolsQA['Features']?.replaceAll(RegExp(r'[\{\}]'), '').split(',').map((e) => e.trim()).toSet() ?? {});
    _savingAmount = TextEditingController(text: widget.financialGaolsQA['Savings']);
  }

  void _handleFinancialGoalSelectionChanged(Set<String> newSelection) {
    setState(() {
      financialGoals = newSelection;
      widget.financialGaolsQA['Financial goals'] = financialGoals.join(', ');
      widget.updateState();
    });
  }
  void _handleFeatureSelectionChanged(Set<String> featureSelected){
    setState(() {
      features = featureSelected;
      widget.financialGaolsQA['Features'] = features.join(', ');
      widget.updateState();
    });
  }

  void _handleSavingsChanged(String value){
    setState(() {
      _savingAmount = TextEditingController(text: value);
      widget.financialGaolsQA['Savings'] = value;
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
            height: 40,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              "Financial goals",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 15,),
          SizedBox(
            height: 380,
            child: SelectableOptions(
              initialSelection: financialGoals,
              options: financialGoalsOptions,
              allowMultipleSelectedOptions: true,
              onSelectionChanged: _handleFinancialGoalSelectionChanged,
              question:
                  "What financial goals are a priority for you right now?",
            ),
          ),
          TextFieldQuestion(
            onAnswer: _handleSavingsChanged,
              controller: _savingAmount,
              question: "How much do you plan to save each month?",
              questionKey: "Savings Amount",
              errorMessage:
                  "Please write how mush money you want to save each month"),
         SizedBox(
           height: 370,
           child:  SelectableOptions(
             initialSelection: features,
               options: featuresOptions,
               allowMultipleSelectedOptions: true,
               onSelectionChanged: _handleFeatureSelectionChanged,
               question: "What features are most important to you?"),
         )
        ],
      ),
    );
  }
}
