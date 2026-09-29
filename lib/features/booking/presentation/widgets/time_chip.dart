import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class TimeChip extends StatelessWidget {
  final String time;
  final bool selected;
  final VoidCallback onTap;

  const TimeChip({super.key, required this.time, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? AppColors.accent : AppColors.border),
        ),
        child: Text(time, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: selected ? Colors.black : AppColors.textPrimary)),
      ),
    );
  }
}
