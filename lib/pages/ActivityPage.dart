import 'package:flutter/material.dart';
import 'package:flutter_frontend/jsonModels/Expense.dart';
import 'package:flutter_frontend/jsonModels/Expenses.dart';
import 'package:flutter_frontend/jsonModels/Saving.dart';
import 'package:flutter_frontend/jsonModels/Savings.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: ActivityPage(),
    ),
  ));
}

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  List<Expense>? expenses = [];
  List<Saving>? savings = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSavings();
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    List<Expense>? expenseData = await Expenses.fetchExpenses();
    if (mounted) {
      setState(() {
        expenses = expenseData;
        isLoading = false;
      });
    }
  }

  Future<void> fetchSavings() async {
    List<Saving>? savingsData = await Savings.fetchSavings();
    if (mounted) {
      setState(() {
        savings = savingsData;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Align(
              alignment: Alignment.centerLeft, // Выравнивает влево
              child: Text(
                "My Spendings",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  // fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          _displayListTile(
              context,
              "No expenses yet. Please plan you expenses on the BUDGETING PAGE",
              Icons.shopping_cart_outlined,
              expenses,
              _listOfExpenseProgress()),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Align(
              alignment: Alignment.centerLeft, // Выравнивает влево
              child: Text(
                "My Savings",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  // fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          _displayListTile(
              context,
              "No savings yet. Please plan you savings on the BUDGETING PAGE",
              Icons.savings,
              savings,
              _listOfSavingProgress()),
        ],
      ),
    );
  }

  Widget _displayListTile(BuildContext context, String noInfoYet1,
      IconData icon, List<dynamic>? list, Widget displayFunction) {
    if (isLoading) {
      return SizedBox(
          height: 200, child: Center(child: CircularProgressIndicator()));
    } else if (list == null || list.isEmpty) {
      // Если список пуст, показываем сообщение
      return Center(
        child: SizedBox(
          width: double.infinity, // Растягивает Column на всю ширину
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Icon(icon, size: 50, color: Colors.grey),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text(
                  noInfoYet1,
                  textAlign: TextAlign.center, // Центрируем сам текст
                  style: GoogleFonts.inder(fontSize: 18, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return displayFunction;
  }

  Widget _listOfExpenseProgress() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: expenses?.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
          child: _linearProgressIndicator(
              expenses?[index].amount ?? 0.0,
              expenses?[index].usedAmount ?? 0.0,
              expenses?[index].title ?? "",
              expenses?[index].category),
        );
      },
    );
  }

  Widget _listOfSavingProgress() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: savings?.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
          child: _linearProgressIndicator(
              savings?[index].targetAmount ?? 0.0,
              savings?[index].savedAmount ?? 0.0,
              savings?[index].title ?? "",
              null),
        );
      },
    );
  }

  void _showSpendingTransactionDialog(){
    //amount and card

  }

  Widget _linearProgressIndicator(
      double targetValue, double actualValue, String target, String? category) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        padding: EdgeInsets.all(10),
        height: 100,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(target,
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w400)),
                  Text(category?.toLowerCase() ?? "",
                      style: GoogleFonts.poppins(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                ]),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "\$ $actualValue",
                        style: GoogleFonts.poppins(
                          color: Colors.black, // Different color
                          fontSize: 16,
                          fontWeight: FontWeight.w500, // Bold for emphasis
                        ),
                      ),
                      TextSpan(
                        text: " / ",
                        style: GoogleFonts.poppins(
                          color: Colors.black, // Default color
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: "$targetValue",
                        style: GoogleFonts.poppins(
                          color: Colors.black, // Different color for target
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: LinearProgressIndicator(
                value: actualValue / targetValue,
                color: Colors.green,
                backgroundColor: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                minHeight: 5,
              ),
            )
          ],
        ));
  }
}
