

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/expense_list_cubit.dart';
import '../blocs/expense_list_state.dart';
import '../models/expense.dart';
import '../services/expense_local_repository.dart';
import '../widgets/summary_card.dart';
import 'add_expense_screen.dart';
import 'analytics_screen.dart';

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return const ExpenseListView();
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
        actions: [
          IconButton(
            icon: const Icon(Icons.pie_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AnalyticsScreen(),
                ),
              );
            },
          ),
        ],

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
            final cubit = context.read<ExpenseListCubit>();

            // if (state.expenses.isEmpty) {
            //   return const Center(child: Text('No Expenses Yet'));
            // }

            return Column(
              children: [

                DropdownButton<Category?>(
                  hint: const Text('Filter Category'),
                  value: state.selectedCategory,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All')),
                    ...Category.values.map((c) =>
                        DropdownMenuItem(value: c, child: Text(c.name))),
                  ],
                  onChanged: (value) {
                    context.read<ExpenseListCubit>().filterByCategory(value);
                  },
                ),

                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search expenses...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    context.read<ExpenseListCubit>().search(value);
                  },
                ),


                Row(
                  children: [
                    Expanded(
                      child: SummaryCard(
                        title: 'Total',
                        value: '₹${cubit.getTotal(state.expenses)}',
                      ),
                    ),
                    Expanded(
                      child: SummaryCard(
                        title: 'This Month',
                        value: '₹${cubit.getThisMonth(state.expenses)}',
                      ),
                    ),
                  ],
                ),
                SummaryCard(
                  title: 'Top Category',
                  value: cubit.getTopCategory(state.expenses)?.name ?? 'None',
                ),


                Expanded(
                  child: state.expenses.isNotEmpty ?
                  ListView.builder(
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
                  ) : const Center(child: Text('No Expenses Yet')),
                ),
              ],
            );
          }

          /// Initial fallback
          return const SizedBox();
        },
      ),
    );
  }
}