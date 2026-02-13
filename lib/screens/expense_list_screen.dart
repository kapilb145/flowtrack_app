

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/expense_list_cubit.dart';
import '../blocs/expense_list_state.dart';
import '../models/expense.dart';
import '../utils/export_utils.dart';
import '../widgets/summary_card.dart';
import 'add_expense_screen.dart';
import 'analytics_screen.dart';
import 'expense_detail_screen.dart';

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

          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              final state = context.read<ExpenseListCubit>().state;

              if (state is ExpenseListLoaded) {
                ExportUtils.exportToCsv(state.expenses);
              }
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

            final width = MediaQuery.of(context).size.width;
            final isTablet = width > 600;
            final isDesktop = width > 1000;


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


          (!isTablet
          // ---------- MOBILE ----------
          ?   ListView.builder(
                    itemCount: state.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = state.expenses[index];

                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ExpenseDetailScreen.routeName,
                            arguments: expense,
                          );
                        },
                        title: Hero(
                            tag: expense.id,
                        child: Material(
                              color: Colors.transparent,
                              child: Text(expense.title),
                            ),
                        ),
                        subtitle: Text(
                          '${expense.category.name} • ₹${expense.amount}',
                        ),
                        trailing: _actionButtons(context, expense
                        ),
                      );
                    },
                  )

              : GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 4 : 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: state.expenses.length,
            itemBuilder: (context, index) {
              final expense = state.expenses[index];

              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ExpenseDetailScreen.routeName,
                      arguments: expense,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: expense.id,
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              expense.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('₹${expense.amount}'),
                        Text(expense.category.name),
                        const SizedBox(height: 8),
                        _actionButtons(context, expense),
                      ],
                    ),
                  ),
                ),
              );
            },
          ))
              : const Center(child: Text('No Expenses Yet')),
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

  Widget _actionButtons(BuildContext context, Expense expense) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () async {
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
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            context.read<ExpenseListCubit>().deleteExpense(expense.id);
          },
        ),
      ],
    );
  }

}