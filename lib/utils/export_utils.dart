import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/expense.dart';
import 'package:share_plus/share_plus.dart';
class ExportUtils {
  ExportUtils._();

  static Future<void> exportToCsv(List<Expense> expenses) async {
    /// Convert objects → rows
    final rows = [
      ['Title', 'Amount', 'Category', 'Date']
    ];

    for (final e in expenses) {
      rows.add([
        e.title,
        e.amount.toString(),
        e.category.name,
        e.date.toIso8601String(),
      ]);
    }

    /// Convert rows → CSV string
    final csvData = const ListToCsvConverter().convert(rows);

    /// Get device temp directory
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/expenses.csv');

    /// Write file
    await file.writeAsString(csvData);
    final params = ShareParams(
      text: 'Expenses',
      files: [XFile(file.path)],
    );
    /// Open share dialog
    await SharePlus.instance.share(params);
  }
}
