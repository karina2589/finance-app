// import 'package:flutter/material.dart';
// import 'package:flutter_frontend/models/CardData.dart';
// import 'package:flutter_frontend/models/EditableSalaryCard.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// // import '../dialogue/CardData.dart';
// import '../jsonModels/Incomes.dart';
// import '../jsonModels/Income.dart';
//
// class CardSwiper extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _CardSwipeState();
// }
//
// class _CardSwipeState extends State<CardSwiper> {
//
//   List<Income>? incomes = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _controller = PageController(viewportFraction: 0.5);
//     fetchIncomes();
//     //add logic of loading card name from db
//   }
//
//
//
//   Future<void> fetchIncomes() async {
//     List<Income>? data = await Incomes.fetchIncomes();
//     setState(() {
//       incomes = data;
//       isLoading = false;
//     });
//   }
//
//   void addIncome(Income newIncome) {
//     setState(() {
//       incomes?.add(newIncome);
//     });
//   }
//
//   //card index
//   int _curr = 0;
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
//   late PageController _controller;
//
//   Map<String, IconData> incomeIcons = {};
//   TextEditingController _cardNameController = TextEditingController();
//
//
//
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void onChanged(String newType){
//
//   }
//
//   void _showEditDialog(CardData card, int index) {
//     TextEditingController nameController = TextEditingController(text: card.cardName);
//
//     // Создаем контроллеры для каждого параметра
//     Map<String, TextEditingController> paramControllers = {
//       for (var entry in card.incomes.entries)
//         entry.key: TextEditingController(text: entry.value.toString())
//     };
//
//     showModalBottomSheet(
//       backgroundColor: Colors.white,
//       context: context,
//       isScrollControlled: true,  // Позволяет растягивать попап
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return Padding(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom, // Чтобы не перекрывалось клавиатурой
//                 left: 16,
//                 right: 16,
//                 top: 16,
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,  // Чтобы не занимал весь экран
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 25,),
//                   TextField(
//                     controller: nameController,
//                     style: GoogleFonts.inriaSans(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
//                     decoration: InputDecoration(labelText: "Card name"),
//                   ),
//                   SizedBox(height: 10),
//
//                   // Отображаем список параметров
//                   ...paramControllers.entries.map((entry) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 5),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                         ],
//
//
//                         // children: [
//                         //   Text(entry.key, style: GoogleFonts.inriaSans(fontSize: 17,color: Colors.black, fontWeight: FontWeight.w400),),
//                         //   SizedBox(
//                         //     width: 100,
//                         //     child: TextField(
//                         //       textAlign: TextAlign.center,
//                         //       textAlignVertical: TextAlignVertical.center,
//                         //       style: GoogleFonts.inriaSans(fontSize: 17,color: Colors.black),
//                         //       controller: entry.value,
//                         //       keyboardType: TextInputType.number,
//                         //       decoration: InputDecoration(
//                         //         // labelText: 'Your age',
//                         //         isDense: true,
//                         //         contentPadding: EdgeInsets.symmetric(vertical: 5),
//                         //         // Точная настройка отступов
//                         //         fillColor: Colors.grey.shade200,
//                         //         filled: true,
//                         //         enabledBorder: OutlineInputBorder(
//                         //           borderRadius: BorderRadius.circular(15),
//                         //           borderSide: BorderSide(color: Colors.grey.shade300),
//                         //         ),
//                         //         border: OutlineInputBorder(
//                         //           borderRadius: BorderRadius.circular(15),
//                         //           // borderSide: BorderSide(color: Colors.red),
//                         //         ),
//                         //       ),
//                         //     ),
//                         //   ),
//                         // ],
//                       ),
//                     );
//                   }).toList(),
//
//                   SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       TextButton(
//                         onPressed: () => Navigator.of(context).pop(),
//                         child: Text("Cancel"),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             cardsData[index] = CardData(
//                               cardName: nameController.text,
//                               incomes: {
//                                 for (var entry in paramControllers.entries)
//                                   entry.key: double.tryParse(entry.value.text) ?? 0.0
//                               },
//                             );
//                           });
//                           Navigator.of(context).pop();
//                         },
//                         child: Text("Save"),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 230,
//       child: PageView.builder(
//         controller: _controller,
//         itemCount: cardsData.length,
//         itemBuilder: (context, index) {
//           final card = cardsData[index];
//           return Padding(
//             padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
//             child: GestureDetector(
//                 onTap: () => _showEditDialog(card, index),
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
//                               Text(cardsData[index].cardName,
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
//                         Text("₸ 150 000",
//                             style: TextStyle(
//                                 fontSize: 25,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold)),
//                         // Text("Incomes",
//                         //     style: TextStyle(fontSize: 16, color: Colors.white70)),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children:
//                               cardsData[index].incomes.entries.map((entry) {
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
//                                       "${entry.value} ₸",
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
//   Widget _editableTextRow(String title, TextEditingController controller) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//       child: Row(
//         children: [
//           Text(title, style: GoogleFonts.inriaSans(fontSize: 16),),
//           TextField(
//             textAlign: TextAlign.center,
//             textAlignVertical: TextAlignVertical.center,
//             keyboardType: TextInputType.number,
//             controller: controller,
//             style: GoogleFonts.inriaSans(
//               fontSize: 16,
//               color: Colors.black,
//               fontWeight: FontWeight.w600,
//             ),
//             decoration: InputDecoration(
//               isDense: true,
//               contentPadding: EdgeInsets.symmetric(vertical: 5),
//               // Точная настройка отступов
//               fillColor: Colors.grey.shade200,
//               filled: true,
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(15),
//                 borderSide: BorderSide(color: Colors.grey.shade300),
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//             ),
//             // onChanged:,
//           ),
//         ],
//       ),
//     );
//   }
// }
