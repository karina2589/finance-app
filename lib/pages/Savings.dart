import 'package:flutter/material.dart';

import '../models/AppTheme.dart';

class Savings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppTheme.mainBackColor,
      body: ListView(
        children: [
          _cash(context),
          _savingsCard(
              context, "Travel to Italy", Icons.beach_access_rounded, 0.8),
          _savingsCard(context, "House in Berlin", Icons.home, 0.5),
        ],
      ),
    );
  }

  Widget _savingsCard(BuildContext context, String savingsName,
      IconData saveIcon, double savingsPercent) {
    return InkWell(
      onTap: () {},
      child: Center(
        child: Container(
            width: MediaQuery.of(context).size.width ,
            height: 150,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.all(16),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              color: AppTheme.widgetColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 10,),
                      Icon(
                        saveIcon,
                        size: 40,
                        color: AppTheme.iconsSecond,
                      ),
                      SizedBox(width: 16),
                      Text(savingsName,
                          style: Theme.of(context).textTheme.bodyLarge)
                    ],
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Color(0xFFB4DCF9),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width * 0.7) *
                            savingsPercent,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.blue,
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

  Widget _cash(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width*0.55,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 2.5),
      child: Card(
          color: AppTheme.widgetColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child:  Stack(children: [ Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Total saved", style: Theme.of(context).textTheme.titleMedium,),
                    Text("23 000 \$", style: Theme.of(context).textTheme.titleMedium)
                  ],
                ),
              ),

              Padding(padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Rest of the sum", style: Theme.of(context).textTheme.titleMedium),
                    Text("8 300 \$", style: Theme.of(context).textTheme.titleMedium)
                  ],
                ),
              )
            ],
          ),
            Center(child:Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.bar_chart, size: 130, color: AppTheme.primaryColor,)
              ],
            ))]
      ),
    )
    );
  }
}
