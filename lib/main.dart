import 'package:flutter/material.dart';
import 'package:flutter_frontend/models/AppTheme.dart';
import 'package:flutter_frontend/requests/Authentication/StreamAuth.dart';
import 'package:flutter_frontend/requests/Authentication/StreamAuthNotifier.dart';
import 'package:flutter_frontend/requests/Authentication/StreamAuthScope.dart';
import 'package:flutter_frontend/route/go_route.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // final prefs = await SharedPreferences.getInstance();
  // prefs.remove('auth_token');
  GoRouter router = AppGoRouter.router;
  StreamAuth streamAuth = StreamAuth();
  runApp(StreamAuthScope(
   child: MyApp(router: router,),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.router});
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Balance Box',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Определяет, куда направить пользователя
      routerConfig: router,
    );
  }
}
