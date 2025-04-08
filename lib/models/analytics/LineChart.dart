import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:flutter_frontend/models/analytics/data.dart';

void main(){
  runApp(MaterialApp(home: LineChart(),));
}

class LineChart extends StatelessWidget{
  bool isFirstTouch = true;  // Переменная для отслеживания первого касания

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            width: 350,
            height: 300,
          child:
            Chart(
            rebuild: false,
            data: invalidData,
            variables: {
              'Date': Variable(
                accessor: (Map map) => map['Date'] as String,
                scale: OrdinalScale(tickCount: 5),
              ),
              'Close': Variable(
                accessor: (Map map) => (map['Close'] ?? double.nan) as num,
              ),
            },
            marks: [
              LineMark(
                shape: ShapeEncode(value: BasicLineShape(smooth: true)),
                size: SizeEncode(value: 0.5),
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
            ],
            axes: [
              Defaults.horizontalAxis,
              Defaults.verticalAxis,
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
          )

        ),
      ),
      )
    );
  }
}