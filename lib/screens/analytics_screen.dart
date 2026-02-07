import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';


import '../blocs/expense_list_cubit.dart';
import '../blocs/expense_list_state.dart';
import '../models/expense.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: BlocBuilder<ExpenseListCubit, ExpenseListState>(
        builder: (context, state) {
          if (state is! ExpenseListLoaded || state.expenses.isEmpty) {
            return const Center(child: Text('No Data'));
          }

          final data = _aggregate(state.expenses);

          return PieChart(
            PieChartData(
              sections: data.entries.map((entry) {
                return PieChartSectionData(
                  value: entry.value,
                  title: entry.key.name,
                  radius: 80,
                  showTitle: true
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  /// Aggregates total amount per category
  /// Interview Point: Data transformation logic
  Map<Category, double> _aggregate(List<Expense> expenses) {
    final map = <Category, double>{};

    for (final e in expenses) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }

    return map;
  }
}
