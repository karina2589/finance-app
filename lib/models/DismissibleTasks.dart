import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/AppTheme.dart';

class ScheduledPayment {
  double amount;
  String title;

  ScheduledPayment({required this.amount, required this.title});
}

void main(){
  runApp(MaterialApp(home: DismissibleTasks(),));
}
class DismissibleTasks extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DismissibleTasksState();
}

class _DismissibleTasksState extends State<DismissibleTasks> {
  List<ScheduledPayment> _tasks = [
    ScheduledPayment(amount: 2.99, title: 'Spotify subscription'),
    ScheduledPayment(amount: 10, title: 'Public utilities'),
    ScheduledPayment(amount: 5.99, title: 'Netflix subscription')
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _tasks.length,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: ValueKey<String>(_tasks[index].title),
                direction: DismissDirection.endToStart, // Только вправо
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.green,
                  child: const Icon(Icons.check, color: Colors.white, size: 32),
                ),
                onDismissed: (direction) {
                  setState(() {
                    _tasks.removeAt(index);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFFF5F5F5),
                    
                  ),
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: ListTile(
                    title: Text(
                      _tasks[index].title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    subtitle: Text('\$${_tasks[index].amount.toStringAsFixed(2)}'),
                  ),
                ),
              );
            },
    );
  }
}
