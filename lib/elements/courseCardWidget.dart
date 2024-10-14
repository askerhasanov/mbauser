import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mbauser/elements/colors.dart';
import 'package:mbauser/elements/uiHelpers.dart';
import 'package:mbauser/providers/mbaProvider.dart';
import 'package:provider/provider.dart';
import '../../services/reservationService.dart';
import '../globalVariables.dart';
import '../models/coursecard.dart';

class CourseCardWidget extends StatefulWidget {
  final CourseCardModel course;

  const CourseCardWidget({super.key, required this.course});

  @override
  _CourseCardWidgetState createState() => _CourseCardWidgetState();
}

class _CourseCardWidgetState extends State<CourseCardWidget> {
  bool isReserved = false;

  @override
  void initState() {
    super.initState();
    // Set the reservation status based on the course data (logic can be customized)
    isReserved = widget.course.status == 'active'; // Example logic
  }

  // Function to reserve the slot (from your MyCoursePage.dart)
  void _reserveSlot(DateTime date, String time) async {
    final reservationData = {
      "courseId": widget.course.courseId,
      "day": DateFormat('y-MM-dd').format(date),
      "time": time,
      "userId": CurrentUserID, // Use global user ID
    };

    FirebaseDatabase database = FirebaseDatabase.instance;
    await database.ref('reservations').push().set(reservationData);

    // Show confirmation and set reserved state
    Navigator.of(context).pop(); // Close the dialog
    UiHelpers.showSnackBar(context: context, title: 'Rezervasiya uğurla yerinə yetirildi');

    setState(() {
      isReserved = true;
    });
  }

  // Function to handle reservation cancellation (customized)
  void _cancelReservation(String selectedDate) async {
    if (isLessThanOneHourToNow(selectedDate)) {
      UiHelpers.showSnackBar(
        context: context,
        title: 'Vaxt keçdiyi üçün və ya bir saatdan az vaxt qaldığı üçün ləğv edə bilməzsiniz!',
      );
    } else {
      var response = await _showYesNoDialog();
      if (response == 'yes') {
        setState(() {
          isReserved = false;
          Provider.of<MBAProvider>(context, listen: false).finalDate = null;
        });
        // Add the logic to actually cancel the reservation
      }
    }
  }

  // Helper function to check if less than one hour is left for cancellation
  bool isLessThanOneHourToNow(String dateTimeString) {
    DateTime givenDateTime = DateTime.parse(dateTimeString);
    DateTime now = DateTime.now();
    Duration difference = givenDateTime.difference(now);
    return difference.isNegative || difference.inMinutes < 60;
  }

