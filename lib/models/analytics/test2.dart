import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphic/graphic.dart';

void main(){
  runApp(MaterialApp(home: Scaffold(body: PieChartWithLegend(),),));
}

class PieChartWithLegend extends StatelessWidget {
  final List<Map<String, dynamic>> totals = [
    {"category": "Saving", "amount": 300},
    {"category": "Spending", "amount": 500},
    {"category": "Income", "amount": 200},
  ];

  final List<Color> pieColors = [
    Color(0xFF0B132B),
    Color(0xFFC6E0FF),
    Color(0xFF317B22),
  ];

  @override
  Widget build(BuildContext context) {

    return Column(children: [Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pie Chart
        SizedBox(
          width: 250,
          height: 250,
          child: Chart(
            data: totals,
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
        Padding(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(totals.length, (index) {
              final item = totals[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
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
                    Text(
                      '${item['category']}: ${item['amount']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            }),
          ),)

      ],
    )]);
  }
}
