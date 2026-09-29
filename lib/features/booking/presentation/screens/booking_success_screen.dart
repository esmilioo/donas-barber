import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/booking.dart';

class BookingSuccessScreen extends StatelessWidget {
  final Booking booking;
  const BookingSuccessScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 96, height: 96,
                decoration: const BoxDecoration(
                  color: AppColors.accent, shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    size: 56, color: AppColors.onAccent),
              ),
              const SizedBox(height: 28),
              const Text('Prenotazione confermata!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary, letterSpacing: -0.5)),
              const SizedBox(height: 12),
              Text(
                'Ti aspettiamo ${booking.dateTime.day}/${booking.dateTime.month} alle ${booking.dateTime.hour.toString().padLeft(2, '0')}:${booking.dateTime.minute.toString().padLeft(2, '0')}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15,
                    color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _row('Servizio', booking.serviceName),
                    const SizedBox(height: 12),
                    _row('Barbiere', booking.barberName),
                    const Divider(color: AppColors.border, height: 26),
                    _row('Totale',
                        '€${booking.price.toStringAsFixed(2)}', bold: true),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.onAccent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                  ),
                  child: const Text('Torna alla home',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14,
              color: AppColors.textSecondary)),
          Expanded(
            child: Text(value, textAlign: TextAlign.right,
                style: TextStyle(fontSize: bold ? 18 : 14,
                    fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
                    color: bold ? AppColors.accent : AppColors.textPrimary)),
          ),
        ],
      );
}