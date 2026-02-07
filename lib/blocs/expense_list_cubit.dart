import 'package:flow_track_app/services/expense_repository.dart';
import '../models/expense.dart';
import 'expense_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseListCubit extends Cubit<ExpenseListState>{

  final ExpenseRepository expenseRepository;

  ExpenseListCubit(this.expenseRepository) : super(ExpenseListInitial());

  List<Expense> _allExpenses = [];

  /// Load all expenses
  Future<void> loadExpenses() async {
    try {
      emit(ExpenseListLoading());

      final expenses = await expenseRepository.getAllExpenses();
      _allExpenses = expenses;
      emit(ExpenseListLoaded(expenses: expenses));
    } catch (e) {
      /// Never expose raw exception to UI
      emit(ExpenseListError('Failed to load expenses'));
    }
  }

  void search(String query) {
    if (state is! ExpenseListLoaded) return;

    final current = state as ExpenseListLoaded;

    final filtered = _allExpenses.where((e) {
      return e.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(current.copyWith(
      expenses: filtered,
      searchQuery: query,
    ));
  }


  void filterByCategory(Category? category) {
    if (state is! ExpenseListLoaded) return;

    final current = state as ExpenseListLoaded;

    final filtered = _allExpenses.where((e) {
      if (category == null) return true;
      return e.category == category;
    }).toList();

    emit(current.copyWith(
      expenses: filtered,
      selectedCategory: category,
    ));
  }





  /// Delete expense and refresh list
  Future<void> deleteExpense(String id) async {
    try {
      await expenseRepository.deleteExpense(id);
      await loadExpenses();
    } catch (_) {
      emit(ExpenseListError('Delete failed'));
    }
  }




  double getTotal(List<Expense> list) {
    return list.fold(0, (sum, e) => sum + e.amount);
  }

  double getThisMonth(List<Expense> list) {
    final now = DateTime.now();

    return list
        .where((e) =>
    e.date.month == now.month && e.date.year == now.year)
        .fold(0, (sum, e) => sum + e.amount);
  }

  Category? getTopCategory(List<Expense> list) {
    if (list.isEmpty) return null;

    final map = <Category, double>{};

    for (final e in list) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }

    map.removeWhere((k, v) => v == 0);

    return map.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }



}