import 'package:equatable/equatable.dart';
import 'package:flow_track_app/models/expense.dart';

abstract class ExpenseListState extends Equatable{
  const ExpenseListState();

  List<Object?> get props => [];
}

class ExpenseListInitial extends ExpenseListState{}

class ExpenseListLoading extends ExpenseListState{}

class ExpenseListLoaded extends ExpenseListState{

  final List<Expense> expenses;

  const ExpenseListLoaded(this.expenses);

@override
  List<Object?> get props => [expenses];

}

class ExpenseListError extends ExpenseListState{
  final String message;

  const ExpenseListError(this.message);

  @override
  List<Object?> get props => [message];
}