  // Function to show Yes/No dialog for confirmation
  Future<String?> _showYesNoDialog() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Təsdiq'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Dərsin başlamasına bir saatdan artıq vaxt qalmışdır. Yenə də ləğv etmək istəyirsinizmi?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Xeyr'),
              onPressed: () {
                Navigator.of(context).pop('no'); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Bəli'),
              onPressed: () {
                Navigator.of(context).pop('yes'); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Function to present the date and time picker for reservation
  void _selectReservationDate() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rezervasiya vaxtını seçin'),
          content: SizedBox(
            height: 400, // Adjusted height for better appearance
            width: double.maxFinite,
            child: Consumer<MBAProvider>(
              builder: (_, state, __) {
                return Column(
                  children: [
                    // Date and Time selection row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _presentDatePicker,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: MbaColors.red,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                state.selectedDate != null
                                    ? DateFormat('E, d MMM, yyyy').format(state.selectedDate!).toString()
                                    : 'Tarix',
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _presentTimePicker,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: MbaColors.red,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                state.selectedTime != null
                                    ? '${state.selectedTime!.hour.toString().padLeft(2, '0')} : ${state.selectedTime!.minute.toString().padLeft(2, '0')}'
                                    : 'Saat',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20), // Space between elements

                    // FutureBuilder to check slot availability
                    if (state.selectedDate != null && state.selectedTime != null)
                      FutureBuilder<bool>(
                        future: ReservationService().isSlotAvailable(
                          state.selectedDate!,
                          '${state.selectedTime!.hour.toString().padLeft(2, '0')}:${state.selectedTime!.minute.toString().padLeft(2, '0')}',
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Display loading indicator
                          } else if (snapshot.hasError) {
                            return Container(
                              child: Center(child: Text('Error: ${snapshot.error}')),
                            );
                          } else if (snapshot.hasData && snapshot.data == true) {
                            // Slot is available, show Reserve button
                            return Column(
                              children: [
                                const Text('Slot is available', style: TextStyle(color: Colors.green)),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    _reserveSlot(
                                      state.selectedDate!,
                                      '${state.selectedTime!.hour.toString().padLeft(2, '0')}:${state.selectedTime!.minute.toString().padLeft(2, '0')}',
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MbaColors.red,
                                  ),
                                  child: const Text('Reserve'),
                                ),
                              ],
                            );
                          } else {
                            return const Text('Slot is not available', style: TextStyle(color: Colors.red));
                          }
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Date picker for selecting reservation date
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      Provider.of<MBAProvider>(context, listen: false).selectDate(pickedDate);
    });
  }

  // Time picker for selecting reservation time
  void _presentTimePicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Saatı seçin'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: _buildTimeList(),
          ),
        );
      },
    );
  }

  // Function to build available time slots
  Widget _buildTimeList() {
    DateTime now = DateTime.now();
    int currentHour = now.hour;
    int startHour = currentHour + 1;
    if (startHour < 9) startHour = 9; // Ensure minimum start time is 9 AM
    int endHour = 21; // 9 PM

    List<Widget> timeSlots = [];
    for (int hour = startHour; hour <= endHour; hour++) {
      timeSlots.add(
        ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${hour.toString().padLeft(2, '0')}:00',
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
          onTap: () {
            Provider.of<MBAProvider>(context, listen: false).selectTime(TimeOfDay(hour: hour, minute: 00));
          },
        ),
      );
    }
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.0, // Adjust as needed
      ),
      shrinkWrap: true,
      children: timeSlots,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: MbaColors.darkRed,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: MbaColors.lightRed,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Course Name
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(
                                      width: 120,
                                      child: Text(
                                        'Kursun adı:',
                                        style: TextStyle(
                                          color: MbaColors.darkRed,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      widget.course.courseName,
                                      style: const TextStyle(
                                        color: MbaColors.darkRed,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Enrollment Date
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(
                                      width: 120,
                                      child: Text(
                                        'Qeydiyyat tarixi:',
                                        style: TextStyle(
                                          color: MbaColors.darkRed,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      widget.course.enrollmentDate,
                                      style: const TextStyle(
                                        color: MbaColors.darkRed,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Branch
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(
                                      width: 120,
                                      child: Text(
                                        'Filial:',
                                        style: TextStyle(
                                          color: MbaColors.darkRed,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      widget.course.branch,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Reservation Section
                                if (widget.course.status == 'ended')
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Bu kurs bitmişdir',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                        child: Text(
                                          'Rezervasiya:',
                                          style: TextStyle(
                                            color: MbaColors.darkRed,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            const Icon(
                                              FontAwesome.calendar_check,
                                              color: MbaColors.red,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                isReserved ? 'Rezervasiya edilmişdir' : 'Seçilməyib',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: widget.course.status == 'active'
                                                  ? (isReserved
                                                  ? () => _cancelReservation(DateTime.now().toString())
                                                  : _selectReservationDate)
                                                  : null, // Disable button if course is not active
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: widget.course.status == 'active'
                                                    ? MbaColors.red
                                                    : Colors.grey, // Disable button styling
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(isReserved ? FontAwesome.x_solid : FontAwesome.calendar),
                                                  const SizedBox(width: 10),
                                                  Text(isReserved ? 'Ləğv et' : 'Seç'),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -30,
              left: 30,
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 200,
                ),
                decoration: const BoxDecoration(
                  color: MbaColors.light,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.sports_motorsports,
                          color: MbaColors.red,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.course.courseName,
                          style: const TextStyle(
                            color: MbaColors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: _getBackgroundColorForPayment(widget.course.payment),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    _getIconForPayment(widget.course.payment),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to determine icon based on payment status
  IconData _getIconForPayment(String paymentStatus) {
    if (paymentStatus == 'payed') {
      return FontAwesome.play_solid; // Play icon for payed status
    } else if (paymentStatus == 'waiting') {
      return FontAwesome.spinner_solid; // Loading/spinner icon for waiting status
    } else {
      return FontAwesome.exclamation_solid; // Default icon for other statuses
    }
  }

  // Helper to determine background color based on payment status
  Color _getBackgroundColorForPayment(String paymentStatus) {
    if (paymentStatus == 'payed') {
      return Colors.green; // Green for payed status
    } else if (paymentStatus == 'waiting') {
      return Colors.yellow[700]!; // Yellow for waiting status
    } else {
      return Colors.red; // Default red for other statuses
    }
  }
}
