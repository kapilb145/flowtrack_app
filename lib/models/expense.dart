import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'expense.g.dart';

/// TypeId must be unique across app
@HiveType(typeId: 0)
enum Category {
  @HiveField(0)
  food,
  @HiveField(1)
  travel,
  @HiveField(2)
  shopping,
  @HiveField(3)
  bills,
  @HiveField(4)
  entertainment,
  @HiveField(5)
  other,
}

@HiveType(typeId: 1)
class Expense extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final Category category;

  @HiveField(4)
  final DateTime date;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  @override
  List<Object> get props => [id, title, amount, category, date];

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    Category? category,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }

  /// Convert Model → Map (Local DB use)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category.name, // Enum → String
      'date': date.toIso8601String(),
    };
  }

  /// Map → Model (Local DB read)
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      category: Category.values.firstWhere(
            (e) => e.name == map['category'],
      ),
      date: DateTime.parse(map['date']),
    );
  }

  /// Model → JSON (API send)
  Map<String, dynamic> toJson() => toMap();

  /// JSON → Model (API receive)
  factory Expense.fromJson(Map<String, dynamic> json) =>
      Expense.fromMap(json);
}




