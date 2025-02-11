import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/AppTheme.dart';
import 'package:flutter_frontend/models/CardSwiper.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/DismissibleTasks.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(body: BudgetPlanner()),
    theme: AppTheme.lightTheme,
  ));
}

class BudgetPlanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CardSwiper(),

              _buttonBuilder(context, 'Add payment', () {}, Icons.add),
              _buttonBuilder(context, 'Upload bank statement', () {}, Icons.upload_outlined),
              _buttonBuilder(context, 'Calculate budget plan', () {}, Icons.calculate_outlined),
          //Align(alignment:Alignment.centerLeft, child: Text('Scheduled Payments', style: Theme.of(context).textTheme.titleMedium,)),
        //  DismissibleTasks(), // Теперь список занимает столько места, сколько нужно
        ],
      ),
    );
  }

  Widget _buttonBuilder(BuildContext context, String buttonName,
      VoidCallback onpressed, IconData icon) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
        child: OutlinedButton(
          onPressed: onpressed,
          style: OutlinedButton.styleFrom(
            shadowColor: AppTheme.widgetColor,
            iconColor: Colors.black38,
            side: BorderSide(color: AppTheme.widgetColor, width: 2.0),
            fixedSize: Size(MediaQuery.of(context).size.width *0.8, 70),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            backgroundColor: Colors.white,
          ),
          child: Row(
            children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Icon(icon),),
              Text(buttonName,
                  style: GoogleFonts.inder(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ));
  }
}
