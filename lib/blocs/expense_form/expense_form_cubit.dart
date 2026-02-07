
import 'package:flow_track_app/blocs/expense_form/expense_form_state.dart';
import 'package:flow_track_app/blocs/expense_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/expense.dart';
import '../../services/expense_repository.dart';
import '../../utils/id_generator.dart';

class ExpenseFormCubit extends Cubit<ExpenseFormState>{
  final ExpenseRepository repository;

  ExpenseFormCubit(this.repository) : super(ExpenseFormInitial());

  Future<void> saveExpense({
    Expense? existingExpense,
    required String title,
    required double amount,
    required Category category,
    required DateTime date,
  }) async {
    try {
      emit(ExpenseFormSaving());

      /// Simple validation
      if (title.isEmpty || amount <= 0) {
        emit(const ExpenseFormError('Invalid input'));
        return;
      }

      final expense = existingExpense != null
          ? existingExpense.copyWith(
        title: title,
        amount: amount,
        category: category,
        date: date,
      )
          : Expense(
        id: IdGenerator.generate(),
        title: title,
        amount: amount,
        category: category,
        date: date,
      );

      if (existingExpense != null) {
        await repository.updateExpense(expense);
      } else {
        await repository.addExpense(expense);
      }

      emit(ExpenseFormSuccess());
    } catch (_) {
      emit(const ExpenseFormError('Failed to save expense'));
    }
  }







}




