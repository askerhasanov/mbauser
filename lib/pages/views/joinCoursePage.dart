import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbauser/elements/dropDownFormField.dart';
import 'package:mbauser/elements/mbabutton.dart';
import 'package:mbauser/elements/uiHelpers.dart';
import '../../elements/pageheader.dart';
import '../../models/courseBasicData.dart';
import 'cardpaymentpage.dart';


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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ///header
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
                    ///title
                    const Text(
                      'Seçiminizə baxın',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 10,),
                    yourChoiceRow(title: 'Kursun adı:', text: courseDataFromId(widget.courseId).name),
                    const SizedBox(height: 5,),
                    yourChoiceRow(title: 'Kursun qiyməti:', text: courseDataFromId(widget.courseId).price),
                    const SizedBox(height: 5,),
                    yourChoiceRow(title: 'Müraciət tarixi:', text: DateFormat('d/MMMM/y').format(DateTime.now()).toString()),
                    const SizedBox(height: 5,),
                    Row(
                      children: [
                        Expanded(child: DropDownFormField(title: 'Filial', hint: 'filial seçin', controller: _cntBranch, map: const {"Mərkəz filialı": 'bayil', "Elite filialı": 'elit'})),
                      ],
                    )
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
                    ///title
                    const Text(
                      'Ödəniş tipini seçin',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(child: DropDownFormField(title: 'Tip:', hint: 'tipi seçin', controller: _cntPayType, map: const {"Nağd": 'cash', "Kart": 'card'})),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          /// PROCEED
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: MbaButton(
                callback: (){
                  if(_cntPayType.dropDownValue == null){
                    UiHelpers.showSnackBar(context: context, title:  'Ödəniş tipini seçin!',);
                  }else{
                    if(_cntPayType.dropDownValue!.value == 'cash'){
                    }else{
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const CardPaymentPage()));
                    }
                  }

                },
                bgColor: Colors.red, text: 'DAVAM'),
          )
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
        SizedBox(
          width: 150,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10,),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.red, width: 2)
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
