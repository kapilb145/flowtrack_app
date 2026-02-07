

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/expense_list_cubit.dart';
import '../blocs/expense_list_state.dart';
import '../services/expense_local_repository.dart';
import 'add_expense_screen.dart';

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(

      /// Inject repository into cubit
      /// Interview Point: Dependency Injection
      create: (_) =>
      ExpenseListCubit(
        ExpenseLocalRepository(),
      )
        ..loadExpenses(), // load immediately
      child: const ExpenseListView(),
    );
  }


}


/// Separated View Widget
/// Interview Point: Separation improves testability.
class ExpenseListView extends StatefulWidget {
  const ExpenseListView({super.key});

  @override
  State<ExpenseListView> createState() => _ExpenseListViewState();
}

class _ExpenseListViewState extends State<ExpenseListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddExpenseScreen(),
            ),
          );

          if (!context.mounted) return;
          if (result == true) {
            context.read<ExpenseListCubit>().loadExpenses();
          }
        },
        child: const Icon(Icons.add),
      ),

      appBar: AppBar(
        title: const Text('FlowTrack'),
      ),
      body: BlocBuilder<ExpenseListCubit, ExpenseListState>(
        builder: (context, state) {
          /// Loading State
          if (state is ExpenseListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          /// Error State
          if (state is ExpenseListError) {
            return Center(child: Text(state.message));
          }

          /// Loaded State
          if (state is ExpenseListLoaded) {
            if (state.expenses.isEmpty) {
              return const Center(child: Text('No Expenses Yet'));
            }

            return ListView.builder(
              itemCount: state.expenses.length,
              itemBuilder: (context, index) {
                final expense = state.expenses[index];

                return ListTile(
                  title: Text(expense.title),
                  subtitle: Text(
                    '${expense.category.name} • ₹${expense.amount}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      IconButton(onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddExpenseScreen(expense: expense),
                          ),
                        );

                        if (!context.mounted) return;
                        if (result == true) {
                          context.read<ExpenseListCubit>().loadExpenses();
                        }

                      }, icon: Icon(Icons.edit)),

                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context
                              .read<ExpenseListCubit>()
                              .deleteExpense(expense.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }

          /// Initial fallback
          return const SizedBox();
        },
      ),
    );
  }
}