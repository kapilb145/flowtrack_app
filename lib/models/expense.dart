// Expense Model
// This represents one expense entry in the app

class Expense {
  // final → value cannot change once assigned
  final String id;

  final String title;
  final double amount;

  // DateTime object for when expense was added
  final DateTime date;

  // Constructor
  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });
}
