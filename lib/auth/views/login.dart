import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mbauser/auth/views/register.dart';
import 'package:mbauser/auth/views/forgot_password.dart'; // Added forgot password page import
import 'package:shared_preferences/shared_preferences.dart';
import '../../elements/colors.dart';
import '../../elements/mbabutton.dart';
import '../../elements/mbadivider.dart';
import '../../elements/uiHelpers.dart';
import '../../globalVariables.dart';
import '../../pages/views/homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String id = 'login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool _remindMe = false;
  bool _obscureText = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLoginInfo();
  }

  // Load saved email and password if "Remember Me" was selected
  Future<void> _loadLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('savedEmail');
    String? savedPassword = prefs.getString('savedPassword');
    bool? remindMe = prefs.getBool('remindMe') ?? false;

    if (remindMe) {
      setState(() {
        _remindMe = remindMe;
        emailController.text = savedEmail ?? '';
        passwordController.text = savedPassword ?? '';
      });
    }
  }

  void loginUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Save login info if "Remember Me" is selected
      if (_remindMe) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('savedEmail', emailController.text.trim());
        await prefs.setString('savedPassword', passwordController.text.trim());
        await prefs.setBool('remindMe', _remindMe);
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('savedEmail');
        await prefs.remove('savedPassword');
        await prefs.setBool('remindMe', _remindMe);
      }

      // On success, navigate to the HomePage
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
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
            children: [
              const SizedBox(
                height: 20,
              ),
              //top
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Container(
                  decoration: const BoxDecoration(
                    color: MbaColors.red,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GİRİŞ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Moto Baku Academy hesabınıza daxil olun. Fürsətlərdən yararlanın!',
                          style: TextStyle(
                            color: MbaColors.lightBg,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hesabınıza daxil olun!',
                      style: TextStyle(
                          color: MbaColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 300,
                      child:
                          _buildEmailLogin(emailController, passwordController),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Checkbox(
                      activeColor: MbaColors.red,
                      value: _remindMe,
                      onChanged: (value) {
                        setState(() {
                          _remindMe = value!;
                        });
                      },
                    ),
                    const Text(
                      'Məni xatırla',
                      style: TextStyle(
                          color: MbaColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordPage()));
                      },
                      child: const Text(
                        'Şifrənizi unutmusunuz?',
                        style: TextStyle(
                            color: MbaColors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: MbaDivider(text: 'və ya', lineColor: Colors.red),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(shape: const CircleBorder()),
                      onPressed: () {
                        UiHelpers.showSnackBar(
                            context: context,
                            title: 'Google login gelecekde elave edilecekdir.');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Brand(Brands.google),
                            const Text('Google')
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(shape: const CircleBorder()),
                      onPressed: () {
                        UiHelpers.showSnackBar(
                            context: context,
                            title: 'Apple login gelecekde elave edilecekdir.');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Brand(Brands.apple_logo),
                            const Text('Apple')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Hesabınız yoxdur?',
                    style: TextStyle(
                        color: MbaColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()));
                      },
                      child: const Text(
                        'Qeydiyyatdan keçin',
                        style: TextStyle(
                            color: MbaColors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailLogin(
      TextEditingController email, TextEditingController password) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            'Email',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: MbaColors.lightRed3,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
              controller: email,
              cursorColor: MbaColors.red,
              style: const TextStyle(
                  fontSize: 15,
                  color: MbaColors.black,
                  fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                  hintText: 'you@mail.com',
                  contentPadding: EdgeInsets.all(10),
                  hintStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: MbaColors.lightText3),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true)),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            'Şifrə',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: MbaColors.lightRed3,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
              obscureText: _obscureText,
              controller: password,
              cursorColor: MbaColors.red,
              style: const TextStyle(
                  fontSize: 15,
                  color: MbaColors.black,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: "**********",
                contentPadding: const EdgeInsets.all(10),
                hintStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: MbaColors.lightText3),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: MbaColors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              )),
        ),
        const SizedBox(height: 30),
        MbaButton(
            callback: loginUser, bgColor: MbaColors.red, text: "DAXİL OL"),
      ],
    );
  }
}
