import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/service_card.dart';
import '../widgets/barber_card.dart';
import '../widgets/date_card.dart';
import '../widgets/time_chip.dart';
import '../widgets/step_progress.dart';
import '../widgets/summary_card.dart';
import '../../domain/entities/service.dart';
import '../../domain/entities/barber.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedService = 0;
  int _selectedBarber = 0;
  int _selectedDate = 0;
  String _selectedTime = '10:30';

  final List<Service> services = const [
    Service(
      name: 'Taglio Classico',
      description: 'Capelli + styling',
      duration: 30,
      price: 22.0,
      icon: Icons.content_cut_rounded,
    ),
    Service(
      name: 'Barba Premium',
      description: 'Rasatura + olio',
      duration: 25,
      price: 18.0,
      icon: Icons.face_retouching_natural_rounded,
    ),
    Service(
      name: "Combo Dona's",
      description: 'Taglio + barba',
      duration: 55,
      price: 35.0,
      icon: Icons.auto_awesome_rounded,
    ),
  ];

  final List<Barber> barbers = const [
    Barber(name: 'Primo disponibile', role: 'Qualsiasi', rating: 5.0, available: true, initials: 'DA'),
    Barber(name: 'Marco', role: 'Senior Barber', rating: 4.9, available: true, initials: 'MR'),
    Barber(name: 'Luca', role: 'Barber', rating: 4.8, available: false, initials: 'LC'),
    Barber(name: 'Dona', role: 'Master Barber', rating: 5.0, available: true, initials: 'DN'),
  ];

  final List<Map<String, String>> dates = const [
    {'day': 'Lun', 'date': '12'},
    {'day': 'Mar', 'date': '13'},
    {'day': 'Mer', 'date': '14'},
    {'day': 'Gio', 'date': '15'},
    {'day': 'Ven', 'date': '16'},
    {'day': 'Sab', 'date': '17'},
    {'day': 'Dom', 'date': '18'},
  ];

  final List<String> times = const [
    '09:00', '09:45', '10:30', '11:15', '12:00',
    '14:00', '14:45', '15:30', '16:15', '17:00',
  ];

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
                    ...List.generate(services.length, (index) {
                      return ServiceCard(
                        service: services[index],
                        selected: _selectedService == index,
                        onTap: () => setState(() => _selectedService = index),
                      );
                    }),
                    const SizedBox(height: 28),
                    _buildSectionTitle('Barbiere'),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 116,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: barbers.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) => BarberCard(
                          barber: barbers[index],
                          selected: _selectedBarber == index,
                          onTap: () => setState(() => _selectedBarber = index),
                        ),
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
                        itemBuilder: (context, index) => DateCard(
                          day: dates[index]['day']!,
                          date: dates[index]['date']!,
                          selected: _selectedDate == index,
                          onTap: () => setState(() => _selectedDate = index),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildSectionTitle('Ora'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: times.map((time) => TimeChip(
                        time: time,
                        selected: _selectedTime == time,
                        onTap: () => setState(() => _selectedTime = time),
                      )).toList(),
                    ),
                    const SizedBox(height: 28),
                    _buildSectionTitle('Riepilogo'),
                    const SizedBox(height: 12),
                    SummaryCard(
                      service: services[_selectedService],
                      barber: barbers[_selectedBarber],
                      date: '${dates[_selectedDate]['day']} ${dates[_selectedDate]['date']}',
                      time: _selectedTime,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _buildBottomBar(services[_selectedService]),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          _IconButton(icon: Icons.arrow_back_ios_new_rounded, onTap: () {}),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Prenota',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
          ),
          _IconButton(icon: Icons.notifications_none_rounded, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildBottomBar(Service service) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.94),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Totale',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                Text(
                  '€${service.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Conferma prenotazione',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.10)),
        ),
        child: Icon(icon, size: 20, color: AppColors.textPrimary),
      ),
    );
  }
}