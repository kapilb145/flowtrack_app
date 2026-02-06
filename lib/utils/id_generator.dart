// Simple ID generator
// Later we may replace with UUID package



import 'package:uuid/uuid.dart';

class IdGenerator {
  /// Private constructor prevents instantiation
  /// Interview Point: Utility class pattern
  IdGenerator._();

  static const _uuid = Uuid();

  /// Generates globally unique ID
  static String generate() {
    return _uuid.v4();
  }
}
