import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectableOptions extends StatefulWidget {
  final List<String> options;
  final bool allowMultipleSelectedOptions;
  final ValueChanged<Set<String>> onSelectionChanged;
  final String question;
  final Set<String> initialSelection;


  SelectableOptions(
      {required this.options,
      super.key,
      required this.allowMultipleSelectedOptions, required this.onSelectionChanged, required this.question, required this.initialSelection});

  @override
  State<StatefulWidget> createState() => _SelectableOptionsState();
}

class _SelectableOptionsState extends State<SelectableOptions> {
  late Set<String> selectedOptions;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedOptions = Set.from(widget.initialSelection);
  }

   Set<String> get selectedOption{
    return selectedOptions;
  }

  void _toggleSelection(String option) {
    setState(() {
      if (widget.allowMultipleSelectedOptions) {
        if (selectedOptions.contains(option)) {
          selectedOptions.remove(option);
        } else {
          selectedOptions.add(option);
        }
      } else {
        selectedOptions.clear();
        selectedOptions.add(option);
      }
    });

    widget.onSelectionChanged(selectedOptions); // <-- Передаём выбранные данные родителю
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.grey.shade300)),
        width: MediaQuery.of(context).size.width * 0.7,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child:
            Text(
              textAlign: TextAlign.center,
              widget.question,
              style: GoogleFonts.inriaSans(
                color: Colors.black,
                  fontSize: 18, fontWeight: FontWeight.w500),
               ),
            ),

            ListView.builder(
              primary: false,
              shrinkWrap: true,
              //physics: NeverScrollableScrollPhysics(),
              itemCount: widget.options.length, // Используем widget.options
              itemBuilder: (context, index) {
                final option = widget.options[index];
                final isSelected = selectedOptions.contains(option);
                return GestureDetector(
                  onTap: () => _toggleSelection(option),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.green.shade100
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color:
                              isSelected ? Colors.green : Colors.grey.shade200),
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
                              color:
                                  isSelected ? Colors.green[900] : Colors.black,
                            ),
                          ),
                        ),
                        if (isSelected) Icon(Icons.check, color: Colors.green),
                      ],
                    ),
                  ),
                );
              },
            ),

          ],
        ));
  }
}
