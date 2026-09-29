#!/bin/bash

# =========================================================
#  Dona's Barber - Generatore Struttura e File
#  Esegui in Git Bash: ./generate_all.sh
# =========================================================

echo "🚀 Inizio generazione del progetto Dona's Barber..."
echo "---------------------------------------------------"

# ---------------------------------------------------------
# 1. CREAZIONE CARTELLE
# ---------------------------------------------------------

DIRS=(
    # Core
    "lib/core/constants"
    "lib/core/theme"
    "lib/core/router"
    "lib/core/utils"
    
    # Feature: Auth
    "lib/features/auth/presentation/screens"
    "lib/features/auth/presentation/widgets"
    "lib/features/auth/domain/entities"
    "lib/features/auth/domain/usecases"
    "lib/features/auth/data/models"
    "lib/features/auth/data/repositories"
    "lib/features/auth/data/services"
    
    # Feature: Home
    "lib/features/home/presentation/screens"
    "lib/features/home/presentation/widgets"
    "lib/features/home/providers"
    
    # Feature: Booking
    "lib/features/booking/presentation/screens"
    "lib/features/booking/presentation/widgets"
    "lib/features/booking/presentation/providers"
    "lib/features/booking/domain/entities"
    "lib/features/booking/domain/usecases"
    "lib/features/booking/data/models"
    "lib/features/booking/data/repositories"
    "lib/features/booking/data/services"
    
    # Feature: Appointments
    "lib/features/appointments/presentation/screens"
    "lib/features/appointments/presentation/widgets"
    "lib/features/appointments/domain/entities"
    "lib/features/appointments/domain/usecases"
    "lib/features/appointments/data/models"
    "lib/features/appointments/data/repositories"
    "lib/features/appointments/data/services"
    
    # Feature: Profile
    "lib/features/profile/presentation/screens"
    "lib/features/profile/presentation/widgets"
    "lib/features/profile/domain/entities"
    "lib/features/profile/domain/usecases"
    "lib/features/profile/data/models"
    "lib/features/profile/data/repositories"
    "lib/features/profile/data/services"
    
    # Shared & Data
    "lib/shared/widgets"
    "lib/shared/extensions"
    "lib/data/providers"
    "lib/data/models"
    "lib/presentation/providers"
    "lib/presentation/widgets"
    
    # Test & Assets
    "test/unit"
    "test/widget"
    "test/integration"
    "assets/images"
    "assets/icons"
    "assets/fonts"
)

for dir in "${DIRS[@]}"; do
    mkdir -p "$dir"
done
echo "✅ Cartelle create."

# ---------------------------------------------------------
# 2. FUNZIONE HELPER PER CREARE FILE DART
# ---------------------------------------------------------
create_file() {
    local filepath="$1"
    local classname="$2"
    local type="$3" # screen, widget, entity, usecase, repository, service
    
    local content=""
    
    case "$type" in
        screen)
            content="import 'package:flutter/material.dart';\n\nclass ${classname} extends StatelessWidget {\n  const ${classname}({super.key});\n\n  @override\n  Widget build(BuildContext context) {\n    return Scaffold(\n      appBar: AppBar(title: const Text('${classname}')),\n      body: const Center(child: Text('${classname}')),\n    );\n  }\n}"
            ;;
        widget)
            content="import 'package:flutter/material.dart';\n\nclass ${classname} extends StatelessWidget {\n  const ${classname}({super.key});\n\n  @override\n  Widget build(BuildContext context) {\n    return const SizedBox.shrink();\n  }\n}"
            ;;
        entity)
            content="class ${classname} {\n  final String id;\n\n  const ${classname}({required this.id});\n}"
            ;;
        usecase)
            content="class ${classname} {\n  const ${classname}();\n\n  Future<void> call() async {\n    // TODO: Implement logic\n  }\n}"
            ;;
        repository)
            content="abstract class ${classname} {\n  // TODO: Define repository methods\n}"
            ;;
        service)
            content="class ${classname} {\n  const ${classname}();\n\n  // TODO: Implement API calls\n}"
            ;;
        *)
            content="// TODO: Implement ${classname}"
            ;;
    esac

    if [ ! -f "$filepath" ]; then
        echo -e "$content" > "$filepath"
        echo "  📄 Creato: $filepath"
    else
        echo "  ⚠️  Già esistente: $filepath"
    fi
}

