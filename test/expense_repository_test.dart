import 'package:flow_track_app/models/expense.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Expense copyWith updates title', () {
    final expense = Expense(
      id: '1',
      title: 'Food',
      amount: 100,
      category: Category.food,
      date: DateTime.now(),
    );

    final updated = expense.copyWith(title: 'Dinner');

    expect(updated.title, 'Dinner');
    expect(updated.amount, 100); // unchanged
  });
}
