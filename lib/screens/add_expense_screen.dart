import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/expense_form/expense_form_cubit.dart';
import '../blocs/expense_form/expense_form_state.dart';
import '../models/expense.dart';
import '../services/expense_local_repository.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpenseFormCubit(ExpenseLocalRepository()),
      child: const AddExpenseView(),
    );
  }
}

class AddExpenseView extends StatefulWidget {
  const AddExpenseView({super.key});

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  Category _category = Category.food;
  final DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: BlocListener<ExpenseFormCubit, ExpenseFormState>(
        listener: (context, state) {
          if (state is ExpenseFormSuccess) {
            Navigator.pop(context, true);
          }

          if (state is ExpenseFormError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
              DropdownButton<Category>(
                value: _category,
                items: Category.values
                    .map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(c.name),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _category = value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<ExpenseFormCubit>().saveExpense(
                    title: _titleController.text,
                    amount: double.tryParse(_amountController.text) ?? 0,
                    category: _category,
                    date: _date,
                  );
                },
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
