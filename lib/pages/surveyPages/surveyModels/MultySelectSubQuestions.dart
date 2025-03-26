import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main(){
  runApp(MaterialApp(home: Temp(),));
}

class Temp extends StatelessWidget {
  final Map<String, List<String>> questionData = {
    "А": ["А.1", "А.2", "А.3"],
    "Б": ["Б.1", "Б.2"],
    "В": ["В.1", "В.2", "В.3"],
    "Г": [] // У Г нет под-вопросов
  };

  void handleAnswers(Map<String, List<String>> answers) {
    print("Выбранные ответы: $answers");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Опросник")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: MultiSelectQuestion(
            question: "Выберите варианты ответа:",
            optionsWithSubQuestions: questionData,
            onAnswersSelected: handleAnswers,
          ),
        ) ,
      )
    );
  }
}


class MultiSelectQuestion extends StatefulWidget {
  final String question;
  final Map<String, List<String>> optionsWithSubQuestions;
  final Function(Map<String, List<String>>) onAnswersSelected;

  MultiSelectQuestion({
    required this.question,
    required this.optionsWithSubQuestions,
    required this.onAnswersSelected,
  });

  @override
  _MultiSelectQuestionState createState() => _MultiSelectQuestionState();
}

class _MultiSelectQuestionState extends State<MultiSelectQuestion> {
  Map<String, bool> selectedMainOptions = {}; // Выбранные основные ответы
  Map<String, List<String>> selectedSubOptions = {}; // Под-вопросы

  @override
  void initState() {
    super.initState();
    widget.optionsWithSubQuestions.keys.forEach((option) {
      selectedMainOptions[option] = false;
      selectedSubOptions[option] = [];
    });
  }

  void _toggleMainOption(String option) {
    setState(() {
      selectedMainOptions[option] = !selectedMainOptions[option]!;
      if (!selectedMainOptions[option]!) {
        selectedSubOptions[option] = []; // Если сняли выбор, под-вопросы сбрасываются
      }
    });
    widget.onAnswersSelected(selectedSubOptions);
  }

  void _toggleSubOption(String mainOption, String subOption) {
    setState(() {
      if (selectedSubOptions[mainOption]!.contains(subOption)) {
        selectedSubOptions[mainOption]!.remove(subOption);
      } else {
        selectedSubOptions[mainOption]!.add(subOption);
      }
    });
    widget.onAnswersSelected(selectedSubOptions);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Основной вопрос
        Text(widget.question, style: GoogleFonts.inriaSans(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),

        // Основные варианты
        Column(
          children: widget.optionsWithSubQuestions.keys.map((option) {
            bool isSelected = selectedMainOptions[option]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _toggleMainOption(option),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green.shade100 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSelected ? Colors.green : Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            option,
                            style: GoogleFonts.inriaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.green[900] : Colors.black,
                            ),
                          ),
                        ),
                        if (isSelected) Icon(Icons.check, color: Colors.green),
                      ],
                    ),
                  ),
                ),

                // Под-вопросы (если выбрана основная опция)
                if (isSelected && widget.optionsWithSubQuestions[option]!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 5),
                    child: Column(
                      children: widget.optionsWithSubQuestions[option]!.map((subOption) {
                        bool isSubSelected = selectedSubOptions[option]!.contains(subOption);
                        return GestureDetector(
                          onTap: () => _toggleSubOption(option, subOption),
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 3),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSubSelected ? Colors.blue.shade100 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isSubSelected ? Colors.blue : Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    subOption,
                                    style: GoogleFonts.inriaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isSubSelected ? Colors.blue[900] : Colors.black,
                                    ),
                                  ),
                                ),
                                if (isSubSelected) Icon(Icons.check, color: Colors.blue),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
