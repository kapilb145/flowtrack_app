import 'package:flowtrack_app/services/expense_repository.dart';
import 'expense_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseListCubit extends Cubit<ExpenseListState>{

  final ExpenseRepository expenseRepository;

  ExpenseListCubit(this.expenseRepository) : super(ExpenseListInitial());


  /// Load all expenses
  Future<void> loadExpenses() async {
    try {
      emit(ExpenseListLoading());

      final expenses = await expenseRepository.getAllExpenses();

      emit(ExpenseListLoaded(expenses));
    } catch (e) {
      /// Never expose raw exception to UI
      emit(ExpenseListError('Failed to load expenses'));
    }
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