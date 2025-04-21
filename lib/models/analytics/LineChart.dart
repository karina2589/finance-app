import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphic/graphic.dart';


// void main() {
//   runApp(MaterialApp(
//     home: LineChart(),
//   ));
// }

class LineChart extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;
  final int period;

  LineChart({required this.transactions, required this.period});

  @override
  State<StatefulWidget> createState()=> LineChartState();
}

class LineChartState extends State<LineChart>{
  late List<Map<String, dynamic>> _displayData;
  bool isFirstTouch = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _updateGraph();
  }

  @override
  void didUpdateWidget(covariant LineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.period != widget.period || oldWidget.transactions != widget.transactions) {
      _updateGraph();
    }
  }

  void _updateGraph() async {
    setState(() => isLoading = true);
    await Future.delayed(Duration(milliseconds: 600)); // имитация подгрузки
    _displayData = widget.transactions;
    setState(() => isLoading = false);
  }


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
    final step = (maxValue / 4)
        .ceilToDouble(); // делим на 4 — т.к. 5 делений = 4 промежутка
    final maxRounded = step * 4;

    // Генерируем 5 равных значений
    return List.generate(5, (i) => step * i);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          "Expenses line graph",
          style: GoogleFonts.poppins(
              fontSize: 17, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        lineGraph(widget.transactions),

        // SizedBox(
        //   height: 20,
        // ),
        // Text("Savings line graph",  style: GoogleFonts.poppins(
        //     fontSize: 17, fontWeight: FontWeight.w400, color: Colors.black)),
        // lineGraph(transactions2),
      ],
    ));
  }


  Widget lineGraph(List<Map<String, dynamic>> data) {
    return   isLoading?  SizedBox(
    height: 250,
    child: Center(child: CircularProgressIndicator()),
    ) : data.isEmpty
        ? Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              "No transactions yet",
              style: GoogleFonts.inder(fontSize: 18, color: Colors.black54),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inder(
                      fontSize: 16, color: Colors.black54),
                  children: [
                    TextSpan(
                        text:
                        "Please add new transactions for showing analytics"),
                    // WidgetSpan(
                    //   child: Icon(Icons.add_circle_outline,
                    //       size: 20, color: Colors.black54),
                    // ),
                    TextSpan(text: "Not enough data to show analytics"),
                  ],
                ),
              ),
            ),
          ],
        ))
        :Container(
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
                  scale: LinearScale(min: 0, ticks: getYAxisTicks(data)),
                ),
              },
              marks: [
                AreaMark(
                  shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
                  color:
                      ColorEncode(value: Defaults.colors10.first.withAlpha(80)),
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
                Defaults.horizontalAxis
                  ..label = LabelStyle(
                      textStyle: GoogleFonts.poppins(
                        fontSize: 11,
                        // fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      offset: Offset(5, 8))
                // ..label = LabelStyle(
                //   // rotation: 30,
                //   align: Alignment.centerRight, // Align the labels to the right
                // ),
                ,
                Defaults.verticalAxis
                  ..label = LabelStyle(
                      textStyle: GoogleFonts.poppins(
                        fontSize: 11,
                        // fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      offset: Offset(-5, 0)),
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
