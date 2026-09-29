import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/barber.dart';

class BarberCard extends StatelessWidget {
  final Barber barber;
  final bool selected;
  final VoidCallback onTap;

  const BarberCard({super.key, required this.barber, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 108,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppColors.accent.withOpacity(0.12) : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.accent : AppColors.border, width: selected ? 1.5 : 1),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: selected ? AppColors.accent : AppColors.cardElevated,
                  child: Text(barber.initials, style: TextStyle(fontWeight: FontWeight.w900, color: selected ? Colors.black : AppColors.textPrimary)),
                ),
                if (barber.available)
                  Positioned(
                    right: 0, bottom: 0,
                    child: Container(width: 12, height: 12, decoration: BoxDecoration(color: AppColors.success, shape: BoxShape.circle, border: Border.all(color: AppColors.card, width: 2))),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(barber.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded, size: 14, color: AppColors.accent),
                const SizedBox(width: 2),
                Text(barber.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
