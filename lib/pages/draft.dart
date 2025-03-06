// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MaterialApp(home: FinanceApp()));
// }
//
// class FinanceApp extends StatefulWidget {
//   @override
//   _FinanceAppState createState() => _FinanceAppState();
// }
//
// class _FinanceAppState extends State<FinanceApp> {
//   List<CardData> cards = [
//     CardData(name: "Основная карта", incomes: [
//       Income(type: "Зарплата", amount: 50000),
//       Income(type: "Фриланс", amount: 15000)
//     ]),
//     CardData(name: "Дополнительная карта", incomes: [
//       Income(type: "Инвестиции", amount: 20000)
//     ]),
//   ];
//
//   void openEditPopup(CardData card) async {
//     CardData? updatedCard = await showDialog(
//       context: context,
//       builder: (context) => EditCardDialog(card: card),
//     );
//
//     if (updatedCard != null) {
//       setState(() {
//         int index = cards.indexOf(card);
//         cards[index] = updatedCard;
//       });
//     }
//   }
//
//   void addNewCard() {
//     setState(() {
//       cards.add(CardData(name: "Новая карта", incomes: []));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Финансовое приложение")),
//       body: ListView.builder(
//         itemCount: cards.length + 1,
//         itemBuilder: (context, index) {
//           if (index == cards.length) {
//             return ListTile(
//               leading: Icon(Icons.add),
//               title: Text("Добавить карту"),
//               onTap: addNewCard,
//             );
//           }
//           return ListTile(
//             title: Text(cards[index].name),
//             subtitle: Text("${cards[index].incomes.length} источника дохода"),
//             trailing: Icon(Icons.edit),
//             onTap: () => openEditPopup(cards[index]),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class EditCardDialog extends StatefulWidget {
//   final CardData card;
//
//   EditCardDialog({required this.card});
//
//   @override
//   _EditCardDialogState createState() => _EditCardDialogState();
// }
//
// class _EditCardDialogState extends State<EditCardDialog> {
//   late TextEditingController nameController;
//   late List<Income> incomes;
//   bool hasChanges = false;
//
//   List<String> incomeTypes = ["Зарплата", "Фриланс", "Инвестиции", "Бизнес", "Пассивный доход"];
//
//   @override
//   void initState() {
//     super.initState();
//     nameController = TextEditingController(text: widget.card.name);
//     incomes = widget.card.incomes.map((income) => Income(type: income.type, amount: income.amount)).toList();
//   }
//
//   void updateChanges() {
//     setState(() {
//       hasChanges = nameController.text != widget.card.name ||
//           incomes.length != widget.card.incomes.length ||
//           !List.generate(incomes.length, (index) {
//             return incomes[index].type == widget.card.incomes[index].type &&
//                 incomes[index].amount == widget.card.incomes[index].amount;
//           }).every((element) => element);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: "Название карты"),
//               onChanged: (value) => updateChanges(),
//             ),
//             SizedBox(height: 10),
//             Text("Доходы", style: TextStyle(fontWeight: FontWeight.bold)),
//             Column(
//               children: List.generate(incomes.length, (index) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   mainAxisSize: MainAxisSize.min,
//
//                   children: [
//                     Expanded(
//                       child: DropdownButtonFormField<String>(
//                         isExpanded: true,
//                         value: incomes[index].type.isNotEmpty ? incomes[index].type : incomeTypes.first,
//                         hint: Text("Выберите доход"),
//                         items: incomeTypes.map((String type) {
//                           return DropdownMenuItem<String>(
//                             value: type,
//                             child: Text(type),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             incomes[index] = Income(type: value!, amount: incomes[index].amount);
//                             updateChanges();
//                           });
//                         },
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(
//                       child: TextFormField(
//                         controller: incomes[index].amou,
//                         keyboardType:
//                         TextInputType.number,
//                         decoration: InputDecoration(
//                           labelText: "Сумма",
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.trim().isEmpty) {
//                             return "Введите сумму";
//                           }
//                           if (double.tryParse(value) == null) {
//                             return "Введите число";
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete, color: Colors.red),
//                       onPressed: () {
//                         setState(() {
//                           incomes.removeAt(index);
//                           updateChanges();
//                         });
//                       },
//                     ),
//                   ],
//                 );
//               }),
//             ),
//             TextButton.icon(
//               icon: Icon(Icons.add),
//               label: Text("Добавить доход"),
//               onPressed: () {
//                 setState(() {
//                   incomes.add(Income(type: incomeTypes.first, amount: 0));
//                   updateChanges();
//                 });
//               },
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text("Отмена"),
//                 ),
//                 ElevatedButton(
//                   onPressed: hasChanges
//                       ? () {
//                     Navigator.pop(context, CardData(name: nameController.text, incomes: incomes));
//                   }
//                       : null,
//                   child: Text("Сохранить изменения"),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class Income {
//   String type;
//   int amount;
//
//   Income({required this.type, required this.amount});
// }
//
// class CardData {
//   String name;
//   List<Income> incomes;
//
//   CardData({required this.name, required this.incomes});
// }
