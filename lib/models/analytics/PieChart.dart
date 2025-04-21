import 'package:flutter/material.dart';
import 'package:flutter_frontend/jsonModels/Analytics.dart';
import 'package:flutter_frontend/jsonModels/AnalyticsProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphic/graphic.dart';

// void main(){
//   runApp(MaterialApp(home: PieChart(),));
// }

class PieChart extends StatefulWidget{
  final List<Map<String, dynamic>> transactionsSummary;
  final int period;
  final double totalIncome;
  PieChart({
    required this.transactionsSummary,
    required this.period,
    required this.totalIncome
});
  @override
  State<StatefulWidget> createState() => PieChartState();
}

class PieChartState extends State<PieChart>{
  late List<Map<String, dynamic>> _displayData;

  // List<Map<String, dynamic>> totals = [];
  late double totalIncome ;
  bool isLoading = true;

  final List<Color> pieColors = [
    Color(0xFF0B132B),
    Color(0xFF2274A5),
    Color(0xFFC6E0FF),
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateGraph();
  }

  @override
  void didUpdateWidget(covariant PieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.period != widget.period || oldWidget.transactionsSummary != widget.transactionsSummary) {
      _updateGraph();
    }
  }

  void _updateGraph() async {
    setState(() => isLoading = true);
    await Future.delayed(Duration(milliseconds: 600)); // имитация подгрузки
    _displayData = widget.transactionsSummary;
    totalIncome = widget.totalIncome;
    setState(() => isLoading = false);
  }
  /*
  data should be in format

  const roseData = [
  {'value': 20, 'name': 'rose 1'},
  {'value': 10, 'name': 'rose 2'},
  {'value': 24, 'name': 'rose 3'},
  {'value': 12, 'name': 'rose 4'},
  {'value': 20, 'name': 'rose 5'},
  {'value': 15, 'name': 'rose 6'},
  {'value': 22, 'name': 'rose 7'},
  {'value': 29, 'name': 'rose 8'},
];
   */

  @override
  Widget build(BuildContext context) {
    return  Column(children: [isLoading? SizedBox(
      height: 200,
      child: Center(child: CircularProgressIndicator()),
    ): _pieChart()]
    );
  }

  Widget _pieChart(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pie Chart
        SizedBox(
          width: 200,
          height: 200,
          child: Chart(
            data: widget.transactionsSummary,
            variables: {
              'category': Variable(
                accessor: (Map map) => map['category'] as String,
              ),
              'amount': Variable(
                accessor: (Map map) => map['amount'] as num,
              ),
            },
            transforms: [
              Proportion(
                variable: 'amount',
                as: 'percent',
              )
            ],
            marks: [
              IntervalMark(
                position: Varset('percent') / Varset('category'),
                color: ColorEncode(
                  variable: 'category',
                  values: pieColors,
                ),
                // label: LabelEncode(
                //
                //   encoder: (tuple) => Label('${(tuple['percent'] * 100).toStringAsFixed(1)}%', ),
                // ),
                modifiers: [StackModifier()],
              ),
            ],
            selections: {
              'tap': PointSelection(
                on: {GestureType.tap},
              )
            },
            tooltip: TooltipGuide(
              variables: ['category', 'amount'],
              followPointer: [false, true],
              align: Alignment.topLeft,
              offset: const Offset(-20, -20),
            ),
            coord: PolarCoord(transposed: true, dimCount: 1),
          ),
        ),
        // Legend
        // Legend
        SizedBox(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Total Income: ${widget.totalIncome}',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ...List.generate(widget.transactionsSummary.length, (index) {
                final item = widget.transactionsSummary[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: pieColors[index],
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${item['category']}',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

}