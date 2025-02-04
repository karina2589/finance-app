import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Work Card List')),
      body: EditableWorkCards(),
    ),
  ));
}

class EditableWorkCards extends StatefulWidget {
  @override
  _EditableWorkCardsState createState() => _EditableWorkCardsState();
}

class _EditableWorkCardsState extends State<EditableWorkCards> {
  List<WorkCardData> workCards = [];
  final List<String> workTypes = ['Full-Time', 'Part-Time', 'Freelance'];

  // Добавление новой карточки
  void _addWorkCard() {
    setState(() {
      workCards.add(WorkCardData(type: workTypes[0], salary: ''));
    });
  }

  // Обновление данных карточки
  void _updateWorkCard(int index, String type, String salary) {
    setState(() {
      workCards[index] = WorkCardData(type: type, salary: salary);
    });
  }

  // Удаление карточки
  void _deleteWorkCard(int index) {
    setState(() {
      workCards.removeAt(index);
    });
  }

  // Сохранение карточек с проверкой
  void _saveWorkCards() {
    bool hasEmptyFields = workCards.any((card) => card.salary.trim().isEmpty);

    if (hasEmptyFields) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all salary fields before saving!')),
      );
      return;
    }

    // Сохранение данных (здесь можно заменить на API-запрос или локальное хранилище)
    for (var card in workCards) {
      print('Saved: ${card.type}, Salary: ${card.salary}');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Work cards saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Кнопки "Добавить" и "Сохранить"

        Expanded(
          child: ListView.builder(
            itemCount: workCards.length,
            itemBuilder: (context, index) {
              return WorkCard(
                data: workCards[index],
                workTypes: workTypes,
                onChanged: (String type, String salary) {
                  _updateWorkCard(index, type, salary);
                },
                onDelete: () {
                  _deleteWorkCard(index);
                },
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: _addWorkCard,
              child: Text('Add Work Card'),
            ),
            ElevatedButton(
              onPressed: _saveWorkCards,
              child: Text('Save Work Cards'),
            ),
          ],
        ),
      ],
    );
  }
}

class WorkCard extends StatelessWidget {
  final WorkCardData data;
  final List<String> workTypes;
  final void Function(String, String) onChanged;
  final VoidCallback onDelete;

  WorkCard({
    required this.data,
    required this.workTypes,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController salaryController = TextEditingController(text: data.salary);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DropdownButton<String>(
                value: data.type,
                isExpanded: true,
                onChanged: (newType) {
                  if (newType != null) {
                    onChanged(newType, data.salary);
                  }
                },
                items: workTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: TextField(
                controller: salaryController,
                decoration: InputDecoration(
                  labelText: 'Salary',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (newSalary) {
                  onChanged(data.type, newSalary);
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class WorkCardData {
  String type;
  String salary;

  WorkCardData({required this.type, required this.salary});
}
