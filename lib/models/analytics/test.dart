import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:flutter_frontend/models/analytics/data.dart';

void main() {
  runApp(MaterialApp(home: LineChart()));
}

class LineChart extends StatefulWidget {
  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  List<Map<String, dynamic>> _data = [];
  final List<Map<String, dynamic>> _fullData = invalidData;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = IntTween(begin: 0, end: _fullData.length).animate(_controller)
      ..addListener(() {
        setState(() {
          _data = _fullData.take(_animation.value).toList();
        });
      });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            width: 350,
            height: 300,
            child: Chart(
              rebuild: true,
              data: _data,
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
                  transition: Transition(duration: const Duration(seconds: 2)),
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
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
