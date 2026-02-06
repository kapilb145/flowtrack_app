import 'package:flutter/material.dart';

/// Centralized color palette
/// Interview Point: Avoid hardcoding colors in UI.
class AppColors {
  AppColors._(); // prevent instantiation

  static const primary = Color(0xFF4F46E5); // Indigo
  static const accent = Color(0xFF14B8A6); // Teal

  static const background = Color(0xFFF5F7FA);
  static const card = Colors.white;

  static const success = Color(0xFF16A34A);
  static const danger = Color(0xFFDC2626);
  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);
}
