import 'package:equatable/equatable.dart';
import 'package:flow_track_app/models/expense.dart';

abstract class ExpenseListState extends Equatable{
  const ExpenseListState();

  List<Object?> get props => [];
}

class ExpenseListInitial extends ExpenseListState{}

class ExpenseListLoading extends ExpenseListState{}

class ExpenseListLoaded extends ExpenseListState {
  final List<Expense> expenses;
  final String searchQuery;
  final Category? selectedCategory;

  const ExpenseListLoaded({
    required this.expenses,
    this.searchQuery = '',
    this.selectedCategory,
  });

  @override
  List<Object?> get props => [expenses, searchQuery, selectedCategory];

  ExpenseListLoaded copyWith({
    List<Expense>? expenses,
    String? searchQuery,
    Category? selectedCategory,
  }) {
    return ExpenseListLoaded(
      expenses: expenses ?? this.expenses,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class ExpenseListError extends ExpenseListState{
  final String message;

  const ExpenseListError(this.message);

  @override
  List<Object?> get props => [message];
}