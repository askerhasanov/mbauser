import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mbauser/auth/views/registerNext.dart';
import 'package:mbauser/elements/colors.dart';
import 'package:mbauser/elements/mbabutton.dart';
import '../../globalVariables.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const String id = 'register';

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

  void registerUser() async {
    print(email.text);

    if (password.text.trim() == password2.text.trim()) {
      try {
        // Create user with email and password
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );

        // Get FCM token for the user
        String? token = await FirebaseMessaging.instance.getToken();

        // Store user data and token in Firebase Realtime Database
        DatabaseReference userRef = FirebaseDatabase.instance.ref('users/${userCredential.user!.uid}');
        await userRef.set({
          'fullName': fullName.text,
          'userName': userName.text,
          'email': email.text,
          'phone': phone.text,
          'token': token,  // Store FCM token
        });

        // Navigate to RegisterNextPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterNextPage(userId: userCredential.user!.uid, phone: '+994${phone.text.trim()}',),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords do not match!")));
    }
  }

  String initialCountry = 'AZ';
  PhoneNumber number = PhoneNumber(isoCode: 'AZ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
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
                            'QEYDİYYAT',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Moto Baku Academy-də olan yeniliklərdən xəbərdar olmaq, kurslara qoşulmaq və başqa fürsətlər üçün qeydiyyatdan keçin!',
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
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          formField(fullName, 'Tam ad', 'Adınız Soyadınız', false),
                          formField(userName, 'İstifadəçi adı', 'username', false),
                          formField(email, 'Email', 'adınız@email', false),
                          // phone number
                          const Text(
                            'Telefon',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 40,
                            child: InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {},
                              onInputValidated: (bool value) {},
                              textAlignVertical: TextAlignVertical.center,
                              inputBorder: myBorder,
                              selectorConfig: mbaConfig,
                              hintText: 'Telefon Nömrəsi',
                              ignoreBlank: true,
                              textStyle: phoneTextStyle,
                              selectorTextStyle: phoneTextStyle,
                              initialValue: number,
                              textFieldController: phone,
                              cursorColor: MbaColors.red,
                              inputDecoration: InputDecoration(
                                  hintStyle: phoneTextStyle,
                                  enabledBorder: myBorder,
                                  focusedBorder: myBorder,
                                  isCollapsed: true,
                              ),
                              searchBoxDecoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: "Ölkə kodunu axtarın və ya seçin",
                                  icon: Icon(Icons.search, color: MbaColors.red,),
                                  hintStyle: phoneTextStyle,
                                  enabledBorder: myBorder,
                                  focusedBorder: myBorder,
                                  isDense: true
                              ),
                              formatInput: true,
                              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                              onSaved: (PhoneNumber number) {},
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          formField(password, 'Şifrə', '*******', true),
                          formField(password2, 'Şifrə təkrar', '*******', true),
                        ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: MbaButton(
                        callback: registerUser, bgColor: MbaColors.red, text: 'Next'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Hesabınız var?'),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                          child: const Text('Giris edin')),
                    ],
                  )
                ]),
          )),
    );
  }

  TextStyle phoneTextStyle = const TextStyle(
      color: MbaColors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
  );

  SelectorConfig mbaConfig = const SelectorConfig(
      selectorType: PhoneInputSelectorType.DIALOG,
      setSelectorButtonAsPrefixIcon: true,
      trailingSpace: true,
      leadingPadding: 15
  );

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'AZ');

    setState(() {
      this.number = number;
    });
  }

  Widget formField(
      TextEditingController controller, String label, String hint, bool isSecure) {
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
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(
          child: TextField(
            controller: controller,
            obscureText: isSecure,
            cursorColor: MbaColors.red,
            style: TextStyle(
              fontSize: 14,
              color: MbaColors.black,
              fontWeight: FontWeight.bold
            ),
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: EdgeInsets.all(10),
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              enabledBorder: myBorder,
              focusedBorder: myBorder,
              isDense: true
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
