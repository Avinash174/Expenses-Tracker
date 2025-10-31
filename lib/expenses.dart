// lib/expenses.dart
import 'package:expense_tracker/widget/chart/chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/new_expenses.dart';
import 'package:expense_tracker/widget/expenses_list/expenses_list.dart';
import 'package:expense_tracker/model/expense.dart';

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
      category: Category.work,
    ),
    ExpenseModel(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  Future<void> _openAddExpensesOverlay() async {
    // Open sheet and await returned ExpenseModel (or null if cancelled)
    final newExpense = await showModalBottomSheet<ExpenseModel>(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpenses(
        onAddExpense: (expense) {
          Navigator.of(ctx).pop(expense);
        },
      ), // NewExpenses should return value via Navigator.pop(ctx, newExpense)
    );

    if (newExpense == null) return;

    setState(() {
      registeredExpenses.add(newExpense);
    });
  }

  // Remove by id for safety, and support undo
  void _removeExpense(ExpenseModel expense) {
    final removedIndex = registeredExpenses.indexWhere(
      (e) => e.id == expense.id,
    );
    if (removedIndex < 0) return;

    final removedExpense = registeredExpenses[removedIndex];

    setState(() {
      registeredExpenses.removeAt(
        removedIndex,
      ); // immediate removal required by Dismissible
    });

    // show undo snackbar
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              registeredExpenses.insert(removedIndex, removedExpense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpensesOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: registeredExpenses),
                Expanded(
                  child: ExpensesList(
                    expenses: registeredExpenses,
                    onRemove:
                        _removeExpense, // ExpensesList will call this when item dismissed
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: registeredExpenses)),
                Expanded(
                  child: ExpensesList(
                    expenses: registeredExpenses,
                    onRemove:
                        _removeExpense, // ExpensesList will call this when item dismissed
                  ),
                ),
              ],
            ),
    );
  }
}
