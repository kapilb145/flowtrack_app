import '../models/expense.dart';

/// Abstract class = Contract / Blueprint
/// Interview Point: Helps switch Local DB → API later.
abstract class ExpenseRepository {
  Future<List<Expense>> getAllExpenses();

  Future<void> addExpense(Expense expense);

  Future<void> updateExpense(Expense expense);

  Future<void> deleteExpense(String id);
}
