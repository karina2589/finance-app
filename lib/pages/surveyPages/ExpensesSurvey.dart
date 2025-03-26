import 'package:flutter/material.dart';

class ExpensesSurvey extends StatelessWidget{
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
              "Your expenses",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}