import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final _uuid = const Uuid();

final formatter = DateFormat.yMd();

enum Category { food, travel, leisure, work, other }

Map<Category, IconData> categoryIcons = {
  Category.food: Icons.fastfood,
  Category.travel: Icons.flight,
  Category.work: Icons.work,
  Category.leisure: Icons.movie,
};

extension CategoryLabel on Category {
  String get label => name[0].toUpperCase() + name.substring(1);
}

class ExpenseModel {
  ExpenseModel({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
  }) : id = _uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}
