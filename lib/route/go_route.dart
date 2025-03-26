import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/ActivityPage.dart';
import 'package:flutter_frontend/pages/BudgetPlanner.dart';
import 'package:flutter_frontend/pages/AnalyticsPage.dart';
import 'package:flutter_frontend/pages/MainPage.dart';
import 'package:flutter_frontend/pages/MainScaffoldPage.dart';
import 'package:flutter_frontend/pages/Profile.dart';
import 'package:flutter_frontend/pages/authPages/RegisterScreen.dart';
import 'package:flutter_frontend/pages/surveyPages/SurveyScreens.dart';
import 'package:flutter_frontend/requests/Authentication/StreamAuth.dart';
import 'package:flutter_frontend/requests/Authentication/StreamAuthNotifier.dart';
import 'package:flutter_frontend/requests/Authentication/StreamAuthScope.dart';
import 'package:flutter_frontend/route/router.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/authPages/LogInScreen.dart';
import '../pages/Savings.dart';

class AppGoRouter {
  static GoRouter get router => _goRouter;

  final StreamAuth auth = StreamAuth();

  //final StreamAuthNotifier authNotifier = StreamAuthNotifier();

  //pages that need own navigator key: Profile, MainPage, BudgetPlanner, Savings, FinancialReview

  // shell is for bottom navigation bar

  static final _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final _shellNavigatorMainPageKey =
      GlobalKey<NavigatorState>(debugLabel: 'mainPage');
  static final _shellNavigatorProfileKey =
      GlobalKey<NavigatorState>(debugLabel: 'profile');
  static final _shellNavigatorBudgetPlannerKey =
      GlobalKey<NavigatorState>(debugLabel: 'planner');
  static final _shellNavigatorAnalyticKey =
      GlobalKey<NavigatorState>(debugLabel: 'analytics');
  static final _shellNavigatorSavingsKey =
      GlobalKey<NavigatorState>(debugLabel: 'activity');

  static final GoRouter _goRouter = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppPath.mainPage,
      debugLogDiagnostics: true,
      redirect: (BuildContext context, GoRouterState state) async {
        final bool loggedIn = await StreamAuthScope.of(context).isSignedIn();
        final bool loggingIn = state.matchedLocation == AppPath.login;
        final bool registering = state.matchedLocation == AppPath.register;


        if (!loggedIn && !registering) {
          // Разрешаем доступ к /register
          return AppPath.login;
        }

        // if (loggedIn) {
        //   final prefs = await SharedPreferences.getInstance();
        //   final bool surveyCompleted = prefs.getBool('survey_completed') ?? false;
        //
        //   if (!surveyCompleted) {
        //     return AppPath.surveyPage; // Если опрос не пройден, отправляем на опрос
        //   }
        //
        //   return AppPath.mainPage; // Если все ок, отправляем на главную
        // }

        if (loggingIn && loggedIn) {
          return AppPath.mainPage;
        }
        final prefs = await SharedPreferences.getInstance();
        print('Token on SP: ${prefs.getString('auth_token')}');

        return null;
      },
      routes: [
        GoRoute(path: '/survey', builder: (context, state) => SurveyScreen()),
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => RegisterScreen(),
        ),
        StatefulShellRoute.indexedStack(
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state, navigationShell) {
              return MainScaffoldPage(
                navigationShell: navigationShell,
              );
            },
            branches: [
              StatefulShellBranch(
                  navigatorKey: _shellNavigatorMainPageKey,
                  routes: [
                    GoRoute(
                        path: AppPath.mainPage,
                        name: PathName.mainPage,
                        builder: (context, state) {
                          return MainPage();
                        })
                  ]),
              StatefulShellBranch(
                  navigatorKey: _shellNavigatorSavingsKey,
                  routes: [
                    GoRoute(
                        path: AppPath.activity,
                        name: PathName.activity,
                        builder: (context, state) {
                          return ActivityPage();
                        })
                  ]),
              StatefulShellBranch(
                  navigatorKey: _shellNavigatorBudgetPlannerKey,
                  routes: [
                    GoRoute(
                        path: AppPath.planner,
                        name: PathName.planner,
                        builder: (context, state) {
                          return BudgetPlanner();
                        })
                  ]),
              StatefulShellBranch(
                  navigatorKey: _shellNavigatorAnalyticKey,
                  routes: [
                    GoRoute(
                        path: AppPath.analytics,
                        name: PathName.analytics,
                        builder: (context, state) {
                          return AnalyticsPage();
                        })
                  ]),
              StatefulShellBranch(
                  navigatorKey: _shellNavigatorProfileKey,
                  routes: [
                    GoRoute(
                        path: AppPath.profile,
                        name: PathName.profile,
                        builder: (context, state) {
                          return Profile();
                        })
                  ]),
            ])
      ]);
}
