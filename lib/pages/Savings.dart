import 'package:flutter/material.dart';

import '../models/AppTheme.dart';

void main() {
  runApp(MaterialApp(
    home: Savings(),
    theme: AppTheme.lightTheme,
  ));
}

class Savings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //extendBodyBehindAppBar: true,
        backgroundColor: AppTheme.mainBackColor,
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            children: [
              card(context),
              _savingsCard(
                  context, "Travel to Italy", Icons.beach_access_rounded, 0.8),
              _savingsCard(context, "House in Berlin", Icons.home, 0.5),
            ],
          ),
        )));
  }

  Widget _savingsCard(BuildContext context, String savingsName,
      IconData saveIcon, double savingsPercent) {
    return InkWell(
      onTap: () {},
      child: Center(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.all(10),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              color: AppTheme.widgetColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      // Icon(
                      //   saveIcon,
                      //   size: 40,
                      //   color: AppTheme.cardGreen,
                      // ),
                      SizedBox(width: 16),
                      Text(savingsName,
                          style: Theme.of(context).textTheme.titleMedium)
                    ],
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width * 0.7) *
                            savingsPercent,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.green.shade500,
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget card(BuildContext context){
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
                  colors: [Colors.green.shade400, Colors.green.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Total saved",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text("23 000 \$",
                              style: Theme.of(context).textTheme.bodyLarge)
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Rest of the sum",
                              style: Theme.of(context).textTheme.bodyMedium),
                          Text("8 300 \$",
                              style: Theme.of(context).textTheme.bodyLarge)
                        ],
                      ),
                    )
                  ],
                ),
                Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bar_chart,
                          size: 100,
                          color: AppTheme.widgetColor,
                        )
                      ],
                    ))
              ]),
              ),
            ),
      );
  }
}
