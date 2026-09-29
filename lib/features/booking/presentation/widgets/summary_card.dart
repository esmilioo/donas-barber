import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'glass_card.dart';
import '../../domain/entities/service.dart';
import '../../domain/entities/barber.dart';

class SummaryCard extends StatelessWidget {
  final Service service;
  final Barber barber;
  final String date;
  final String time;

  const SummaryCard({super.key, required this.service, required this.barber, required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          _SummaryRow(label: 'Servizio', value: service.name),
          const SizedBox(height: 10),
          _SummaryRow(label: 'Barbiere', value: barber.name),
          const SizedBox(height: 10),
          _SummaryRow(label: 'Data', value: '$date • $time'),
          const Divider(color: AppColors.border, height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Totale', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              Text('€${service.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.accent)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        const SizedBox(width: 16),
        Expanded(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary))),
      ],
    );
  }
}
