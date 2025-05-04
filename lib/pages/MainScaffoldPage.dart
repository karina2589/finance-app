import 'package:flutter/material.dart';
import 'package:flutter_frontend/route/router.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/AppTheme.dart';

class MainScaffoldPage extends StatefulWidget {
  const MainScaffoldPage({super.key,  this.navigationShell});
  final StatefulNavigationShell? navigationShell;
  @override
  State<MainScaffoldPage> createState() => _MainScaffoldPageState();
}

class _MainScaffoldPageState extends State<MainScaffoldPage> {
  void _goBranch(int index) {
    widget.navigationShell!.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == widget.navigationShell!.currentIndex,
    );
  }

  String _getAppBarTitle(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/mainPage')) return "Welcome to FM";
    if (location.startsWith('/activity')) return "My Spendings";
    if (location.startsWith('/planner')) return "Let's plan your budget";
    if (location.startsWith('/analytics')) return "Finance review";
    if (location.startsWith('/profile')) return "My Profile";

    return "Finance App"; // Заголовок по умолчанию
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(
            style: Theme.of(context).textTheme.headlineLarge,
            //_getAppBarTitle(context)
            "BalanceBox"
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
              // label: Text("3"),
              child: IconButton(
                icon: const Icon(
                  Icons.chat_bubble_rounded,
                  size: 30.0,
                ),
                tooltip: 'Show Snackbar',
                onPressed: () {
                  context.push(AppPath.chatPage);
                },
              ),
            ),
          ]),
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Budgeting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'My profile')
        ],
        currentIndex: widget.navigationShell!.currentIndex,
        backgroundColor: Colors.white,
        selectedLabelStyle:  GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w500),
        unselectedLabelStyle:  GoogleFonts.poppins(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: AppTheme.primaryColor,
        selectedItemColor: AppTheme.iconsSecond,
        onTap: (index) {
          _goBranch(index);
        },
      ),
    );
  }
}