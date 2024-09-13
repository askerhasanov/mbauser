import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbauser/auth/views/verifyPhone.dart';
import 'package:mbauser/elements/mbabutton.dart';
import 'package:mbauser/elements/uiHelpers.dart';

import '../../elements/dropDownFormField.dart';
import 'login.dart';



class RegisterNextPage extends StatefulWidget {
  const RegisterNextPage({super.key});

  static const String id = 'register';

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


  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    const SizedBox(height: 50,),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Text('Demək olarki, hazırsınız qeydiyyatınız üçün lazım olan digər məlumatları daxil edin.',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    formField(birthDate, 'Doğum tarixiniz', 'gun-ay-il', false, _selectDate),
                    formField(profession, 'Peşəniz', 'işiniz', false, null),
                    DropDownFormField(title: 'Cinsiniz', hint: 'seçin', controller: _cntGender, map: const {'kisi' : 'man', 'qadin' : 'woman', 'diger': 'other'}),
                    DropDownFormField(title: 'Haradan öyrənmisiniz', hint: 'seçin', controller: _cntFind, map: const {'Sosial şəbəkədən' : 'social', 'Reklamlardan' : 'adds', 'Şəxsi tövsiyyə': 'offer', 'Özüm axtarmışam': 'search', 'digər': 'other', }),
                    const SizedBox(height: 20,),
                    MbaButton(callback: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const VerifyPhonePage()));
                    }, bgColor: Colors.red, text: 'Next'),
                    //donthaveaccount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Hesabınız var?'),
                        TextButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginPage()));
                            }, child: const Text('Giris edin')),
                      ],
                    )
                  ]
              ),
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
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1,
                        style: BorderStyle.solid
                    )
                ),
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
