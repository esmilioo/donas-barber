class Booking {
  final String id;
  final String serviceName;
  final double price;
  final String barberName;
  final DateTime dateTime;
  final String status; // 'confirmed' | 'cancelled' | 'past'

  const Booking({
    required this.id,
    required this.serviceName,
    required this.price,
    required this.barberName,
    required this.dateTime,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'serviceName': serviceName,
        'price': price,
        'barberName': barberName,
        'dateTime': dateTime.toIso8601String(),
        'status': status,
      };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'] as String,
        serviceName: json['serviceName'] as String,
        price: (json['price'] as num).toDouble(),
        barberName: json['barberName'] as String,
        dateTime: DateTime.parse(json['dateTime'] as String),
        status: json['status'] as String,
      );
}