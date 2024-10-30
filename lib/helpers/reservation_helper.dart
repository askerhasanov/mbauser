import 'package:flutter/material.dart';
import 'package:mbauser/elements/colors.dart';
import 'package:mbauser/pages/views/homepage.dart';
import 'package:mbauser/pages/views/myCoursePage.dart';
import 'package:provider/provider.dart';
import 'package:mbauser/providers/mbaProvider.dart';
import 'package:mbauser/services/reservationService.dart';
import 'package:mbauser/elements/uiHelpers.dart';

class ReservationHelper {
  // Generates a list of available time slots (9 AM to 8 PM by default)
  static List<String> getTimeSlots() {
    return List.generate(12, (index) => '${(9 + index).toString().padLeft(2, '0')}:00');
  }

  // Date selection widget
  static Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      Provider.of<MBAProvider>(context, listen: false).selectDate(pickedDate);
    }
  }

  // Reusable time slot selection dropdown
  static Widget timeSlotDropdown(BuildContext context, Function(TimeOfDay) onTimeSelected) {
    final provider = Provider.of<MBAProvider>(context, listen: false);

    return DropdownButtonFormField<String>(
      hint: Text('seçin', style: TextStyle(color: MbaColors.dark, fontSize: 14),),
      style: TextStyle(color: MbaColors.dark, fontSize: 14, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        filled: true,
        fillColor: MbaColors.lightRed3,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10), // Adjust this padding
      ),
      items: getTimeSlots().map((slot) {
        return DropdownMenuItem<String>(
          value: slot,
          child: Text(slot),
        );
      }).toList(),
      onChanged: (selectedSlot) {
        if (selectedSlot != null) {
          // Convert selected slot to TimeOfDay
          final timeParts = selectedSlot.split(':');
          final timeSlot = TimeOfDay(
            hour: int.parse(timeParts[0]),
            minute: int.parse(timeParts[1]),
          );
          provider.selectTime(timeSlot);
          onTimeSelected(timeSlot);
        }
      },
    );

  }

  // Method to check availability for the selected date and time slot
  static Widget checkSlotAvailability(BuildContext context, VoidCallback onAvailable) {
    final provider = Provider.of<MBAProvider>(context, listen: false);

    // Ensure a date and time slot have been selected
    if (provider.selectedDate == null || provider.selectedTime == null) {
      return const Text(
        'Zəhmət olmazsa tarix və saatı seçin.',
        style: TextStyle(color: MbaColors.red),
      );
    }

    return FutureBuilder<bool>(
      future: ReservationService().isSlotAvailable(
        provider.selectedDate!,
        '${provider.selectedTime!.hour.toString().padLeft(2, '0')}:${provider.selectedTime!.minute.toString().padLeft(2, '0')}',
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == true) {
          // Slot is available, show reserve button
          return ElevatedButton(
            onPressed: onAvailable,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Rezerv et', style: TextStyle(color: MbaColors.white, fontWeight: FontWeight.bold, fontSize: 14,),),
          );
        } else {
          return const Text(
            'Bu saat va tarixdə rezervasiya mümkün deyil.',
            style: TextStyle(color: Colors.red),
          );
        }
      },
    );
  }

  // Reserve a slot with the selected date and time
  static Future<void> reserveSlot(BuildContext context, bool fromCashPayment) async {
    final provider = Provider.of<MBAProvider>(context, listen: false);
    final userId = provider.userId;
    final userFullName = provider.currentUser!.fullName;
    final selectedDate = provider.selectedDate!;
    final selectedTime = provider.selectedTime!;
    final formattedTime = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';

    await ReservationService().addReservation(
      courseId: provider.selectedCourseId!,
      day: selectedDate,
      time: formattedTime,
      userFullName: userFullName!,
      forMeet: fromCashPayment
    );
  }
}
