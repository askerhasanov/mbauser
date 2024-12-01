import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mbauser/elements/colors.dart';
import 'package:mbauser/elements/uiHelpers.dart';
import 'package:mbauser/helpers/reservation_helper.dart';
import 'package:mbauser/providers/mbaProvider.dart';
import 'package:provider/provider.dart';
import '../models/courseCard.dart';

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
    ReservationHelper.reserveSlot(context, false);
    // Show confirmation and set reserved state
    Navigator.of(context).pop(); // Close the dialog
    UiHelpers.showSnackBar(context: context, title: 'Rezervasiya uğurla yerinə yetirildi');
    setState(() {
      isReserved = true;
    });
  }

  // Function to handle reservation cancellation (customized)
  void _cancelReservation(String selectedDate) async {
    if (ReservationHelper.isLessThanOneHourToNow(selectedDate)) {
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
      }
    }
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

  void _selectReservationDate() async {
    // Show dialog for selecting date and time
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Rezervasiya vaxtını seçin',
            style: TextStyle(
              color: MbaColors.dark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Consumer<MBAProvider>(
            builder: (context, provider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // Custom Date Selection Display
                      GestureDetector(
                        onTap: () {
                          ReservationHelper.selectDate(context);
                        },
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: MbaColors.lightRed3,
                          ),
                          child: Center(
                            child: Text(
                              provider.selectedDate != null
                                  ? DateFormat('d, MMM, yyyy').format(provider.selectedDate!)
                                  : 'Seçin',
                              style: TextStyle(
                                color: provider.selectedDate != null ? Colors.black : Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Time Selection Dropdown
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: ReservationHelper.timeSlotDropdown(context, (selectedTime) {
                          provider.selectTime(selectedTime);
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Check Slot Availability and Show Reserve Button if Available
                  ReservationHelper.checkSlotAvailability(context, () {
                    // Reserve slot and save payment details
                    ReservationHelper.reserveSlot(context, false);
                    Navigator.pop(context);
                    UiHelpers.showSnackBar(context: context, title: 'Reservation successful');
                  }),
                ],
              );
            },
          ),
        );
      },
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
                color: MbaColors.dark,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: MbaColors.white,
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
                                          color: MbaColors.dark,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      widget.course.courseName,
                                      style: const TextStyle(
                                        color: MbaColors.red,
                                        fontSize: 16,
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
                                          color: MbaColors.dark,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      widget.course.enrollmentDate,
                                      style: const TextStyle(
                                        color: MbaColors.red,
                                        fontSize: 16,
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
                                          color: MbaColors.dark,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      widget.course.branch,
                                      style: const TextStyle(
                                        color: MbaColors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Reservation Section
                                if (widget.course.status == 'ended')
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Bu kurs bitmişdir',
                                        style: TextStyle(
                                          color: MbaColors.red,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(
                                        width: 120,
                                        child: Text(
                                          'Rezervasiya:',
                                          style: TextStyle(
                                            color: MbaColors.dark,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Column(
                                          children: [
                                            Text(
                                              isReserved ? 'Rezervasiya edilmişdir' : 'Seçilməyib',
                                              style: const TextStyle(
                                                color: MbaColors.red,
                                                fontSize: 14,
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: widget.course.payment['status'] == 'payed'
                                                  ? (isReserved
                                                  ? () => _cancelReservation(DateTime.now().toString())
                                                  : _selectReservationDate)
                                                  : null, // Disable button if course is not active
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: statusColor(widget.course.payment['status']), // Disable button styling
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(isReserved ? Icons.cancel : Icons.calendar_month, color: widget.course.payment['status'] == 'payedOut' ? MbaColors.red: MbaColors.white),
                                                  SizedBox(width: 10),
                                                  Text(isReserved ? 'Ləğv et' : 'Seç', style: TextStyle(color: widget.course.payment['status'] == 'payedOut' ? MbaColors.red: MbaColors.white),),
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
                  color: MbaColors.red,
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
                          color: MbaColors.white,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.course.courseName,
                          style: const TextStyle(
                            color: MbaColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                  color: _getBackgroundColorForPayment(widget.course.payment['status']!),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    _getIconForPayment(widget.course.payment['status']!),
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

  Color statusColor(String status){
    return status == 'active'
        ? MbaColors.red
        : MbaColors.darkRed;
  }

  // Helper to determine icon based on payment status
  IconData _getIconForPayment(String paymentStatus) {
    if (paymentStatus == 'payed') {
      return FontAwesome.play_solid; // Play icon for payed status
    } else if (paymentStatus == 'waitingAdmin') {
      return FontAwesome.spinner_solid; // Loading/spinner icon for waiting status
    } else {
      return FontAwesome.exclamation_solid; // Default icon for other statuses
    }
  }

  // Helper to determine background color based on payment status
  Color _getBackgroundColorForPayment(String paymentStatus) {
    if (paymentStatus == 'payedOut') {
      return Colors.green; // Green for payed status
    } else if (paymentStatus == 'waitingAdmin') {
      return Colors.yellow[700]!; // Yellow for waiting status
    } else {
      return Colors.red; // Default red for other statuses
    }
  }
}
