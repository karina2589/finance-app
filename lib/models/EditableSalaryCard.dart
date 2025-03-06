// import 'package:flutter/material.dart';
//
// import 'AppTheme.dart';
//
//
// class EditableProfileCard extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _EditableProfileCardState();
// }
//
// class _EditableProfileCardState extends State<EditableProfileCard> {
//   List<CardData> workCards = [CardData(workType: 'Freelance', salary: '1500')];
//   final List<String> workTypes = [
//     'Salary',
//     'Allowance',
//     'Comission',
//     'Investment',
//     'Interest',
//     'Royalty',
//     'Freelance',
//     'Other'
//   ];
//
//   void _addWorkCard() {
//     setState(() {
//       workCards.add(CardData(workType: workTypes[0], salary: ''));
//     });
//   }
//
//   void _updateWorkCard(int index, String type, String salary) {
//     setState(() {
//       workCards[index] = CardData(workType: type, salary: salary);
//     });
//   }
//
//   void _deleteWorkCard(int index) {
//     setState(() {
//       workCards.removeAt(index);
//     });
//   }
//
//   void _saveWorkCards() {
//     bool hasEmptyFields = workCards.any((card) => card.salary.trim().isEmpty);
//
//     if (hasEmptyFields) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(
//               'Please fill in all salary and work type fields before saving !!')));
//       return;
//     }
//     for (var card in workCards) {
//       print('Saved: ${card.workType}, Salary: ${card.salary}');
//     }
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Work cards saved successfully!')),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//         child: Card(
//           color: AppTheme.widgetColor,
//           shape:
//           RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               workCards.isEmpty
//                   ? Center(
//                   child: Column(
//                     children: [
//                       Icon(
//                         Icons.library_add_outlined,
//                         size: 200,
//                         color: AppTheme.accentColor,
//                       ),
//                       Text("You don't have any income yet. Add it!")
//                     ],
//                   ))
//                   : Expanded(
//                 child: ListView.builder(
//                   itemCount: workCards.length,
//                   itemBuilder: (context, index) {
//                     return SalaryCard(
//                       data: workCards[index],
//                       workTypes: workTypes,
//                       onChanged: (String type, String salary) {
//                         _updateWorkCard(index, type, salary);
//                       },
//                       onDelete: () {
//                         _deleteWorkCard(index);
//                       },
//                     );
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     ElevatedButton(
//                       onPressed: _addWorkCard,
//                       child: Text('Add Work Card'),
//                     ),
//                     ElevatedButton(
//                       onPressed: _saveWorkCards,
//                       child: Text('Save Work Cards'),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
//
// class SalaryCard extends StatelessWidget {
//   final CardData data;
//   final List<String> workTypes;
//   final void Function(String, String) onChanged;
//   final VoidCallback onDelete;
//
//   SalaryCard(
//       {required this.data,
//         required this.workTypes,
//         required this.onChanged,
//         required this.onDelete});
//
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController salaryController =
//     TextEditingController(text: data.salary);
//
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       color: AppTheme.accentColor,
//       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: DropdownButton<String>(
//                 value: data.workType,
//                 style: Theme.of(context).textTheme.titleSmall,
//                 isExpanded: true,
//                 onChanged: (newType) {
//                   if (newType != null) {
//                     onChanged(newType, data.salary);
//                   }
//                 },
//                 items: workTypes.map((type) {
//                   return DropdownMenuItem(
//                     value: type,
//                     child: Text(type, style: Theme.of(context).textTheme.titleSmall),
//                   );
//                 }).toList(),
//               ),
//             ),
//             SizedBox(width: 20),
//             Expanded(
//               child: TextField(
//                 controller: salaryController,
//                 style: Theme.of(context).textTheme.titleSmall,
//                 decoration: InputDecoration(
//                   labelText: 'Amount \$',
//                   labelStyle: Theme.of(context).textTheme.titleSmall,
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//                 onChanged: (newSalary) {
//                   onChanged(data.workType, newSalary);
//                 },
//               ),
//             ),
//             IconButton(
//               icon: Icon(Icons.delete, color: Colors.red),
//               onPressed: onDelete,
//             ),
//           ],
//         ),
//       ),
//     );
// //   }
// // }
//
// class CardData {
//   String cardName;
//   Map<String, double> incomes;
//
//   CardData({required this.cardName, required this.incomes});
// }
