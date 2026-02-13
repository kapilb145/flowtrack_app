



import 'package:get_it/get_it.dart';

import '../services/expense_local_repository.dart';
import '../services/expense_repository.dart';

final sl = GetIt.instance;


void setupDI() {
  /// Register Repository
  sl.registerLazySingleton<ExpenseRepository>(
        () => ExpenseLocalRepository(),
  );
}