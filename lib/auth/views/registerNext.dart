import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbauser/elements/colors.dart';
import 'package:mbauser/elements/mbabutton.dart';
import 'package:mbauser/elements/uiHelpers.dart';
import 'package:mbauser/globalVariables.dart';
import 'package:mbauser/pages/views/homepage.dart';

import '../../elements/dropDownFormField.dart';
import 'login.dart';



class RegisterNextPage extends StatefulWidget {

  final String userId;
  final String phone;

  const RegisterNextPage({super.key, required this.userId, required this.phone});

  static const String id = 'registerNext';

  @override
  State<RegisterNextPage> createState() => _RegisterNextPageState();
}



class _RegisterNextPageState extends State<RegisterNextPage> {

  TextEditingController birthDate = TextEditingController();
  TextEditingController profession = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController whereFind = TextEditingController();

  late SingleValueDropDownController _cntGender;
  late SingleValueDropDownController _cntFind;

  @override
  void initState() {
    _cntGender = SingleValueDropDownController();
    _cntFind = SingleValueDropDownController();
    super.initState();
  }

  @override
  void dispose() {
    _cntGender.dispose();
    _cntFind.dispose();
    super.dispose();
  }

  void storeAdditionalData() async {
    // Get the selected values
    String? gender = _cntGender.dropDownValue?.value; // Use dropDownValue to get the selected item
    String? howDidYouFindOut = _cntFind.dropDownValue?.value; // Use dropDownValue for the second controller

    DatabaseReference userRef = FirebaseDatabase.instance.ref('users/${widget.userId}');
    await userRef.update({
      'birthDate': birthDate.text,
      'profession': profession.text,
      'gender': gender,
      'howDidYouFindOut': howDidYouFindOut,
    });

    // Navigate to homepage
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false,
    );

  }


  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.input,
        initialDate: DateTime.now(), //get today's date
        firstDate:DateTime(1970), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2026)
    );
    if(pickedDate != null ){
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        birthDate.text = formattedDate;
      });
    }else{
      UiHelpers.showSnackBar(context: context, title: 'Tarix seçilməyib');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  Container(
                    decoration: const BoxDecoration(
                      color: MbaColors.red,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'davam',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Demək olarki, hazırsınız qeydiyyatınız üçün lazım olan digər məlumatları daxil edin.',
                            style: TextStyle(
                              color: MbaColors.lightText,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        formField(birthDate, 'Doğum tarixiniz', 'gun-ay-il', false, _selectDate),
                        formField(profession, 'Peşəniz', 'işiniz', false, null),
                        DropDownFormField(title: 'Cinsiniz', hint: 'seçin', controller: _cntGender, map: const {'kisi' : 'man', 'qadin' : 'woman', 'diger': 'other'}, isColumnar: true,),
                        DropDownFormField(title: 'Haradan öyrənmisiniz', hint: 'seçin', controller: _cntFind, map: const {'Sosial şəbəkədən' : 'social', 'Reklamlardan' : 'adds', 'Şəxsi tövsiyyə': 'offer', 'Özüm axtarmışam': 'search', 'digər': 'other', }, isColumnar: true,),
                        const SizedBox(height: 20,),
                        MbaButton(callback: storeAdditionalData, bgColor: MbaColors.red, text: 'Next'),
                        //donthaveaccount
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Hesabınız var?', style: TextStyle(color: MbaColors.black, fontWeight: FontWeight.bold, fontSize: 14),),
                            TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginPage()));
                                }, child: const Text('Giris edin', style: TextStyle(color: MbaColors.red, fontWeight: FontWeight.bold, fontSize: 14),)),
                          ],
                        )
                      ],
                    ),
                  )
                ]
            ),
          )
      ),
    );
  }



  Widget formField(TextEditingController controller, String label, String hint, bool isSecure, VoidCallback? onTap){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: TextField(
            controller: controller,
            obscureText: isSecure,
            cursorColor: Colors.red,
            decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                enabledBorder: myBorder,
                focusedBorder: myBorder,
                isDense: true
            ),
            onTap: onTap ?? (){},
          ),
        ),
        const SizedBox(height: 5,),
      ],
    );
  }
}
