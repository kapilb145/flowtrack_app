

import 'package:equatable/equatable.dart';

abstract class ExpenseFormState extends Equatable{

  const ExpenseFormState();
  @override
  List<Object?> get props => [];
}


/// Initial idle state
class ExpenseFormInitial extends ExpenseFormState {}

/// While saving
class ExpenseFormSaving extends ExpenseFormState {}

/// Success state
class ExpenseFormSuccess extends ExpenseFormState {}

/// Error state
class ExpenseFormError extends ExpenseFormState {
  final String message;

  const ExpenseFormError(this.message);

  @override
  List<Object?> get props => [message];
}