import 'package:flutter/material.dart';

class YesNoDropdown extends StatefulWidget {
  @override
  _YesNoDropdownState createState() => _YesNoDropdownState();
}

class _YesNoDropdownState extends State<YesNoDropdown> {
  String? selectedAnswer;
  String? selectedOption; // Для выпадающего списка дополнительных вопросов

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Yes/No Selection")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Выберите ответ:"),
            DropdownButton<String>(
              value: selectedAnswer,
              hint: Text("Выберите Да или Нет"),
              items: ["Да", "Нет"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedAnswer = newValue;
                  selectedOption = null; // Сбрасываем дополнительный вопрос
                });
              },
            ),

            // Если пользователь выбрал "Да", показываем дополнительные вопросы
            if (selectedAnswer == "Да") ...[
              SizedBox(height: 20),
              Text("Выберите один из вариантов:"),
              DropdownButton<String>(
                value: selectedOption,
                hint: Text("Выберите вариант"),
                items: ["Вариант 1", "Вариант 2", "Вариант 3"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOption = newValue;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: YesNoDropdown(),
  ));
}
