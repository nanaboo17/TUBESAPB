class Schedule {
  final String scheduleId;
  final String from;
  final String to;
  final DateTime date;
  final String time;
  final String type;
  final String? note;
  final num price;
  final int ticketsAvailable;

  Schedule({
    required this.scheduleId,
    required this.from,
    required this.to,
    required this.date,
    required this.time,
    required this.type,
    this.note,
    required this.price,
    required this.ticketsAvailable,
});
  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
      scheduleId: json['schedule_id'],
      from: json['from'],
      to: json['to'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      type: json['type'],
    price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
    ticketsAvailable: json['tickets_available'],
  );

  Map<String, dynamic> toJson() => {
    'schedule_id' : scheduleId,
    'from' : from,
    'to' : to,
    'date' : date.toIso8601String(),
    'time' : time,
    'type' : type,
    'note' : note,
    'price' : price,
    'tickets_available' : ticketsAvailable,
  };
}