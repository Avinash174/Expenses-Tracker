import 'package:expense_tracker/widget/expenses_list/expenses_list.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<ExpenseModel> registeredExpenses = [
    ExpenseModel(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work, // ✅ pass enum, not .name
    ),
    ExpenseModel(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure, // ✅ pass enum, not .name
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('The Chart'),
          ),
          Expanded(child: ExpensesList(expenses: registeredExpenses)),
        ],
      ),
    );
  }
}
