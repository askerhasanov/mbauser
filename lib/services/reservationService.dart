import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:mbauser/models/courseData.dart';
import '../models/reservation.dart';

class ReservationService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Get a stream of courses
  Stream<List<CourseData>> getCourses() {
    return _database.child('courses').onValue.map((event) {
      final courses = <CourseData>[];
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          courses.add(CourseData.fromSnapshot(event.snapshot));
        });
      }
      return courses;
    });
  }

  // Add a reservation
  Future<void> addReservation({required String courseId, required DateTime day, required String time, required String userFullName, required bool forMeet}
      ) async {
    final reservationsRef = _database.child('reservations');
    final newReservationRef = reservationsRef.push();
    await newReservationRef.set(Reservation(
      id: newReservationRef.key!,
      courseId: courseId,
      userId: userFullName,
      date: day,
      time: time,
      forMeet: forMeet
    ).toJson());
  }

  // Check availability (simplified - you'll need to enhance this)
  Future<bool> isSlotAvailable(DateTime date, String time) async {

    String day = DateFormat('y-MM-dd').format(date);

    final snapshot = await _database
        .child('reservations')
        .orderByChild('day')
        .equalTo(day)
        .once();

    if (snapshot.snapshot.value != null) {
      final reservations = (snapshot.snapshot.value as Map<dynamic, dynamic>)
          .entries
          .map((e) => Reservation.fromMapEntry(e))
          .toList();

      final count = reservations.where(
              (r) => DateFormat('y-MM-dd').format(r.date) == day && r.time == time
            ).length;
      return count < 3;
    } else {
      return true; // No reservations yet
    }
  }

}