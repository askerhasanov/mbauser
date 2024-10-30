import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbauser/elements/colors.dart';
import 'package:mbauser/elements/dropDownFormField.dart';
import 'package:mbauser/elements/mbabutton.dart';
import 'package:mbauser/elements/pageheader.dart';
import 'package:mbauser/elements/uiHelpers.dart';
import 'package:provider/provider.dart';
import '../../helpers/reservation_helper.dart';
import '../../models/courseData.dart';
import '../../providers/mbaProvider.dart';
import 'cardpaymentpage.dart';
import 'homepage.dart';
import 'myCoursePage.dart';

class JoinCoursePage extends StatefulWidget {
  final CourseData course;
  const JoinCoursePage({super.key, required this.course});

  @override
  State<JoinCoursePage> createState() => _JoinCoursePageState();
}

class _JoinCoursePageState extends State<JoinCoursePage> {
  late SingleValueDropDownController _cntBranch;
  late SingleValueDropDownController _cntPayType;

  @override
  void initState() {
    super.initState();
    _cntBranch = SingleValueDropDownController();
    _cntPayType = SingleValueDropDownController();

    // Set selected course in provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MBAProvider>(context, listen: false).setSelectedCourseId(widget.course.id);
    });
  }

  @override
  void dispose() {
    _cntBranch.dispose();
    _cntPayType.dispose();
    super.dispose();
  }

  void handleCashPayment() async {
    // Show dialog for selecting date and time
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'İlk dərs və ödəniş vaxtını seçin',
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
                    ReservationHelper.reserveSlot(context, true);
                    _savePaymentDetails('cash'); // Save cash payment details
                    Navigator.pop(context);
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MyCoursePage()),
                      ModalRoute.withName(HomePage.id), // This removes all routes until you reach the home route
                    );// Close reservation dialog
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

  void handleCardPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardPaymentPage(
          courseId: widget.course.id,
          onPaymentSuccess: (String transactionId) async {
            // Save payment details for card payment
            await _savePaymentDetails('card', transactionId: transactionId);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyCoursePage()),
            );
          },
        ),
      ),
    );
  }

  Future<void> _savePaymentDetails(String paymentType, {String? transactionId}) async {
    final provider = Provider.of<MBAProvider>(context, listen: false);
    final userId = provider.userId;
    final courseId = widget.course.id;
    final paymentId = FirebaseDatabase.instance.ref().child('payments').push().key;
    final paymentTime = DateTime.now();
    final paymentData = {
      'userId': userId,
      'price': widget.course.price,
      'status': paymentType == 'cash' ? 'waitingAdmin' : 'payedOut',
      'time': DateFormat('d/MMMM/y HH:mm').format(paymentTime),
      'forCourse': courseId,
    };

    if (paymentType == 'card') {
      paymentData['transactionId'] = transactionId;
      await FirebaseDatabase.instance.ref('payments/card/$paymentId').set(paymentData);
    } else {
      paymentData['paymentDate'] = provider.selectedDate != null
          ? DateFormat('d/MMMM/y').format(provider.selectedDate!)
          : null;
      await FirebaseDatabase.instance.ref('payments/cash/$paymentId').set(paymentData);
    }

    // Add course reference under user's myCourses
    await FirebaseDatabase.instance.ref('users/$userId/myCourses/$courseId').set({
      'courseName': widget.course.name,
      'enrollmentDate': DateFormat('d/MMMM/y HH:mm').format(DateTime.now()),
      'status': 'active',
      'branch' : _cntBranch.dropDownValue!.name,
      'payment': {
        'id': paymentId,
        'type': paymentType,
        'status': paymentType == 'card' ? 'payed' : 'waitingAdmin',
      },
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            pageHeader(text: "Kursa qoşul"),
            SizedBox(height: 10,),
        
            /// Course Data Display Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: MbaColors.lightRed3,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Seçiminizə baxın',
                          style: TextStyle(fontWeight: FontWeight.bold, color: MbaColors.dark, fontSize: 18)),
                      const SizedBox(height: 20),
                      yourChoiceRow(title: 'Kurs:', text: widget.course.name),
                      const SizedBox(height: 5),
                      yourChoiceRow(title: 'Qiymət:', text: widget.course.price),
                      const SizedBox(height: 5),
                      yourChoiceRow(
                          title: 'Tarix:',
                          text: DateFormat('d/MMMM/y').format(DateTime.now()).toString()),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(
                              'Filial: ',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              child: DropDownFormField(
                                title: '',
                                isColumnar: false,
                                hint: 'seçin',
                                controller: _cntBranch,
                                map: widget.course.category == 'vip'
                                    ? {"Mərkəz filialı": 'bayil', "Elite filialı": 'elit'}
                                    : {"Elite filialı": 'elit'},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        
            /// Payment Type Selection Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: MbaColors.lightRed3,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ödəniş tipini seçin',
                          style: TextStyle(fontWeight: FontWeight.bold, color: MbaColors.dark, fontSize: 18)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: DropDownFormField(
                              title: 'Tip:',
                              hint: 'tipi seçin',
                              isColumnar: false,
                              controller: _cntPayType,
                              map: const {"Nağd": 'cash', "Kart": 'card'},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        
            /// Proceed Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: MbaButton(
                callback: () {
                  if(_cntBranch.dropDownValue == null){
                    UiHelpers.showSnackBar(context: context, title: 'Filial seçin!');
                  }else{
                    if (_cntPayType.dropDownValue == null) {
                      UiHelpers.showSnackBar(context: context, title: 'Ödəniş tipini seçin!');
                    } else {
                      if (_cntPayType.dropDownValue!.value == 'cash') {
                        handleCashPayment();
                      } else {
                        handleCardPayment();
                      }
                    }
                  }
                },
                bgColor: Colors.red,
                text: 'DAVAM',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget to display a row of course details
class yourChoiceRow extends StatelessWidget {
  final String title;
  final String text;
  const yourChoiceRow({super.key, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: MbaColors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(text, style: TextStyle(color: MbaColors.red),),
            ),
          ),
        ),
      ],
    );
  }
}
