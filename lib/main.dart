import 'package:flowtrack_app/screens/expense_list_screen.dart';
import 'package:flowtrack_app/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'models/expense.dart';

Future<void> main() async {
  /// Ensures Flutter bindings are initialized before async work
  /// Interview Point: Required when using async before runApp.
  WidgetsFlutterBinding.ensureInitialized();

  /// Initializes Hive local database
  await Hive.initFlutter();

  /// Register adapters before opening boxes
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(ExpenseAdapter());

  /// Box = Local Table
  await Hive.openBox<Expense>('expenses');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlowTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const ExpenseListScreen(),
    );
  }
}

