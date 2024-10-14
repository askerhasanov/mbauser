import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbauser/elements/dropDownFormField.dart';
import 'package:mbauser/elements/mbabutton.dart';
import 'package:mbauser/elements/uiHelpers.dart';
import 'package:firebase_database/firebase_database.dart'; // Firebase Database
import 'package:mbauser/providers/mbaProvider.dart';
import 'package:provider/provider.dart';
import '../../elements/pageheader.dart';
import '../../models/courseBasicData.dart';
import 'cardpaymentpage.dart';
import 'myCoursePage.dart';

class JoinCoursePage extends StatefulWidget {
  final String courseId;
  const JoinCoursePage({super.key, required this.courseId});

  @override
  State<JoinCoursePage> createState() => _JoinCoursePageState();
}

// Simulated course data function
CourseBasicData courseDataFromId(String id) {
  return CourseBasicData(
      id: 'dassdada',
      name: 'Sadə Paket',
      image: 'images/1.jpeg',
      price: '300',
      rating: '4.5',
      lessons: '8',
      days: '8',
      exams: '2');
}

class _JoinCoursePageState extends State<JoinCoursePage> {
  late SingleValueDropDownController _cntBranch;
  late SingleValueDropDownController _cntPayType;


  @override
  void initState() {
    super.initState();
    _cntBranch = SingleValueDropDownController();
    _cntPayType = SingleValueDropDownController();
  }


  @override
  void dispose() {
    _cntBranch.dispose();
    _cntPayType.dispose();
    super.dispose();
  }

  // Handle Cash Payment Logic
  void handleCashPayment() async {
    final userId = Provider.of<MBAProvider>(context, listen: false).userId;
    final paymentRef = FirebaseDatabase.instance.ref().child('payments/cash').push();
    await paymentRef.set({
      'courseId': widget.courseId,
      'userId': userId, // Replace with actual user ID
      'status': 'waiting for admin approval',
      'amount': courseDataFromId(widget.courseId).price,
      'branch': _cntBranch.dropDownValue?.value ?? 'unknown',
      'date': DateFormat('d/MMMM/y').format(DateTime.now()).toString(),
    });

    // Add course to user's myCourses node
    await FirebaseDatabase.instance.ref().child('users/${userId}/myCourses').push().set({
      'courseId': widget.courseId,
      'courseName': courseDataFromId(widget.courseId).name,
      'enrollmentDate': DateFormat('d/MMMM/y').format(DateTime.now()).toString(),
      'status': 'waiting for payment approval',
    });

    UiHelpers.showSnackBar(context: context, title: 'Nağd ödəniş əlavə olundu, adminin təsdiqini gözləyin.');

    // Redirect to MyCoursePage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyCoursePage()),
    );
  }

  // Handle Card Payment Logic
  void handleCardPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardPaymentPage(
          courseId: widget.courseId,
          onPaymentSuccess: (String transactionId) async {
            // Save card payment details to Firebase after successful payment
            final paymentRef = FirebaseDatabase.instance.ref().child('payments/card').push();
            await paymentRef.set({
              'courseId': widget.courseId,
              'userId': 'userId', // Replace with actual user ID
              'transactionId': transactionId,
              'status': 'paid',
              'amount': courseDataFromId(widget.courseId).price,
              'branch': _cntBranch.dropDownValue?.value ?? 'unknown',
              'date': DateFormat('d/MMMM/y').format(DateTime.now()).toString(),
            });

            // Add course to user's active courses
            await FirebaseDatabase.instance
                .ref()
                .child('users/userId/courses') // Replace 'userId' with actual user ID
                .child(widget.courseId)
                .set({
              'status': 'active',
              'enrollmentDate': DateFormat('d/MMMM/y').format(DateTime.now()).toString(),
            });

            UiHelpers.showSnackBar(context: context, title: 'Kartla ödəniş uğurlu oldu.');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// Header
          const pageHeader(text: 'Kursa qoşul'),

          /// SELECTED COURSE DATA AND PRICE
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.black.withAlpha(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Seçiminizə baxın',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16)),
                    const SizedBox(height: 10),
                    yourChoiceRow(title: 'Kursun adı:', text: courseDataFromId(widget.courseId).name),
                    const SizedBox(height: 5),
                    yourChoiceRow(title: 'Kursun qiyməti:', text: courseDataFromId(widget.courseId).price),
                    const SizedBox(height: 5),
                    yourChoiceRow(
                        title: 'Müraciət tarixi:',
                        text: DateFormat('d/MMMM/y').format(DateTime.now()).toString()),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: DropDownFormField(
                              title: 'Filial',
                              hint: 'filial seçin',
                              controller: _cntBranch,
                              map: const {"Mərkəz filialı": 'bayil', "Elite filialı": 'elit'}),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// SELECT PAYMENT TYPE
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.black.withAlpha(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ödəniş tipini seçin',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: DropDownFormField(
                              title: 'Tip:',
                              hint: 'tipi seçin',
                              controller: _cntPayType,
                              map: const {"Nağd": 'cash', "Kart": 'card'}),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// PROCEED BUTTON
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: MbaButton(
              callback: () {
                if (_cntPayType.dropDownValue == null) {
                  UiHelpers.showSnackBar(context: context, title: 'Ödəniş tipini seçin!');
                } else {
                  if (_cntPayType.dropDownValue!.value == 'cash') {
                    handleCashPayment(); // Call the cash payment function
                  } else {
                    handleCardPayment(); // Call the card payment function
                  }
                }
              },
              bgColor: Colors.red,
              text: 'DAVAM',
            ),
          ),
        ],
      ),
    );
  }
}

// Widget to display course details row
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
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(text),
            ),
          ),
        ),
      ],
    );
  }
}
