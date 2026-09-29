import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class DateCard extends StatelessWidget {
  final String day;
  final String date;
  final bool selected;
  final VoidCallback onTap;

  const DateCard({super.key, required this.day, required this.date, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.accent : AppColors.border),
        ),
        child: Column(
          children: [
            Text(day, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: selected ? Colors.black : AppColors.textSecondary)),
            const SizedBox(height: 6),
            Text(date, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: selected ? Colors.black : AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
