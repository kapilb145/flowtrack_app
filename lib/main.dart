import 'package:flow_track_app/screens/expense_detail_screen.dart';
import 'package:flow_track_app/screens/expense_list_screen.dart';
import 'package:flow_track_app/services/expense_local_repository.dart';
import 'package:flow_track_app/services/expense_repository.dart';
import 'package:flow_track_app/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

import 'blocs/expense_list_cubit.dart';
import 'di/service_locator.dart';
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
  setupDI();

  /// Box = Local Table
  await Hive.openBox<Expense>('expenses');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ExpenseListCubit(sl<ExpenseRepository>())
            ..loadExpenses(),
        ),
      ],


      child: MaterialApp(
        title: 'FlowTrack',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        routes: {
          ExpenseDetailScreen.routeName: (_) =>
          const ExpenseDetailScreen(),
        },
        home: const ExpenseListScreen(),
      ),
    );
  }
}