# ---------------------------------------------------------
# 3. CREAZIONE FILE PRINCIPALI (MAIN & APP)
# ---------------------------------------------------------
echo "📦 Creazione file principali..."

cat << 'EOF' > lib/main.dart
import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const DonasBarberApp());
}
EOF
echo "  📄 Creato: lib/main.dart"

cat << 'EOF' > lib/app.dart
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

class DonasBarberApp extends StatelessWidget {
  const DonasBarberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Dona's Barber",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
EOF
echo "  📄 Creato: lib/app.dart"

# ---------------------------------------------------------
# 4. CORE (COLORI, TEMA, ROUTER, UTILS)
# ---------------------------------------------------------
echo "📦 Creazione file Core..."

cat << 'EOF' > lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF0F0F10);
  static const surface = Color(0xFF1C1C1E);
  static const card = Color(0xFF2C2C2E);
  static const cardElevated = Color(0xFF3A3A3C);
  static const border = Color(0xFF3A3A3C);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFA1A1A6);
  static const textMuted = Color(0xFF6E6E73);
  static const accent = Color(0xFFD4AF37);
  static const accentDark = Color(0xFFB8942E);
  static const success = Color(0xFF30D158);
  static const danger = Color(0xFFFF453A);
}
EOF
echo "  📄 Creato: lib/core/constants/app_colors.dart"

cat << 'EOF' > lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'SF Pro Display',
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        onPrimary: Colors.black,
        onSurface: AppColors.textPrimary,
      ),
      useMaterial3: true,
    );
  }
}
EOF
echo "  📄 Creato: lib/core/theme/app_theme.dart"

cat << 'EOF' > lib/core/router/app_router.dart
import 'package:go_router/go_router.dart';
import '../../features/booking/presentation/screens/booking_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/booking',
    routes: [
      GoRoute(
        path: '/booking',
        builder: (context, state) => const BookingScreen(),
      ),
    ],
  );
}
EOF
echo "  📄 Creato: lib/core/router/app_router.dart"

create_file "lib/core/utils/validators.dart" "Validators" "usecase"
create_file "lib/core/utils/formatters.dart" "Formatters" "usecase"

# ---------------------------------------------------------
# 5. BOOKING FEATURE (CODICE UI COMPLETO)
# ---------------------------------------------------------
echo "📦 Creazione feature Booking (UI completa)..."

