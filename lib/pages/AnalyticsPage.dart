import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/AppTheme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MaterialApp(
    home: AnalyticsPage(),
    theme: AppTheme.lightTheme,
  ));
}

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Center(
      child: Column(children: [
        SizedBox(
          height: 20,
        ),
        _analyticsCard(
            context,
            'General Balance Sheet: Income, Expenditure, Savings',
            'assets/images/image2.svg'),
        Divider(
          color: AppTheme.widgetColor,
          thickness: 2.0,
          indent: 50,
          // Space before the divider starts
          endIndent: 50,
        ),
        _analyticsCard(
            context,
            ' Regular payments (subscriptions, utilities, etc.)',
            'assets/images/image1.svg'),
        Divider(
          color: AppTheme.widgetColor,
          thickness: 2.0,
          indent: 50,
          // Space before the divider starts
          endIndent: 50,
        ),
        _analyticsCard(context, 'Distribution of expenditure by category',
            'assets/images/image3.svg'),
      ]),
    )));
  }

  Widget _analyticsCard(BuildContext context, String text, String path) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.green.shade50, width: 2.0)
          //color: AppTheme.widgetColor,
          ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
      child: Row(
        children: [
          Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade300,
                    Colors.green.shade400,
                    Colors.green.shade600,
                    Colors.green.shade600
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12)),
              ),
              child: SvgPicture.asset(
                path,
                width: 200,
                height: 150,
                colorFilter: ColorFilter.mode(
                  Colors.white, // Change this to your desired color
                  BlendMode
                      .srcIn, // Ensures the color replaces the original SVG color
                ),
              )),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.titleSmall,
                  )))
        ],
      ),
    );
  }

  Widget _analyticsCardReverse(BuildContext context, String text, String path) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade200,
              Colors.green.shade400,
              Colors.green.shade500
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
          borderRadius: BorderRadius.circular(15.0),
          // color: AppTheme.widgetColor,
          border: Border.all(color: AppTheme.widgetColor, width: 2.0)
          //color: AppTheme.widgetColor,
          ),
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
      child: Row(
        children: [
          Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ))),
          SvgPicture.asset(
            path,
            width: 200,
            height: 150,
          ),
        ],
      ),
    );
  }
}
