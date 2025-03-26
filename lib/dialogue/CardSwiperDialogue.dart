// import 'package:flutter/material.dart';
// import 'package:flutter_frontend/dialogue/CardData.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
//
// class CardSwiperDialogue extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _CardSwiperDialogueState();
// }
//
// class _CardSwiperDialogueState extends State<CardSwiperDialogue> {
//   late PageController _pageController;
//   final TextEditingController _cardNameController = TextEditingController();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _pageController = PageController(viewportFraction: 0.85);
//   }
//
//   final List<String> workTypes = [
//     'Salary',
//     'Allowance',
//     'Comission',
//     'Investment',
//     'Interest',
//     'Royalty',
//     'Freelance',
//     'Scholarship'
//         'Other'
//   ];
//
//   List<CardData> cardData = [
//     CardData(
//         cardName: 'Kaspi', cardIncomes: {'Salary': 1500000, 'Freelance': 14500}),
//     CardData(cardName: 'Halyk', cardIncomes: {'Scholarship': 47520}),
//     CardData(cardName: 'Freedom', cardIncomes: {'Scholarship': 51000}),
//     CardData(cardName: 'Otbasy', cardIncomes: {'Investment': 13000}),
//   ];
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _pageController.dispose();
//   }
//
//   String _calculateIncome(CardData card){
//     int sum = 0;
//     card.cardIncomes.entries.forEach((entry){
//       sum += entry.value;
//     });
//     return _formattedNumber(sum);
//
//   }
//
//   String _formattedNumber(int value){
//     final formatter = NumberFormat('#,##0', 'ru_RU'); // Используем русскую локаль
//     return formatter.format(value).replaceAll(',', ' ');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 230,
//       child: PageView.builder(
//         controller: _pageController,
//         itemCount: cardData.length,
//         itemBuilder: (context, index) {
//           final card = cardData[index];
//           return Padding(
//             padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
//             child: GestureDetector(
//                 onTap: () => _showDialog(card, index),
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16)),
//                   elevation: 4,
//                   color: Colors.blueAccent,
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       gradient: LinearGradient(
//                         colors: [Colors.blue.shade400, Colors.blue.shade700],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(cardData[index].cardName,
//                                   style: TextStyle(
//                                       fontSize: 20,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w400)),
//                               Icon(
//                                 Icons.wallet,
//                                 color: Colors.grey.shade200,
//                                 size: 30,
//                               )
//                             ]),
//
//                         Text("₸ ${_calculateIncome(card)}",
//                             style: TextStyle(
//                                 fontSize: 25,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold)),
//                         // Text("Incomes",
//                         //     style: TextStyle(fontSize: 16, color: Colors.white70)),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children:
//                               cardData[index].cardIncomes.entries.map((entry) {
//                             return Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 8.0),
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 3, horizontal: 10),
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Colors.blue.shade200,
//                                       Colors.blue.shade300,
//                                       Colors.blue.shade500
//                                     ],
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomRight,
//                                   ),
//                                   borderRadius: BorderRadius.circular(10),
//                                   // border: Border.all(
//                                   //     color: Colors.white70, width: 2)
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       textAlign: TextAlign.start,
//                                       "${entry.key}",
//                                       style: GoogleFonts.inriaSans(
//                                           fontSize: 15,
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                     Text(
//                                       textAlign: TextAlign.start,
//                                       "${_formattedNumber(entry.value)} ₸",
//                                       style: TextStyle(
//                                           fontSize: 15, color: Colors.white),
//                                     ),
//                                   ],
//                                 ));
//                           }).toList(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )),
//           );
//         },
//       ),
//     );
//   }
//
//   void _updateCardName(String name) {
//     setState(() {
//       _cardNameController.text = name;
//     });
//   }
//
//   void _showDialog(CardData card, int index) {
//     _cardNameController.text = card.cardName;
//     Map<String, TextEditingController> incomesControllers = {};
//     for (var entry in card.cardIncomes.entries) {
//       incomesControllers[entry.key] =
//           TextEditingController(text: entry.value.toString());
//     }
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(builder: (context, setStateDialog) {
//           return Dialog(
//             child: Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: _cardNameController,
//                     style: GoogleFonts.inriaSans(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black),
//                     decoration: InputDecoration(labelText: "Card name"),
//                     onChanged: (value) => _updateCardName(value),
//                   ),
//                   SizedBox(height: 10),
//                   Text("Incomes",
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.black)),
//                   SizedBox(height: 10),
//                   ...card.cardIncomes.entries.map((
//                     entry,
//                   ) {
//                     return Padding(
//                         padding: EdgeInsets.symmetric(vertical: 5),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: DropdownButtonFormField<String>(
//                                 style: GoogleFonts.inriaSans(
//                                     fontSize: 16, color: Colors.black),
//                                 dropdownColor: Colors.white70,
//                                 isExpanded: true,
//                                 value: entry.key.isNotEmpty
//                                     ? entry.key
//                                     : workTypes[0],
//                                 items: workTypes.map((String type) {
//                                   return DropdownMenuItem<String>(
//                                     value: type,
//                                     child: Text(
//                                       type,
//                                     ),
//                                   );
//                                 }).toList(),
//                                 onChanged: (value) {
//                                   if (value != null) {
//                                     setState(() {
//                                       int amount =
//                                           card.cardIncomes[entry.key] ?? 0;
//                                       card.cardIncomes.remove(entry.key);
//                                       card.cardIncomes[value] = amount;
//                                     });
//                                   }
//                                 },
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Expanded(
//                                 child: TextFormField(
//                               style: GoogleFonts.inriaSans(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black),
//                               controller: incomesControllers[entry.key],
//                               keyboardType: TextInputType.number,
//                               decoration: InputDecoration(
//                                   labelText: "amount",
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(
//                                       15,
//                                     ),
//                                   )),
//                               validator: (value) {
//                                 if (value == null || value.trim().isEmpty) {
//                                   return "Enter income amount";
//                                 }
//                                 if (int.tryParse(value) == null) {
//                                   return "Enter integer number";
//                                 }
//                                 return null;
//                               },
//                               onChanged: (value) {
//                                 if (value.isNotEmpty &&
//                                     int.tryParse(value) != null) {
//                                   setState(() {
//                                     card.cardIncomes[entry.key] =
//                                         int.parse(value);
//                                   });
//                                 }
//                               },
//                             )),
//                             IconButton(
//                                 onPressed: () {
//                                   setStateDialog(() {
//                                     card.cardIncomes.remove(entry.key);
//                                   });
//                                   setState(() {}); // Чтобы обновить основную карточку
//                                 },
//                                 icon: Icon(Icons.delete_outline))
//                           ],
//                         ));
//                   }),
//                   // Row(
//                   //   mainAxisAlignment: MainAxisAlignment.center,
//                   //   children: [
//                   //     TextButton(
//                   //       onPressed: () => ,
//                   //       child: Text("Add new income"),
//                   //     ),
//                   //   ],
//                   // )
//                 ],
//               ),
//             ),
//           );
//         });
//       },
//     );
//   }
// }
