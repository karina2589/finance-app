import 'package:flutter/material.dart';
import 'package:flutter_frontend/jsonModels/AnalyticsProvider.dart';
import 'package:flutter_frontend/jsonModels/TransactionHistories.dart';
import 'package:flutter_frontend/jsonModels/TransactionHistory.dart';
import 'package:flutter_frontend/models/AppTheme.dart';
import 'package:flutter_frontend/models/DismissibleTasks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
//
// void main() {
//   runApp(MaterialApp(
//     home: MainPage(),
//     // theme: AppTheme.lightTheme,
//   ));
// }

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState()=>MainPageState();
}

class MainPageState extends State<MainPage>{
  List<TransactionHistory> transactions = [];
  Map<String, dynamic> balanceOverview = {};
  bool showAllTransactions = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBalanceOverview();
    getDataByPeriod();
  }

  void fetchBalanceOverview() async{
    Map<String, dynamic>? data = await AnalyticsProvider.balanceOverview();
    if(data!=null){
      setState(() {
        balanceOverview = data;
        print(balanceOverview);
      });
    }
  }

  void getDataByPeriod() async{
    List<TransactionHistory>? data = await TransactionHistories.fetchMonthTransactions();
    if(data!=null){
      setState(() {
        transactions = data;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mainBackColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _cashCard(context),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Current Month Transactions',
                    style: Theme.of(context).textTheme.titleMedium,
                  )),
            ),

            // last 7 transactions
            transactions.isEmpty?
            Padding(padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.compare_arrows_rounded, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "No transactions yet",
                    style: GoogleFonts.poppins(fontSize: 18, color: Colors.black54),
                  ),
                ],
              ),
            ),)
            :_transactionList(),

            // saving cards
          ],
        ),
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
                children: [_columnText(context, 'Total Balance', balanceOverview['currentBalance'] ?? 0)],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _columnText(context, 'Income', balanceOverview['totalIncome'] ?? 0),
                  _columnText(context, 'Expenses', balanceOverview['totalExpenses']?? 0)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _columnText(BuildContext context, String title, int subtitle) {
    final formatter = NumberFormat('#,###');
    String formatted = "${formatter.format(subtitle)} KZT";

    return Column(
      children: [
        Text(
          formatted,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _transactionList(){
    int visibleCount = showAllTransactions ? transactions.length : 3;
    return Column(
      children: [
        // Text("Statement transactions", style: GoogleFonts.poppins(
        //   fontSize: 18,
        //   fontWeight: FontWeight.w500,
        //   color: Colors.black,
        // ),),
        SizedBox(height: 15,),

        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: transactions.length < visibleCount ? transactions.length : visibleCount,
          itemBuilder: (context, index) {
            String amount = "";
            String type =
            transactions[index].type.toUpperCase() == "INCOME" ? "+" : "-";
            MaterialColor color = type == "+" ? Colors.green : Colors.red;
            String title = "not defined";

            if (transactions[index].type.toUpperCase() == "INCOME") {
              amount = " + ${transactions[index].amount}";
            } else {
              amount = " - ${transactions[index].amount}";
            }

            if(transactions[index].type.toLowerCase() == "saving"){
              title = transactions[index].saving!['title'];
            }else if(transactions[index].type.toLowerCase() == "expense"){
              title = transactions[index].expense!['title'];
            }else if(transactions[index].type.toLowerCase() == "income") {
              title = transactions[index].income!['title'];
            }else{
              title =  "not defined";
            }
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
                // border: Border.all(color: Colors.grey.shade300)
              ),
              // height: 50,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              width: MediaQuery.of(context).size.width * 0.8,
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                title: Text("$title", style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                )),
                subtitle: Text("${transactions[index].createdAt}", style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                )),
                trailing: Text("$amount KZT", style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: color,
                ),
                ),
              ),
            );
          },
        ),
        if (transactions.length > 3)
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                setState(() {
                  showAllTransactions = !showAllTransactions;
                });
              },
              child: RichText(
                  text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    children: [
                      TextSpan(
                        text : showAllTransactions ? "Hide" : "View All",
                      ),
                      WidgetSpan(child:
                      showAllTransactions ?
                      Icon(Icons.keyboard_arrow_up_rounded,  size: 20, color: Colors.blue):
                      Icon(Icons.keyboard_arrow_down_rounded,  size: 20, color: Colors.blue)
                      )
                    ]
                  )
              )
            ),
          ),
        SizedBox(height: 20),
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
