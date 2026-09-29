import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/booking/domain/entities/booking.dart';

class LocalStorage {
  static const _bookingsKey = 'bookings';
  static const _onboardingKey = 'onboarding_seen';

  // ---------- ONBOARDING ----------
  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  // ---------- BOOKINGS ----------
  Future<List<Booking>> getBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_bookingsKey) ?? [];
    return raw
        .map((e) => Booking.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveBooking(Booking booking) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_bookingsKey) ?? [];
    existing.add(jsonEncode(booking.toJson()));
    await prefs.setStringList(_bookingsKey, existing);
  }

  Future<void> removeBooking(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_bookingsKey) ?? [];
    existing.removeWhere((e) {
      final map = jsonDecode(e) as Map<String, dynamic>;
      return map['id'] == id;
    });
    await prefs.setStringList(_bookingsKey, existing);
  }

  /// Ritorna tutte le prenotazioni occupate per un barbiere in una certa data,
  /// per poter nascondere gli slot già presi.
  Future<Set<String>> bookedSlots(String barberName, DateTime date) async {
    final all = await getBookings();
    return all
        .where((b) =>
            b.barberName == barberName &&
            b.status == 'confirmed' &&
            b.dateTime.year == date.year &&
            b.dateTime.month == date.month &&
            b.dateTime.day == date.day)
        .map((b) =>
            '${b.dateTime.hour.toString().padLeft(2, '0')}:${b.dateTime.minute.toString().padLeft(2, '0')}')
        .toSet();
  }
}