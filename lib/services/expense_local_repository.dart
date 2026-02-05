import 'package:flowtrack_app/services/expense_repository.dart';
import 'package:hive/hive.dart';

import '../models/expense.dart';

class ExpenseLocalRepository implements ExpenseRepository{
  final Box<Expense> _box = Hive.box<Expense>('expenses');


  @override
  Future<List<Expense>> getAllExpenses() async {
    /// values returns Iterable
    return _box.values.toList();
  }

  @override
  Future<void> addExpense(Expense expense) async {
    /// Using id as key for fast lookup
    await _box.put(expense.id, expense);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    await _box.put(expense.id, expense);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _box.delete(id);
  }
}