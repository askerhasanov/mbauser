import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class MBAProvider extends ChangeNotifier {
  String? _userId;
  UserModel? _currentUser;

  String? get userId => _userId;
  UserModel? get currentUser => _currentUser;

  // Load current user data
  Future<void> loadCurrentUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _userId = currentUser.uid;
      await _loadUserFromDatabase(currentUser.uid);
      notifyListeners();
    }
  }

  // Load user data from Firebase
  Future<void> _loadUserFromDatabase(String uid) async {
    DatabaseReference userRef = FirebaseDatabase.instance.ref('users/$uid');
    DatabaseEvent event = await userRef.once();

    if (event.snapshot.value != null) {
      Map<String, dynamic> userData = Map<String, dynamic>.from(event.snapshot.value as Map);
      _currentUser = UserModel.fromMap(uid, userData);
    }
  }

  /// Reservation selection fields
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  DateTime? finalDate;
  String? selectedCourseId;

  void selectDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void selectTime(TimeOfDay time) {
    selectedTime = time;
    notifyListeners();
  }

  void updateFinalDate(DateTime date) {
    finalDate = date;
    notifyListeners();
  }

  void setSelectedCourseId(String courseId) {
    selectedCourseId = courseId;
    notifyListeners();
  }
}
