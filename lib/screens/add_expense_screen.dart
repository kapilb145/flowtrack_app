import 'package:flow_track_app/services/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/expense_form/expense_form_cubit.dart';
import '../blocs/expense_form/expense_form_state.dart';
import '../di/service_locator.dart';
import '../models/expense.dart';
import '../services/expense_local_repository.dart';

class AddExpenseScreen extends StatelessWidget {
  final Expense? expense;

  const AddExpenseScreen({super.key,this.expense});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpenseFormCubit(sl<ExpenseRepository>()),
      child:  AddExpenseView(expense: expense,),
    );
  }
}

class AddExpenseView extends StatefulWidget {
  final Expense? expense;

  const AddExpenseView({super.key,this.expense});

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  Category _category = Category.food;
   DateTime _date = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final _titleFocus = FocusNode();
  final _amountFocus = FocusNode();




  @override
  void initState() {
    super.initState();

    final exp = widget.expense;

    if (exp != null) {
      _titleController.text = exp.title;
      _amountController.text = exp.amount.toString();
      _category = exp.category;
      _date = DateTime.now();
    }
  }

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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  focusNode: _titleFocus,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title required';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_amountFocus);
                  },
                ),
                TextFormField(
                  controller: _amountController,
                  focusNode: _amountFocus,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amount'),
    validator: (value) {
    final number = double.tryParse(value ?? '');
    if (number == null || number <= 0) {
    return 'Enter valid amount';
    }
    return null;
    },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
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
                    if (!_formKey.currentState!.validate()) return;

                    context.read<ExpenseFormCubit>().saveExpense(
                      existingExpense: widget.expense,
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
      ),
    );
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _amountFocus.dispose();
    super.dispose();
  }
}
