import 'package:flutter/material.dart';

class EditableTextRow extends StatefulWidget {
  final String label;
  final String initialValue;

  const EditableTextRow({required this.label, required this.initialValue, Key? key}) : super(key: key);

  @override
  _EditableTextRowState createState() => _EditableTextRowState();
}

class _EditableTextRowState extends State<EditableTextRow> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: 80, // Фиксированная ширина для метки
            child: Text(widget.label, style: Theme.of(context).textTheme.titleSmall),
          ),
          Expanded(
            child: _isEditing
                ? TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8)),
              onSubmitted: (_) => setState(() => _isEditing = false),
            )
                : GestureDetector(
              onTap: () => setState(() => _isEditing = true),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
                child: Text(_controller.text, style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
