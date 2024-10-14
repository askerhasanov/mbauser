import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mbauser/globalVariables.dart';

class MBAProvider extends ChangeNotifier {



  String? _userId;

  String? get userId => _userId;

  // This method fetches the user ID from Firebase Auth
  Future<void> loadCurrentUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _userId = currentUser.uid;
      CurrentUserID = _userId;
      notifyListeners(); // Notify listeners that userId has been set
    }
  }


  ///RESERVATION DATE AND TIME SELECT

  DateTime?  selectedDate;
  TimeOfDay? selectedTime;

  DateTime? finalDate;

  void selectDate(DateTime date){
    selectedDate = date;
    notifyListeners();
  }

  void selectTime(TimeOfDay time){
    selectedTime = time;
    notifyListeners();
  }

  void updateFinalDate(DateTime date){
    finalDate = date;
    notifyListeners();
  }
}