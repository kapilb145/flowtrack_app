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






}