import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/service_card.dart';
import '../widgets/barber_card.dart';
import '../widgets/date_card.dart';
import '../widgets/time_chip.dart';
import '../widgets/step_progress.dart';
import '../widgets/summary_card.dart';
import '../../domain/entities/service.dart';
import '../../domain/entities/barber.dart';
import '../../domain/entities/booking.dart';
import '../../data/barbers_data.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../data/providers/local_storage.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _storage = LocalStorage();

  int _selectedService = 0;
  int _selectedBarber = 0;
  int _selectedDate = 0;
  String? _selectedTime;
  bool _loadingSlots = true;
  Set<String> _bookedSlots = {};

  final List<Service> services = const [
    Service(name: 'Taglio Classico', description: 'Capelli + styling',
        duration: 30, price: 22.0, icon: Icons.content_cut_rounded),
    Service(name: 'Barba Premium', description: 'Rasatura + olio',
        duration: 25, price: 18.0, icon: Icons.face_retouching_natural_rounded),
    Service(name: "Combo Dona's", description: 'Taglio + barba',
        duration: 55, price: 35.0, icon: Icons.auto_awesome_rounded),
  ];

  final List<DateTime> dates = List.generate(
    14,
    (i) => DateTime.now().add(Duration(days: i)),
  );

  @override
  void initState() {
    super.initState();
    _loadSlots();
  }

  Barber get _barber => demoBarbers[_selectedBarber];
  DateTime get _date => dates[_selectedDate];

  /// Barbieri che lavorano nel giorno selezionato
  List<Barber> get _availableBarbers =>
      demoBarbers.where((b) => b.worksOn(_date)).toList();

  List<String> get _allSlotsForDay {
    if (_barber.isAlwaysAvailable) {
      final set = <String>{};
      for (final b in _availableBarbers.where((b) => !b.isAlwaysAvailable)) {
        set.addAll(b.slotsFor(_date));
      }
      final list = set.toList()..sort();
      return list;
    }
    return _barber.slotsFor(_date);
  }

  Future<void> _loadSlots() async {
    setState(() => _loadingSlots = true);
    final booked = await _storage.bookedSlots(_barber.name, _date);
    if (!mounted) return;
    setState(() {
      _bookedSlots = booked;
      _loadingSlots = false;
      if (_selectedTime != null && booked.contains(_selectedTime)) {
        _selectedTime = null;
      }
    });
  }

Future<void> _confirm() async {
  if (_selectedTime == null) return;
  
  await NotificationService.requestPermissions();  // <-- permessi
  
  final parts = _selectedTime!.split(':');
  final dateTime = DateTime(
    _date.year, _date.month, _date.day,
    int.parse(parts[0]), int.parse(parts[1]),
  );
  final booking = Booking(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    serviceName: services[_selectedService].name,
    price: services[_selectedService].price,
    barberName: _barber.name,
    dateTime: dateTime,
    status: 'confirmed',
  );
  await _storage.saveBooking(booking);
  
  await NotificationService.scheduleBookingReminder(booking);  // <-- promemoria
  
  if (!mounted) return;
  context.push('/booking/success', extra: booking);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StepProgress(currentStep: 1),
                    const SizedBox(height: 28),
                    _buildSectionTitle('Servizio'),
                    const SizedBox(height: 12),
                    ...List.generate(services.length, (i) => ServiceCard(
                      service: services[i],
                      selected: _selectedService == i,
                      onTap: () => setState(() => _selectedService = i),
                    )),
                    const SizedBox(height: 28),
                    _buildSectionTitle('Barbiere'),
                    const SizedBox(height: 12),
                    if (_availableBarbers.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Nessun barbiere disponibile in questa data',
                            style: TextStyle(color: AppColors.textSecondary)),
                      )
                    else
                      SizedBox(
                        height: 116,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: demoBarbers.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (context, i) {
                            final b = demoBarbers[i];
                            final enabled = b.worksOn(_date);
                            return Opacity(
                              opacity: enabled ? 1 : 0.35,
                              child: BarberCard(
                                barber: b,
                                selected: _selectedBarber == i,
                                onTap: enabled
                                    ? () {
                                        setState(() {
                                          _selectedBarber = i;
                                          _selectedTime = null;
                                        });
                                        _loadSlots();
                                      }
                                    : () {},
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 28),
                    _buildSectionTitle('Data'),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: dates.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, i) => DateCard(
                          day: _weekdayLabel(dates[i].weekday),
                          date: dates[i].day.toString(),
                          selected: _selectedDate == i,
                          onTap: () {
                            setState(() {
                              _selectedDate = i;
                              _selectedTime = null;
                            });
                            _loadSlots();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildSectionTitle('Ora'),
                    const SizedBox(height: 12),
                    _buildTimeSlots(),
                    const SizedBox(height: 28),
                    _buildSectionTitle('Riepilogo'),
                    const SizedBox(height: 12),
                    SummaryCard(
                      service: services[_selectedService],
                      barber: _barber,
                      date: '${_weekdayLabel(_date.weekday)} ${_date.day}',
                      time: _selectedTime ?? '--:--',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildBottomBar(),
    );
  }

  Widget _buildTimeSlots() {
    if (_loadingSlots) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }
    final slots = _allSlotsForDay;
    if (slots.isEmpty) {
      return const Text('Nessun orario disponibile',
          style: TextStyle(color: AppColors.textSecondary));
    }
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: slots.map((t) {
        final booked = _bookedSlots.contains(t);
        return TimeChip(
          time: t,
          selected: _selectedTime == t,
          disabled: booked,
          onTap: booked ? () {} : () => setState(() => _selectedTime = t),
        );
      }).toList(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          _IconButton(icon: Icons.arrow_back_ios_new_rounded, onTap: () => context.pop()),
          const SizedBox(width: 16),
          const Expanded(
            child: Text('Prenota',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary, letterSpacing: -0.5)),
          ),
          _IconButton(icon: Icons.notifications_none_rounded, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String t) => Text(t,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
          color: AppColors.textPrimary, letterSpacing: -0.3));

  Widget _buildBottomBar() {
    final enabled = _selectedTime != null;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.96),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Totale',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                Text('€${services[_selectedService].price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20,
                        fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: enabled ? _confirm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.onAccent,
                  disabledBackgroundColor: AppColors.cardElevated,
                  disabledForegroundColor: AppColors.textMuted,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
                child: const Text('Conferma prenotazione',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _weekdayLabel(int w) =>
      const ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'][w - 1];
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: AppColors.glassFill,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
      );
}