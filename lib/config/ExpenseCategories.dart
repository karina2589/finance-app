import 'package:flutter/material.dart';

class ExpenseCategories {
  /*HOUSING
  TRANSPORT
  HEALTH
  GROCERIES
  FOOD
  SHOPPING
  INSURANCE
  ENTERTAINMENT
  SUBSCRIPTION
  OTHER

enum Frequency {
  DAILY
  WEEKLY
  MONTHLY
  YEARLY
  OTHER
}
   */

  static const IconData housing = Icons.house_outlined;
  static const IconData transport = Icons.directions_bus;
  static const IconData health = Icons.medical_information_outlined;
  static const IconData groceries = Icons.local_grocery_store_outlined;
  static const IconData food = Icons.fastfood;
  static const IconData shopping = Icons.shopping_cart_outlined;
  static const IconData insurance = Icons.medication_rounded;
  static const IconData entertainment = Icons.moped_outlined;
  static const IconData subscription = Icons.subscriptions_outlined;
  static const IconData other = Icons.question_mark_outlined;

  static const List<String> expenseCategories = ['HOUSING', 'TRANSPORT', 'HEALTH', 'GROCERIES', 'FOOD', 'SHOPPING',
  'INSURANCE', 'ENTERTAINMENT', 'SUBSCRIPTION', 'OTHER' ];

  static const List<String> frequency = ['DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY', 'OTHER'];

  static const Map<String, IconData> expenseIcons = {
    'housing': Icons.house_outlined,
    'transport': Icons.directions_bus,
    'health': Icons.medical_information_outlined,
    'groceries': Icons.local_grocery_store_outlined,
    'food': Icons.fastfood,
    'shopping': Icons.shopping_cart_outlined,
    'insurance': Icons.medication_rounded,
    'entertainment': Icons.moped_outlined,
    'subscription': Icons.subscriptions_outlined,
    'other': Icons.question_mark_outlined,
  };
}
