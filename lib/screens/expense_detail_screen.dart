
import 'package:flutter/material.dart';

import '../models/expense.dart';

class ExpenseDetailScreen extends StatelessWidget{

  static const routeName = '/expenseDetail';

  const ExpenseDetailScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final expense =
    ModalRoute.of(context)!.settings.arguments as Expense;
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: expense.id,
              child: Material(
                color: Colors.transparent,
                child: Text(
                  expense.title,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('Amount: ₹${expense.amount}'),
            Text('Category: ${expense.category.name}'),
            Text('Date: ${expense.date}'),
          ],
        ),
      ),
    );
  }


}