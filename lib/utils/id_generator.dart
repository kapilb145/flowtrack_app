// Simple ID generator
// Later we may replace with UUID package

String generateId() {
  return DateTime.now().millisecondsSinceEpoch.toString();
}
