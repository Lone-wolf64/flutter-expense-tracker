// data/models/expense_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  ExpenseModel({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'amount': amount,
    'category': category,
    'date': Timestamp.fromDate(date),
  };

  factory ExpenseModel.fromMap(Map<String, dynamic> map) => ExpenseModel(
    title: map['title'],
    amount: map['amount'],
    category: map['category'],
    date: (map['date'] as Timestamp).toDate(),
  );
}
