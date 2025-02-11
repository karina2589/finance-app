import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/AppTheme.dart';
import 'package:flutter_frontend/models/DismissibleTasks.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mainBackColor,
      body: ListView(
        children: [
          _cashCard(context),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: Align(
                child: Text(
                  'Scheduled Payments',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                alignment: Alignment.bottomLeft),
          ),
          DismissibleTasks(),
          Row(
            children: [
              _savingsCard(
                  context, "Travel to Italy", Icons.beach_access_rounded, 0.8),
              _savingsCard(
                  context, "House in Berlin", Icons.house_outlined, 0.4)
            ],
          )
        ],
      ),
    );
  }

  Widget _cashCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 200,
      width: 330,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        //color: Colors.blueAccent,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.amber.shade300, Colors.amber.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_columnText(context, 'Total Balance', '\$ 80 000')],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _columnText(context, 'Income', '\$ 100 000'),
                  _columnText(context, 'Expenses', '\$ 30 000')
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _columnText(BuildContext context, String title, String subtitle) {
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    );
  }

  Widget _savingsCard(BuildContext context, String savingsName,
      IconData saveIcon, double savingsPercent) {
    return InkWell(
      child: Container(
          width: MediaQuery.of(context).size.width / 2 - 10,
          height: (MediaQuery.of(context).size.width / 2 - 10) * 0.6,
          margin: EdgeInsets.all(5.0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            color: AppTheme.widgetColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(
                //   saveIcon,
                //   size: 70,
                //   color: Colors.green.shade500,
                // ),
                Text(savingsName,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2 * 0.8,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width / 2 * 0.8) *
                          savingsPercent,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.green.shade500,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '\$ 750',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
      // onTap: () => Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => Savings()),
      //     )
    );
  }
}
