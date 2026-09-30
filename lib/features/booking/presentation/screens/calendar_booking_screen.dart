import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/barbers_data.dart';
import '../../domain/entities/barber.dart';

class CalendarBookingScreen extends StatefulWidget {
  const CalendarBookingScreen({super.key, required this.barberId});
  final String barberId;

  @override
  State<CalendarBookingScreen> createState() => _CalendarBookingScreenState();
}

class _CalendarBookingScreenState extends State<CalendarBookingScreen> {
  late DateTime _visibleMonth;
  late DateTime _selectedDate;
  String _selectedTime = '';
  String _period = 'Pomeriggio';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
    _selectedDate = now;
  }

  Barber get _barber =>
      demoBarbers.firstWhere((b) => b.id == widget.barberId, orElse: () => demoBarbers.first);

  List<String> get _morningSlots =>
      _barber.slotsFor(_selectedDate).where((t) {
        final h = int.parse(t.split(':')[0]);
        return h < 13;
      }).toList();

  List<String> get _afternoonSlots =>
      _barber.slotsFor(_selectedDate).where((t) {
        final h = int.parse(t.split(':')[0]);
        return h >= 13;
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Scegli il giorno',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCalendarCard(),
                    const SizedBox(height: 24),
                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            const Text(
                              'Vedi tutti gli orari',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Icon(Icons.keyboard_arrow_down,
                                  color: AppColors.textPrimary, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Scegli orario',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPeriodTabs(),
                    const SizedBox(height: 16),
                    _buildTimeGrid(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          _circleIcon(Icons.arrow_back_ios_new_rounded, () => context.pop()),
          const Spacer(),
          _circleIcon(Icons.close_rounded, () => context.pop()),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.card,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  _visibleMonth =
                      DateTime(_visibleMonth.year, _visibleMonth.month - 1);
                }),
                child: const Icon(Icons.chevron_left,
                    color: AppColors.textPrimary, size: 28),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      _monthName(_visibleMonth.month),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${_visibleMonth.year}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  _visibleMonth =
                      DateTime(_visibleMonth.year, _visibleMonth.month + 1);
                }),
                child: const Icon(Icons.chevron_right,
                    color: AppColors.textPrimary, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom']
                .map((d) => SizedBox(
                      width: 36,
                      child: Text(
                        d,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          _buildDayGrid(),
        ],
      ),
    );
  }

  Widget _buildDayGrid() {
    final firstDay = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final daysInMonth =
        DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
    final leadingEmpty = (firstDay.weekday - 1) % 7;
    final today = DateTime.now();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: leadingEmpty + daysInMonth,
      itemBuilder: (context, index) {
        if (index < leadingEmpty) return const SizedBox.shrink();
        final day = index - leadingEmpty + 1;
        final date = DateTime(_visibleMonth.year, _visibleMonth.month, day);
        final isPast = date.isBefore(DateTime(today.year, today.month, today.day));
        final isSelected = date.year == _selectedDate.year &&
            date.month == _selectedDate.month &&
            date.day == _selectedDate.day;
        final hasSlots = _barber.worksOn(date);

        return GestureDetector(
          onTap: isPast || !hasSlots
              ? null
              : () {
                  setState(() {
                    _selectedDate = date;
                    _selectedTime = '';
                  });
                },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.textPrimary
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: hasSlots && !isPast && !isSelected
                  ? Border.all(color: AppColors.border, width: 1)
                  : null,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isPast
                      ? AppColors.textMuted
                      : isSelected
                          ? AppColors.onAccent
                          : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPeriodTabs() {
    return Row(
      children: [
        Expanded(
          child: _periodTab('Mattina', _morningSlots.length),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _periodTab('Pomeriggio', _afternoonSlots.length),
        ),
      ],
    );
  }

  Widget _periodTab(String label, int count) {
    final active = _period == label;
    return GestureDetector(
      onTap: () => setState(() => _period = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: active ? AppColors.cardElevated : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active ? AppColors.border : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: active ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeGrid() {
    final slots = _period == 'Mattina' ? _morningSlots : _afternoonSlots;
    if (slots.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: const Text(
          'Nessun orario disponibile',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.1,
      ),
      itemCount: slots.length,
      itemBuilder: (context, i) {
        final time = slots[i];
        final selected = _selectedTime == time;
        return GestureDetector(
          onTap: () => setState(() => _selectedTime = time),
          child: Container(
            decoration: BoxDecoration(
              color: selected ? AppColors.textPrimary : AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? AppColors.textPrimary : AppColors.border,
              ),
            ),
            child: Center(
              child: Text(
                time,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: selected ? AppColors.onAccent : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _monthName(int month) {
    const months = [
      'Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno',
      'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'
    ];
    return months[month - 1];
  }
}