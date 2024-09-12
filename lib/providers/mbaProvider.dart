import 'package:flutter/material.dart';

class MBAProvider extends ChangeNotifier {


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