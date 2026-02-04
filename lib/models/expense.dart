// Expense Model
// Represents one expense entry in the app

// Enum → fixed set of categories
enum Category {
  food,
  travel,
  shopping,
  bills,
  entertainment,
  other,
}

class Expense {
  // final → cannot change after assignment
  final String id;

  final String title;
  final double amount;
  final DateTime date;

  // Enum category
  final Category category;

  // Constructor
  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  // Convert object → Map (used for database or API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category.name, // enum → string
    };
  }

  // Factory constructor → Map → Object
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: Category.values.firstWhere(
            (e) => e.name == map['category'],
      ),
    );
  }
}
