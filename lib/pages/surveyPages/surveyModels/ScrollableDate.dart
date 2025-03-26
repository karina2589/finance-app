import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:google_fonts/google_fonts.dart';

class ScrollableDate extends StatefulWidget {
  final TextEditingController date;
  final Function(String) onDateSelected;


  ScrollableDate({required this.date, required this.onDateSelected});

  @override
  State<StatefulWidget> createState() => _ScrollableDateState();
}

class _ScrollableDateState extends State<ScrollableDate> {
  DateTime selectedDate = DateTime(2000, 1, 1);

  void _scrollable(BuildContext context) {
    picker.DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1900, 1, 1),
        maxTime: DateTime.now(),
        theme: picker.DatePickerTheme(
          cancelStyle: TextStyle(color: Colors.black),
            headerColor: Colors.grey.shade100,
           // backgroundColor: Colors.grey.shade100,
            itemStyle: TextStyle(
                color: Colors.black,  fontSize: 18),
            doneStyle: TextStyle(color: Colors.black, fontSize: 16)),
        // onChanged: (date) {
        //   print('change $date in time zone ' +
        //       date.timeZoneOffset.inHours.toString());
        // },
        onConfirm: (date) {
      setState(() {
        selectedDate = date;
        widget.date.text =
        "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}";
        widget.onDateSelected(widget.date.text);
      });
      // print('confirm $date');
    }, currentTime: DateTime.now(), locale: picker.LocaleType.en);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      style: GoogleFonts.ubuntu(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w300),
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.calendar_today),

        // labelText: 'Your age',
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5),
        // Точная настройка отступов
       // fillColor: Colors.grey.shade200,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
         // borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          // borderSide: BorderSide(color: Colors.red),
        ),
      ),
      controller: widget.date,
      readOnly: true,
      onTap: () => _scrollable(context),
    );
  }
}
