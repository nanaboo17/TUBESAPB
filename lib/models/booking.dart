class Booking {
  final String bookingId;
  final String scheduleId;
  final String userId;
  final DateTime bookingDate;
  final int ticketsBooked;
  final int totalPrice;

  Booking({
    required this.bookingId,
    required this.scheduleId,
    required this.userId,
    required this.bookingDate,
    required this.ticketsBooked,
    required this.totalPrice,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    bookingId: json['booking_id'],
    scheduleId: json['schedule_id'],
    userId: json['user_id'],
    bookingDate: DateTime.parse(json['booking_date']),
    ticketsBooked: json['tickets_booked'],
    totalPrice: json['totalprice'],
  );

  Map<String, dynamic> toJson() => {
    'booking_id': bookingId,
    'schedule_id': scheduleId,
    'user_id': userId,
    'booking_date': bookingDate.toIso8601String(),
    'tickets_booked': ticketsBooked,
    'totalprice': totalPrice,
  };
}
