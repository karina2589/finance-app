import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/AppTheme.dart';
import 'package:flutter_frontend/pages/Savings.dart';

import 'package:flutter_frontend/models/AppTheme.dart';




class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mainBackColor,
      body: ListView(
        children: [
          _analytics(context),
          _incomeVal(context),
          _Checkbox(),
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

  Widget _analytics(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 2.5),
      child: Card(
          color: AppTheme.widgetColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                // Внутренние отступы вокруг изображения
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    // Скругление изображения
                    child: const Icon(Icons.pie_chart,
                        size: 180, color: AppTheme.primaryColor)),
              ),
              const Expanded(
                  child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "house expenses  20%\nsavings for car  5%\nsavings for flat  5%\nfood expenses  10%\ntaxes  20%\n other 40%",
                  style: TextStyle(fontSize: 15),
                ),
              ))
            ],
          )),
    );
  }

  Widget _incomeVal(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: MediaQuery.of(context).size.width / 2 - 15,
            height: 100,
            margin: EdgeInsets.all(5.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              color: AppTheme.widgetColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("1500\$", style: Theme.of(context).textTheme.titleLarge),
                  Text(
                    "Income",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )),
        Container(
            width: MediaQuery.of(context).size.width / 2 - 15,
            height: 100,
            margin: EdgeInsets.all(5.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              color: AppTheme.widgetColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("900\$", style: Theme.of(context).textTheme.titleLarge),
                  Text("Monthly expenses",
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ))
      ],
    );
  }

  Widget _savingsCard(BuildContext context, String savingsName,
      IconData saveIcon, double savingsPercent) {
    return InkWell(
        child: Container(
            width: MediaQuery.of(context).size.width / 2 - 10,
            height: 200,
            margin: EdgeInsets.all(5.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              color: AppTheme.widgetColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    saveIcon,
                    size: 70,
                    color: AppTheme.iconsSecond,
                  ),
                  Text(savingsName,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2 * 0.8,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Color(0xFFB4DCF9),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width / 2 * 0.8) *
                            savingsPercent,
                        height: 30,
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
        // onTap: () => Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => Savings()),
        //     )
    );
  }
}

class _Checkbox extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CheckboxState();
}

class _CheckboxState extends State<_Checkbox> {
  List<Task> tasks = [
    Task('Spotify subscription', false, 2.0),
    Task('YouTube subscription', false, 1.99),
    Task('Public utilities', false, 150.0),
    Task('Gym payment', false, 15.0),
  ];

  void _updateTask(int index, bool? value) {
    setState(() {
      tasks[index].isChecked = value!;
    });
  }

  void _removeCompletedTask() {
    setState(() {
      tasks.removeWhere((task) => task.isChecked);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 20,
        margin: EdgeInsets.fromLTRB(10, 2.5, 10, 2.5),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          color: AppTheme.widgetColor,
          child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Center(
                  child: Text(
                "Planned payments",
                style: Theme.of(context).textTheme.titleMedium,
              )),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(
                      tasks[index].task,
                      style: tasks[index].isChecked
                          ? const TextStyle(
                              decoration: TextDecoration.lineThrough)
                          : Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text(tasks[index].amount.toString() + " \$"),
                    value: tasks[index].isChecked,
                    onChanged: (bool? value) {
                      _updateTask(index, value);
                    },
                  );
                },
                itemCount: tasks.length,
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () {}, child: Text("Remove completed tasks")),
              )
            ],
          ),
        ));
  }
}

class Task {
  String task;
  bool isChecked;
  double amount;

  Task(this.task, this.isChecked, this.amount);
}
