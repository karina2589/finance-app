import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/bloc/expense_transactions_bloc/expense_transactions_bloc.dart';
import 'package:flutter_frontend/bloc/income_transaction_bloc/income_transaction_bloc.dart';
import 'package:flutter_frontend/bloc/savings_transacrtions_bloc/savings_transactions_bloc.dart';
import 'package:flutter_frontend/models/AppTheme.dart';
import 'package:flutter_frontend/requests/Authentication/StreamAuth.dart';
import 'package:flutter_frontend/requests/Authentication/StreamAuthNotifier.dart';
import 'package:flutter_frontend/requests/Authentication/StreamAuthScope.dart';
import 'package:flutter_frontend/route/go_route.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/cards_bloc/cards_bloc.dart';
import 'bloc/expenses_bloc/expense_bloc.dart';
import 'bloc/income_bloc/income_bloc.dart';
import 'bloc/savings_bloc/savings_bloc.dart';

void main() async {
  // final prefs = await SharedPreferences.getInstance();
  // prefs.remove('auth_token');
  GoRouter router = AppGoRouter.router;
  StreamAuth streamAuth = StreamAuth();
  runApp(MultiBlocProvider(providers:  [
    BlocProvider<IncomeBloc>(create: (context) => IncomeBloc(), lazy: false,),
    BlocProvider<ExpenseBloc>(create: (context) => ExpenseBloc(), lazy: false,),
    BlocProvider<SavingBloc>(create: (context) => SavingBloc(), lazy: false,),
    BlocProvider<IncomeTransactionBloc>(create: (context) => IncomeTransactionBloc(BlocProvider.of<IncomeBloc>(context)), lazy: false,),
    BlocProvider<ExpenseTransactionBloc>(create: (context) => ExpenseTransactionBloc(BlocProvider.of<ExpenseBloc>(context)), lazy: false),
    BlocProvider<SavingTransactionBloc>(create: (context) => SavingTransactionBloc(BlocProvider.of<SavingBloc>(context)), lazy: false,),
    BlocProvider<CardBloc>(
      create: (context) => CardBloc(
        BlocProvider.of<IncomeTransactionBloc>(context),
        BlocProvider.of<ExpenseTransactionBloc>(context),
        BlocProvider.of<SavingTransactionBloc>(context),
      ), lazy: false,
    ),
  ], child: StreamAuthScope(
   child: MyApp(router: router,),)
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
