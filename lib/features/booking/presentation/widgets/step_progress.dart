import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class StepProgress extends StatelessWidget {
  final int currentStep;
  const StepProgress({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepDot(active: currentStep >= 1, label: '1'),
        _StepLine(active: currentStep >= 2),
        _StepDot(active: currentStep >= 2, label: '2'),
        _StepLine(active: currentStep >= 3),
        _StepDot(active: currentStep >= 3, label: '3'),
        _StepLine(active: currentStep >= 4),
        _StepDot(active: currentStep >= 4, label: '4'),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool active;
  final String label;
  const _StepDot({required this.active, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28, height: 28,
      decoration: BoxDecoration(
        color: active ? AppColors.accent : AppColors.card,
        shape: BoxShape.circle,
        border: Border.all(color: active ? AppColors.accent : AppColors.border),
      ),
      child: Center(child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: active ? Colors.black : AppColors.textSecondary))),
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool active;
  const _StepLine({required this.active});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(height: 2, margin: const EdgeInsets.symmetric(horizontal: 6), color: active ? AppColors.accent : AppColors.border),
    );
  }
}
