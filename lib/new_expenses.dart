// lib/new_expenses.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/model/expense.dart';

final _sheetFormatter = DateFormat.yMd();

class NewExpenses extends StatefulWidget {
  const NewExpenses({super.key, required this.onAddExpense});

  final void Function(ExpenseModel expense) onAddExpense;

  @override
  State<NewExpenses> createState() => _NewExpensesState();
}

class _NewExpensesState extends State<NewExpenses> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime? _selectedDate;
  Category? _selectedCategory;

  void _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (pickedDate == null) return;

    setState(() {
      _selectedDate = pickedDate;
    });

    // Revalidate date field after picking
    _formKey.currentState?.validate();
  }

  void _saveExpense() {
    final enteredTitle = _titleController.text.trim();
    final enteredAmount = double.tryParse(_amountController.text) ?? 0.0;

    if (enteredTitle.isEmpty ||
        enteredAmount <= 0 ||
        _selectedDate == null ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields.')),
      );
      return;
    }

    final newExpense = ExpenseModel(
      title: enteredTitle,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory!,
    );

    // If the parent expects a callback, call it (keeps compatibility)
    try {
      widget.onAddExpense(newExpense);
    } catch (_) {
      // ignore if parent doesn't want callback; we'll still try to pop with the value
    }

    if (!mounted) return;

    // Defer pop to avoid navigator locked/assertion issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).maybePop(newExpense);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final isLandscape = media.orientation == Orientation.landscape;
    final formattedDate = _selectedDate == null
        ? 'No Date Selected'
        : _sheetFormatter.format(_selectedDate!);

    // Reduce vertical padding in landscape so it fits better
    final topPadding = isLandscape ? 12.0 : 48.0;
    final spacingSmall = isLandscape ? 8.0 : 12.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SingleChildScrollView(
          // ensures sheet scrolls when keyboard open or in landscape
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: topPadding,
              bottom: media.viewInsets.bottom + 16,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                // limit max width for very wide screens (desktop/tablet)
                maxWidth: 800,
              ),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    TextFormField(
                      controller: _titleController,
                      maxLength: 50,
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a title.';
                        }
                        if (value.trim().length < 3) {
                          return 'Title must be at least 3 characters.';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: spacingSmall),

                    // Amount + Date: switch layout when in landscape or narrow width
                    if (!isLandscape)
                      // portrait: put amount and date on one row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _amountController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Amount',
                                prefixText: '₹ ',
                              ),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty)
                                  return 'Enter amount';
                                final parsed = double.tryParse(value.trim());
                                if (parsed == null)
                                  return 'Enter a valid number';
                                if (parsed <= 0) return 'Amount must be > 0';
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: spacingSmall),
                          SizedBox(
                            width: 160,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // date display
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        formattedDate,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // date error handled by FormField below (so not duplicated here)
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: _presentDatePicker,
                                  icon: const Icon(Icons.calendar_month),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    else
                      // landscape: stack amount and date vertically to avoid overflow
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Amount',
                              prefixText: '₹ ',
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty)
                                return 'Enter amount';
                              final parsed = double.tryParse(value.trim());
                              if (parsed == null) return 'Enter a valid number';
                              if (parsed <= 0) return 'Amount must be > 0';
                              return null;
                            },
                          ),
                          SizedBox(height: spacingSmall),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  formattedDate,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        ],
                      ),

                    SizedBox(height: spacingSmall),

                    // Date FormField for validation
                    FormField<DateTime>(
                      initialValue: _selectedDate,
                      validator: (_) {
                        if (_selectedDate == null) return 'Pick a date';
                        return null;
                      },
                      builder: (fieldState) {
                        return fieldState.hasError
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 4.0,
                                  left: 2.0,
                                ),
                                child: Text(
                                  fieldState.errorText!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),

                    SizedBox(height: spacingSmall),

                    // Category dropdown
                    DropdownButtonFormField<Category>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: Category.values
                          .map(
                            (cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat.label),
                            ),
                          )
                          .toList(),
                      onChanged: (cat) {
                        setState(() => _selectedCategory = cat);
                        _formKey.currentState?.validate();
                      },
                      validator: (value) {
                        if (value == null) return 'Select a category';
                        return null;
                      },
                    ),

                    SizedBox(height: 16),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _saveExpense,
                          child: const Text('Save Expense'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
