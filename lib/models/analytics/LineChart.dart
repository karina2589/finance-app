import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/analytics/transactionData.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphic/graphic.dart';
import 'package:flutter_frontend/models/analytics/data.dart';

void main() {
  runApp(MaterialApp(
    home: LineChart(),
  ));
}

class LineChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LineChartState();
}

class LineChartState extends State<LineChart> {
  List<Map<String, dynamic>> expenses = [];
  List<Map<String, dynamic>> savings = [];

  bool isFirstTouch = true;
  bool isLoading = true;

  List<String> getTicks(List<Map<String, dynamic>> data) {
    final allDates = data.map((e) => e['Date'].toString()).toList();
    final int midIndex = (allDates.length / 2).floor();
    final customTicks = [
      allDates.first,
      allDates[midIndex],
      allDates.last,
    ];
    return customTicks;
  }

  List<double> getYAxisTicks(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return [0, 1, 2, 3, 4];

    final amounts = data.map((e) => (e['Amount'] ?? 0) as num).toList();
    final maxValue = amounts.reduce((a, b) => a > b ? a : b).toDouble();

    // Округляем вверх до ближайшего "удобного" числа
    final step = (maxValue / 4).ceilToDouble(); // делим на 4 — т.к. 5 делений = 4 промежутка
    final maxRounded = step * 4;

    // Генерируем 5 равных значений
    return List.generate(5, (i) => step * i);
  }


  void getData() async {
    final transactionData = TransactionData();
    await transactionData.loadTransactions();

    setState(() {
      print("Expense:");
      expenses = _aggregateByDate(transactionData.expenseTransactions);
      print(transactionData.expenseTransactions);
      print(expenses);

      print("Saving:");
      savings = _aggregateByDate(transactionData.savingTransactions);
      print(transactionData.savingTransactions);
      print(savings);
      isLoading = false;
    });
  }

  List<Map<String, dynamic>> _aggregateByDate(
      List<Map<String, dynamic>> transactions) {
    final Map<String, double> aggregated = {};

    for (var tx in transactions) {
      final date = tx['Date'].toString() ?? null;
      final amount = tx['Amount'];

      if (date == null || amount == null) continue;

      final parsedAmount = (amount as num).toDouble();

      if (aggregated.containsKey(date)) {
        aggregated[date] = aggregated[date]! + parsedAmount;
      } else {
        aggregated[date] = parsedAmount;
      }
    }
    print(aggregated);

// Преобразуем в List<Map<String, double>>
    List<Map<String, dynamic>> result =
        aggregated.entries.map<Map<String, dynamic>>((entry) {
      return {
        "Date": entry.key,
        "Amount": entry.value.toDouble(), // обязательно приведение к double
      };
    }).toList();

    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
                child: Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text("Expenses line graph", style: GoogleFonts.poppins(
            fontSize: 17, fontWeight: FontWeight.w400, color: Colors.black),),
        lineGraph(expenses),

        SizedBox(
          height: 20,
        ),
        Text("Savings line graph",  style: GoogleFonts.poppins(
            fontSize: 17, fontWeight: FontWeight.w400, color: Colors.black)),
        lineGraph(savings),
      ],
    ));
  }

  Widget lineGraph(List<Map<String, dynamic>> data) {
    return isLoading
        ?  Container(
        margin: EdgeInsets.all(100),
        child: CircularProgressIndicator())
        : Container(
            margin: const EdgeInsets.only(top: 10),
            width: 350,
            height: 250,
            child: Chart(
              rebuild: false,
              data: data,
              variables: {
                'Date': Variable(
                  accessor: (Map map) => (map['Date'].toString()),
                  // Лучше подставить -1 или 0
                  scale: OrdinalScale(ticks: getTicks(data)),
                ),
                'Amount': Variable(
                  accessor: (Map map) => (map['Amount'] ?? double.nan) as num,
                  scale: LinearScale(min: 0,  ticks: getYAxisTicks(data)),
                ),
              },
              marks: [
                AreaMark(
                  shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
                  color: ColorEncode(
                      value: Defaults.colors10.first.withAlpha(80)),
                ),

                LineMark(
                  shape: ShapeEncode(value: BasicLineShape(smooth: true)),
                  size: SizeEncode(value: 1.5),
                  // transition: Transition(
                  //   duration: const Duration(seconds: 2), // Продолжительность анимации
                  //   curve: Curves.linear, // Тип кривой анимации
                  // ),
                  entrance: {
                    MarkEntrance.x,
                    MarkEntrance.y,
                    MarkEntrance.opacity,
                  },
                ),

                PointMark(
                  size: SizeEncode(value: 6),
                  color: ColorEncode(value: Colors.deepPurple),
                  shape: ShapeEncode(value: CircleShape()),
                  selected: {
                    'touchMove': {0, 3} // выбраны точки с индексами 0 и 3
                  },

                ),
              ],
              axes: [
                Defaults.horizontalAxis..label = LabelStyle(
                  textStyle: GoogleFonts.poppins(
                    fontSize: 11,
                    // fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  offset: Offset(5, 8)
                )
                // ..label = LabelStyle(
                //   // rotation: 30,
                //   align: Alignment.centerRight, // Align the labels to the right
                // ),
                ,
                Defaults.verticalAxis..label = LabelStyle(
                    textStyle: GoogleFonts.poppins(
                      fontSize: 11,
                      // fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  offset: Offset(-5, 0)
                ),
              ],
              // coord: RectCoord(color: const Color(0xffdddddd)),
              selections: {
                'touchMove': PointSelection(
                  on: {
                    GestureType.scaleUpdate,
                    GestureType.tapDown,
                    GestureType.longPressMoveUpdate
                  },
                  dim: Dim.x,
                ),
              },
              tooltip: TooltipGuide(
                followPointer: [false, true],
                align: Alignment.topLeft,
                offset: const Offset(-20, -20),
              ),
              crosshair: CrosshairGuide(followPointer: [true, true]),
            ));
  }
}
