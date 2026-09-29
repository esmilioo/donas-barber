class Barber {
  final String id;
  final String name;
  final String role;
  final double rating;
  final String initials;
  /// weekday: 1 = Lunedì ... 7 = Domenica
  /// value: lista di orari disponibili, es. ['09:00', '09:30']
  final Map<int, List<String>> schedule;

  const Barber({
    required this.id,
    required this.name,
    required this.role,
    required this.rating,
    required this.initials,
    required this.schedule,
  });

  bool worksOn(DateTime date) => schedule.containsKey(date.weekday);

  List<String> slotsFor(DateTime date) => schedule[date.weekday] ?? [];

  bool get isAlwaysAvailable => id == 'any';
}