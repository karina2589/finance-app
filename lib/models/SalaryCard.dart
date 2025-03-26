import 'package:flutter/material.dart';

import '../pages/draft.dart';
import 'AppTheme.dart';

class SalaryCard extends StatelessWidget {
  final String salary;
  final String workType;
  final List<String> workTypes;
  final void Function(String, String) onChanged;
  final VoidCallback onDelete;

  SalaryCard(
      {
        required this.workTypes,
        required this.onChanged,
        required this.onDelete, required this.salary, required this.workType});

  @override
  Widget build(BuildContext context) {
    TextEditingController salaryController =
    TextEditingController(text: salary);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: AppTheme.accentColor,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DropdownButton<String>(
                value: workType,
                style: Theme.of(context).textTheme.titleSmall,
                isExpanded: true,
                onChanged: (newType) {
                  if (newType != null) {
                    onChanged(newType, salary);
                  }
                },
                items: workTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type, style: Theme.of(context).textTheme.titleSmall),
                  );
                }).toList(),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: TextField(
                controller: salaryController,
                style: Theme.of(context).textTheme.titleSmall,
                decoration: InputDecoration(
                  labelText: 'Amount \$',
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (newSalary) {
                  onChanged(workType, newSalary);
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
