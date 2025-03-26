import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldQuestion extends StatefulWidget {
  TextEditingController controller;
  String question;
  String questionKey;
  String errorMessage;
  final Function(String) onAnswer;

  TextFieldQuestion({required this.controller,
    required this.question,
    required this.questionKey,
    required this.errorMessage, required this.onAnswer
  });
  @override
  State<StatefulWidget> createState() => _TextFieldState();
}


class _TextFieldState extends State<TextFieldQuestion>{

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.7,
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.grey.shade300)),
        child: Column(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Text(
                widget.question,
                style: GoogleFonts.inriaSans(
                  color: Colors.black,
                    fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 35,
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextField(
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.number,
                controller: widget.controller,
                style: GoogleFonts.inriaSans(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  // fontStyle: FontStyle.italic
                ),
                decoration: InputDecoration(
                  // labelText: 'Your age',
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  // Точная настройка отступов
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    // borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                onChanged: (newValue) {
                  if (int.tryParse(newValue) == null ||
                      int.parse(newValue) <= 0) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(widget.errorMessage)));
                    return;
                  } else {
                    setState(() {
                      widget.onAnswer(newValue);
                    });
                  }
                },
              ),
            )
          ],
        ));
  }
}
