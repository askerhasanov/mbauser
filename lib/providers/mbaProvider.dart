import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/user.dart'; // Import your UserModel class

class MBAProvider extends ChangeNotifier {
  String? _userId;
  UserModel? _currentUser; // Store the full user data

  String? get userId => _userId;
  UserModel? get currentUser => _currentUser; // Getter for the currentUser

  // This method fetches the user data from Firebase
  Future<void> loadCurrentUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _userId = currentUser.uid;
      await _loadUserFromDatabase(currentUser.uid); // Load user data from the database
      notifyListeners(); // Notify listeners that user data has been set
    }
  }

  // This method loads the user data from Firebase Realtime Database
  Future<void> _loadUserFromDatabase(String uid) async {
    DatabaseReference userRef = FirebaseDatabase.instance.ref('users/$uid');
    DatabaseEvent event = await userRef.once();

    if (event.snapshot.value != null) {
      Map<String, dynamic> userData = Map<String, dynamic>.from(event.snapshot.value as Map);
      _currentUser = UserModel.fromMap(uid, userData); // Assign to _currentUser
    }
  }

  /// RESERVATION DATE AND TIME SELECT

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  DateTime? finalDate;

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
}
