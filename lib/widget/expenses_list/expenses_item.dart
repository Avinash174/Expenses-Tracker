import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';

class ExpensesItems extends StatelessWidget {
  const ExpensesItems({super.key, required this.expenses});

  final ExpenseModel expenses;

  @override
  Widget build(BuildContext context) {
    return Card(child: Text(expenses.title));
  }
}
