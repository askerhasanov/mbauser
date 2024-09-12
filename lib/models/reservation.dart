import 'package:intl/intl.dart';

class Reservation {
  String id;
  String courseId;
  String userId;
  DateTime date;
  String time;

  Reservation({
    required this.id,
    required this.courseId,
    required this.userId,
    required this.date,
    required this.time,
  });

  // Factory constructor for creating a Reservation object from a database snapshot
  factory Reservation.fromMapEntry(MapEntry entry) {
    return Reservation(
      id: entry.key as String,
      courseId: entry.value['courseId'] as String,
      userId: entry.value['userId'] as String,
      date: DateTime.parse(entry.value['day'] as String),
      time: entry.value['time'] as String,
    );
  }

  // Method to convert a Reservation object to a map for database storage
  Map<String, dynamic>toJson() => {
    'courseId': courseId,
    'userId': userId,
    'day': DateFormat('y-MM-dd').format(date),
    'time': time,
  };
}