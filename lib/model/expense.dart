import 'package:uuid/uuid.dart';

final _uuid = const Uuid();

enum Category { food, travel, leisure, work, other }

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
}