# Booking Screen (il codice che ti ho fornito prima)
cat << 'EOF' > lib/features/booking/presentation/screens/booking_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/service_card.dart';
import '../widgets/barber_card.dart';
import '../widgets/date_card.dart';
import '../widgets/time_chip.dart';
import '../widgets/glass_card.dart';
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
    Service(name: 'Taglio Classico', description: 'Capelli + styling', duration: 30, price: 22.0, icon: Icons.content_cut_rounded),
    Service(name: 'Barba Premium', description: 'Rasatura + olio', duration: 25, price: 18.0, icon: Icons.face_retouching_natural_rounded),
    Service(name: 'Combo Dona\'s', description: 'Taglio + barba', duration: 55, price: 35.0, icon: Icons.auto_awesome_rounded),
  ];

  final List<Barber> barbers = const [
    Barber(name: 'Primo disponibile', role: 'Qualsiasi', rating: 5.0, available: true, initials: 'DA'),
    Barber(name: 'Marco', role: 'Senior Barber', rating: 4.9, available: true, initials: 'MR'),
    Barber(name: 'Luca', role: 'Barber', rating: 4.8, available: false, initials: 'LC'),
    Barber(name: 'Dona', role: 'Master Barber', rating: 5.0, available: true, initials: 'DN'),
  ];

  final List<Map<String, String>> dates = const [
    {'day': 'Lun', 'date': '12'}, {'day': 'Mar', 'date': '13'}, {'day': 'Mer', 'date': '14'},
    {'day': 'Gio', 'date': '15'}, {'day': 'Ven', 'date': '16'}, {'day': 'Sab', 'date': '17'}, {'day': 'Dom', 'date': '18'},
  ];

  final List<String> times = const [
    '09:00', '09:45', '10:30', '11:15', '12:00', '14:00', '14:45', '15:30', '16:15', '17:00',
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
                    StepProgress(currentStep: 1),
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
            child: Text('Prenota', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5)),
          ),
          _IconButton(icon: Icons.notifications_none_rounded, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.3));
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
                const Text('Totale', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                Text('€${service.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: const Text('Conferma prenotazione', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
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
        width: 44, height: 44,
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
EOF
echo "  📄 Creato: lib/features/booking/presentation/screens/booking_screen.dart"

# Booking Widgets
cat << 'EOF' > lib/features/booking/presentation/widgets/glass_card.dart
import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double radius;

  const GlassCard({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.radius = 24});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}
EOF
echo "  📄 Creato: glass_card.dart"

cat << 'EOF' > lib/features/booking/presentation/widgets/service_card.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/service.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final bool selected;
  final VoidCallback onTap;

  const ServiceCard({super.key, required this.service, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.accent.withOpacity(0.12) : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.accent : AppColors.border, width: selected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: selected ? AppColors.accent : AppColors.cardElevated, borderRadius: BorderRadius.circular(16)),
              child: Icon(service.icon, color: selected ? Colors.black : AppColors.accent, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text('${service.duration} min • ${service.description}', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text('€${service.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: selected ? AppColors.accent : AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
EOF
echo "  📄 Creato: service_card.dart"

cat << 'EOF' > lib/features/booking/presentation/widgets/barber_card.dart
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
EOF
echo "  📄 Creato: barber_card.dart"

cat << 'EOF' > lib/features/booking/presentation/widgets/date_card.dart
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
EOF
echo "  📄 Creato: date_card.dart"

cat << 'EOF' > lib/features/booking/presentation/widgets/time_chip.dart
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
EOF
echo "  📄 Creato: time_chip.dart"

cat << 'EOF' > lib/features/booking/presentation/widgets/step_progress.dart
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
EOF
echo "  📄 Creato: step_progress.dart"

cat << 'EOF' > lib/features/booking/presentation/widgets/summary_card.dart
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
EOF
echo "  📄 Creato: summary_card.dart"

# Booking Entities
cat << 'EOF' > lib/features/booking/domain/entities/service.dart
import 'package:flutter/material.dart';

class Service {
  final String name;
  final String description;
  final int duration;
  final double price;
  final IconData icon;

  const Service({
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    required this.icon,
  });
}
EOF
echo "  📄 Creato: lib/features/booking/domain/entities/service.dart"

cat << 'EOF' > lib/features/booking/domain/entities/barber.dart
class Barber {
  final String name;
  final String role;
  final double rating;
  final bool available;
  final String initials;

  const Barber({
    required this.name,
    required this.role,
    required this.rating,
    required this.available,
    required this.initials,
  });
}
EOF
echo "  📄 Creato: lib/features/booking/domain/entities/barber.dart"

# ---------------------------------------------------------
# 6. GENERAZIONE AUTOMATICA FILE PER LE ALTRE FEATURE
# ---------------------------------------------------------
echo "📦 Creazione file per le altre feature..."

# Auth
create_file "lib/features/auth/presentation/screens/splash_screen.dart" "SplashScreen" "screen"
create_file "lib/features/auth/presentation/screens/onboarding_screen.dart" "OnboardingScreen" "screen"
create_file "lib/features/auth/presentation/screens/login_screen.dart" "LoginScreen" "screen"
create_file "lib/features/auth/presentation/screens/register_screen.dart" "RegisterScreen" "screen"
create_file "lib/features/auth/presentation/screens/otp_screen.dart" "OtpScreen" "screen"
create_file "lib/features/auth/presentation/widgets/social_login_button.dart" "SocialLoginButton" "widget"
create_file "lib/features/auth/presentation/widgets/otp_input.dart" "OtpInput" "widget"
create_file "lib/features/auth/domain/entities/user.dart" "User" "entity"
create_file "lib/features/auth/domain/usecases/login_usecase.dart" "LoginUseCase" "usecase"
create_file "lib/features/auth/domain/usecases/register_usecase.dart" "RegisterUseCase" "usecase"
create_file "lib/features/auth/data/models/user_model.dart" "UserModel" "entity"
create_file "lib/features/auth/data/repositories/auth_repository.dart" "AuthRepository" "repository"
create_file "lib/features/auth/data/services/auth_api_service.dart" "AuthApiService" "service"

# Home
create_file "lib/features/home/presentation/screens/home_screen.dart" "HomeScreen" "screen"
create_file "lib/features/home/presentation/widgets/next_appointment_card.dart" "NextAppointmentCard" "widget"
create_file "lib/features/home/presentation/widgets/quick_action_button.dart" "QuickActionButton" "widget"
create_file "lib/features/home/presentation/widgets/service_carousel.dart" "ServiceCarousel" "widget"
create_file "lib/features/home/providers/home_provider.dart" "HomeProvider" "usecase"

# Appointments
create_file "lib/features/appointments/presentation/screens/appointments_screen.dart" "AppointmentsScreen" "screen"
create_file "lib/features/appointments/presentation/widgets/appointment_card.dart" "AppointmentCard" "widget"
create_file "lib/features/appointments/presentation/widgets/tab_switcher.dart" "TabSwitcher" "widget"
create_file "lib/features/appointments/domain/entities/appointment.dart" "Appointment" "entity"
create_file "lib/features/appointments/domain/usecases/get_appointments_usecase.dart" "GetAppointmentsUseCase" "usecase"
create_file "lib/features/appointments/domain/usecases/cancel_appointment_usecase.dart" "CancelAppointmentUseCase" "usecase"
create_file "lib/features/appointments/data/models/appointment_model.dart" "AppointmentModel" "entity"
create_file "lib/features/appointments/data/repositories/appointments_repository.dart" "AppointmentsRepository" "repository"
create_file "lib/features/appointments/data/services/appointments_api_service.dart" "AppointmentsApiService" "service"

# Profile
create_file "lib/features/profile/presentation/screens/profile_screen.dart" "ProfileScreen" "screen"
create_file "lib/features/profile/presentation/widgets/loyalty_points_card.dart" "LoyaltyPointsCard" "widget"
create_file "lib/features/profile/presentation/widgets/user_stats.dart" "UserStats" "widget"
create_file "lib/features/profile/presentation/widgets/theme_switcher.dart" "ThemeSwitcher" "widget"
create_file "lib/features/profile/domain/entities/profile.dart" "Profile" "entity"
create_file "lib/features/profile/domain/usecases/get_profile_usecase.dart" "GetProfileUseCase" "usecase"
create_file "lib/features/profile/data/models/profile_model.dart" "ProfileModel" "entity"
create_file "lib/features/profile/data/repositories/profile_repository.dart" "ProfileRepository" "repository"
create_file "lib/features/profile/data/services/profile_api_service.dart" "ProfileApiService" "service"

# ---------------------------------------------------------
# 7. SHARED, DATA E PRESENTATION GLOBALI
# ---------------------------------------------------------
echo "📦 Creazione file Shared e globali..."

create_file "lib/shared/widgets/custom_button.dart" "CustomButton" "widget"
create_file "lib/shared/widgets/custom_text_field.dart" "CustomTextField" "widget"
create_file "lib/shared/widgets/loading_indicator.dart" "LoadingIndicator" "widget"
create_file "lib/shared/widgets/bottom_nav_bar.dart" "BottomNavBar" "widget"
create_file "lib/shared/extensions/context_extensions.dart" "ContextExtensions" "usecase"

create_file "lib/data/providers/api_client.dart" "ApiClient" "service"
create_file "lib/data/providers/local_storage.dart" "LocalStorage" "service"
create_file "lib/data/models/api_response.dart" "ApiResponse" "entity"

create_file "lib/presentation/providers/app_providers.dart" "AppProviders" "usecase"
create_file "lib/presentation/widgets/main_scaffold.dart" "MainScaffold" "widget"

# ---------------------------------------------------------
# 8. AGGIORNAMENTO PUBSPEC.YAML (Opzionale, scommentare se serve)
# ---------------------------------------------------------
echo ""
echo "⚠️  NOTA: Ricordati di aggiungere le dipendenze nel pubspec.yaml:"
echo "   - go_router"
echo "   - flutter_riverpod"
echo "   - dio"
echo ""

echo "---------------------------------------------------"
echo "🎉 STRUTTURA GENERATA CON SUCCESSO!"
echo "Ora esegui 'flutter pub get' per scaricare le dipendenze."
echo "---------------------------------------------------"