import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbauser/elements/colors.dart';
import 'package:mbauser/elements/dropDownFormField.dart';
import '../../elements/pageheader.dart';
import '../../models/courseBasicData.dart';


class JoinCoursePage extends StatefulWidget {
  final String courseId;
  const JoinCoursePage({super.key, required this.courseId});

  @override
  State<JoinCoursePage> createState() => _JoinCoursePageState();
}


CourseBasicData courseDataFromId(String id){
  return CourseBasicData(id: 'dassdada', name: 'Sadə Paket', image: 'images/1.jpeg', price: '300', rating: '4.5', lessons: '8', days: '8', exams: '2');
}

class _JoinCoursePageState extends State<JoinCoursePage> {


  late SingleValueDropDownController _cntBranch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cntBranch =SingleValueDropDownController();
  }

  @override
  void dispose() {
    _cntBranch.dispose();
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ///header
          pageHeader(text: 'Kursa qoşul'),
          /// SELECTED COURSE DATA AND PRICE
          Container(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.black.withAlpha(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///title
                      Text(
                        'Seçiminizə baxın',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
                      ),
                      SizedBox(height: 10,),
                      yourChoiceRow(title: 'Kursun adı:', text: courseDataFromId(widget.courseId).name),
                      SizedBox(height: 5,),
                      yourChoiceRow(title: 'Kursun qiyməti:', text: courseDataFromId(widget.courseId).price),
                      SizedBox(height: 5,),
                      yourChoiceRow(title: 'Müraciət tarixi:', text: DateFormat('d/MMMM/y').format(DateTime.now()).toString()),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Expanded(child: DropDownFormField(title: 'Filial', hint: 'filial seçin', controller: _cntBranch, map: {"Mərkəz filialı": 'bayil', "Elite filialı": 'elit'})),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          /// SELECT PAYMENT TYPE
          /// PROCEED
        ],
      ),
    );
  }
}

class yourChoiceRow extends StatelessWidget {
  final String title;
  final String text;
  const yourChoiceRow({
    super.key,
    required this.title,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 10,),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.red, width: 2)
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(text),
            ),
          ),
        ),
      ],
    );
  }
}
