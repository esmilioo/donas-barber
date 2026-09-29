import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/providers/local_storage.dart';
import '../../../booking/domain/entities/booking.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _storage = LocalStorage();
  List<Booking> _bookings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final b = await _storage.getBookings();
    b.sort((a, c) => a.dateTime.compareTo(c.dateTime));
    if (!mounted) return;
    setState(() { _bookings = b; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: const Text('Dashboard Barbiere',
              style: TextStyle(fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary)),
          bottom: const TabBar(
            indicatorColor: AppColors.accent,
            labelColor: AppColors.accent,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: 'Agenda'),
              Tab(text: 'Statistiche'),
              Tab(text: 'Servizi'),
            ],
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
            : TabBarView(
                children: [
                  _AgendaTab(bookings: _bookings, onRefresh: _load),
                  _StatsTab(bookings: _bookings),
                  const _ServicesTab(),
                ],
              ),
      ),
    );
  }
}

class _AgendaTab extends StatelessWidget {
  final List<Booking> bookings;
  final Future<void> Function() onRefresh;
  const _AgendaTab({required this.bookings, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return const Center(child: Text('Nessuna prenotazione',
          style: TextStyle(color: AppColors.textSecondary)));
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.accent,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: bookings.length,
        itemBuilder: (_, i) {
          final b = bookings[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(b.serviceName,
                    style: const TextStyle(fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text('${b.dateTime.day}/${b.dateTime.month} '
                    '${b.dateTime.hour.toString().padLeft(2, '0')}:'
                    '${b.dateTime.minute.toString().padLeft(2, '0')} • ${b.barberName}',
                    style: const TextStyle(fontSize: 13,
                        color: AppColors.textSecondary)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _chip('Conferma', AppColors.success, () {}),
                    const SizedBox(width: 8),
                    _chip('Annulla', AppColors.danger, () {}),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _chip(String label, Color color, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Text(label,
              style: TextStyle(color: color, fontWeight: FontWeight.w800,
                  fontSize: 13)),
        ),
      );
}

class _StatsTab extends StatelessWidget {
  final List<Booking> bookings;
  const _StatsTab({required this.bookings});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayBookings = bookings.where((b) =>
        b.dateTime.year == today.year &&
        b.dateTime.month == today.month &&
        b.dateTime.day == today.day).toList();
    final revenue = bookings
        .where((b) => b.status == 'confirmed')
        .fold<double>(0, (s, b) => s + b.price);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _statCard('Appuntamenti oggi', '${todayBookings.length}'),
          const SizedBox(height: 12),
          _statCard('Totale prenotazioni', '${bookings.length}'),
          const SizedBox(height: 12),
          _statCard('Fatturato', '€${revenue.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 13,
                    color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(fontSize: 28,
                    fontWeight: FontWeight.w900, color: AppColors.accent)),
          ],
        ),
      );
}

class _ServicesTab extends StatelessWidget {
  const _ServicesTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Gestione servizi — in arrivo',
          style: TextStyle(color: AppColors.textSecondary)),
    );
  }
}