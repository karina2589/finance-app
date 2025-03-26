import 'package:flutter/material.dart';

import 'package:flutter_frontend/pages/surveyPages/AboutYouSurvey.dart';
import 'package:flutter_frontend/pages/surveyPages/ExpensesSurvey.dart';
import 'package:flutter_frontend/pages/surveyPages/FinancialGoalsSurvey.dart';

void main() {
  runApp(const SurveyApp());
}

class SurveyApp extends StatelessWidget {
  const SurveyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SurveyScreen(),
    );
  }
}



class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final Map<String, String> about_qa = {};
  final Map<String, String> financialGoals_qa = {};
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<bool> pageVisited = [true,false];

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _updateState(){
    setState(() {
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      pageVisited[index] = true;
    });
  }

 bool _isPageCompleted(int pageIndex){
    if(pageIndex==0){
      return about_qa.length>=3;
    }else if(pageIndex==1){
      return financialGoals_qa.length>=3;
    }
    return false;
 }

 Color _getIndicatorColor(int pageIndex){
    if(!pageVisited[pageIndex]){
      return Colors.grey;
    }
    return _isPageCompleted(pageIndex)? Colors.green : Colors.amber;
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade100,
      body: Row(
        children: [
          // Progress indicator
          Container(
            width: 50,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                return Column(
                  children: [
                    CircleAvatar(
                      backgroundColor:_getIndicatorColor(index),
                      radius: 15,
                    ),
                    if (index < 1) ...[
                      Container(
                        height: 150,
                        width: 2,
                        color: Colors.grey,
                      ),
                    ]
                  ],
                );
              }),
            ),
          ),
          // PageView
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children:  [
                SurveyPage( content: AboutYouSurvey(aboutYouQA: about_qa, updateState: _updateState,)),
                //SurveyPage( content: ExpensesSurvey(), ),
                SurveyPage( content: FinancialGoalsSurvey(financialGaolsQA: financialGoals_qa, updateState: _updateState,)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade500,
        onPressed: _nextPage,
        child:  Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }
}

class SurveyPage extends StatelessWidget {
  final Widget content;
  const SurveyPage({super.key, required this.content});

  @override
  Widget build(BuildContext context) {

    return content;
  }
}
