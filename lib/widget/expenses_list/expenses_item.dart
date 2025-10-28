import 'dart:math';

import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';

class ExpensesItems extends StatelessWidget {
  const ExpensesItems({super.key, required this.expenses});

  final ExpenseModel expenses;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Text(expenses.title),
            SizedBox(height: 4),
            Row(
              children: [
                Text('\$${expenses.amount.toStringAsFixed(2)}'),
                Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expenses.category]),
                    SizedBox(width: 8),
                    Text(
                      '${expenses.date.day.toString().padLeft(2, '0')}/${expenses.date.month.toString().padLeft(2, '0')}/${expenses.date.year}',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
