import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mbauser/auth/views/registerNext.dart';
import 'package:mbauser/elements/mbabutton.dart';

import 'login.dart';



class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static final String id = 'register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}



class _RegisterPageState extends State<RegisterPage> {


  TextEditingController fullName = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password2 = TextEditingController();

  String initialCountry = 'AZ';
  PhoneNumber number = PhoneNumber(isoCode: 'AZ');

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
                    SizedBox(height: 30,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Qeydiyyat',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 30,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text('Moto Baku Academy-də olan yeniliklərdən xəbərdar olmaq, kurslara qoşulmaq və sürməyi öyrənməy üçün qeydiyyatdan keçin!',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          formField(fullName, 'Ad Soyad', 'Adınız, Soyadınız', false),
                          formField(userName, 'İstifadəçi adı', 'istifadəçiadı', false),
                          formField(email, 'Email', 'adınız@email.com', false),
                          // phone number
                          Text('Telefon Nömrəsi', textAlign: TextAlign.start, style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),),
                          SizedBox(height: 5,),
                          Container(
                            height: 40,
                            alignment: Alignment.center,
                            decoration:  BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.transparent,
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                              child: InternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber number) {
                                  print(number);
                                },
                                onInputValidated: (bool value) {
                                  print(value);
                                },
                                textAlignVertical: TextAlignVertical.center,
                                selectorConfig: const SelectorConfig(
                                  selectorType: PhoneInputSelectorType.DIALOG,
                                  setSelectorButtonAsPrefixIcon: true,
                                  trailingSpace: false,
                                ),
                                hintText: 'Telefon Nömrəsi',
                                ignoreBlank: true,
                                autoValidateMode: AutovalidateMode.disabled,
                                textStyle: const TextStyle(color: Colors.black, fontSize: 14,),
                                selectorTextStyle: const TextStyle(color: Colors.black,),
                                initialValue: number,
                                textFieldController: phone,
                                formatInput: true,
                                keyboardType:  const TextInputType.numberWithOptions(signed: true, decimal: true),
                                inputBorder: InputBorder.none,
                                onSaved: (PhoneNumber number) {
                                  print('On Saved: $number');
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          formField(password, 'Şifrə', '*******', true),
                          formField(password2, 'Şifrə təkrar', '*******', true),
                        ]
                      )
                    ),
                    SizedBox(height: 20,),
                    MbaButton(callback: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterNextPage()));
                    }, bgColor: Colors.red, text: 'Next'),
                    //donthaveaccount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Hesabınız var?'),
                        TextButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                            }, child: Text('Giris edin')),
                      ],
                    )
                  ]
              ),
            ),
          )
      ),
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  Widget formField(TextEditingController controller, String label, String hint, bool isSecure){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Container(
          height: 40,
          child: TextField(
            controller: controller,
            obscureText: isSecure,
            cursorColor: Colors.red,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1,
                  style: BorderStyle.solid
                )
              ),
              isDense: true
            ),
          ),
        ),
        SizedBox(height: 10,),
      ],
    );
  }
}
