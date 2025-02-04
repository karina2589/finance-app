import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/BudgetPlanner.dart';
import 'package:flutter_frontend/pages/FinancialReview.dart';
import 'package:flutter_frontend/pages/Profile.dart';
import 'package:flutter_frontend/pages/Savings.dart';

import '../models/AppTheme.dart';
import 'MainPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: CorePage(),
    );
  }
}

class CorePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CorePageState();
}

class _CorePageState extends State<CorePage>{
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MainPage(),
    Savings(),
    BudgetPlanner(),
    FinancialReview(),
    Profile()
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            _currentIndex == 0? "Welcome to FM" : _currentIndex == 1? 'Savings': _currentIndex == 2? "Let's plan your budget": _currentIndex==3?'Finance review':"My Profile",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          backgroundColor: AppTheme.mainBackColor,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.wallet,
              size: 35.0,
            ),
          ),
          actions: [
            Badge(
              label: Text("3"),
              child: IconButton(
                icon: const Icon(
                  Icons.message_outlined,
                  size: 30.0,
                ),
                tooltip: 'Show Snackbar',
                onPressed: () {},
              ),
            ),
          ]),
      body: _pages[_currentIndex], // Отображение текущей страницы
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        unselectedItemColor: AppTheme.primaryColor,
        selectedItemColor: AppTheme.iconsSecond,
        currentIndex: _currentIndex, // Выбранный пункт
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Обновление индекса
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Savings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Budget Planner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Finance review',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined), label: 'My profile')
        ],
      ),
    );

  }
}

