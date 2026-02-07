import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
