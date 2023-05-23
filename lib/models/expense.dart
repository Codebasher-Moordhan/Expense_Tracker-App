import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();
final formatter = DateFormat(' d/M/y');

enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: Icon(Icons.fastfood),
  Category.travel: Icon(Icons.flight_takeoff),
  Category.leisure: Icon(Icons.movie),
  Category.work: Icon(Icons.work),
};

class Expense {
  Expense({
    required this.title,
    required this.date,
    required this.amount,
    required this.category,
  }) : id = uuid.v4();
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}
