import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mbauser/globalVariables.dart';

import '../../elements/colors.dart';
import '../../elements/mbabutton.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    Future<void> resetPassword() async {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
            email: emailController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Şifrə sıfırlama emaili göndərildi.')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: MbaColors.red,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Text(
                        'Şifrənizi Unutmusunuz?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Emailinizi daxil edin və biz sizə şifrənizi sıfırlamaq üçün bir keçid göndərək.',
                        style: TextStyle(
                          color: MbaColors.lightText,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        'Emailiniz',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'you@mail.com',
                        enabledBorder: myBorder,
                      ),
                    ),
                    const SizedBox(height: 20),
                    MbaButton(
                      callback: resetPassword,
                      bgColor: MbaColors.red,
                      text: "Sıfırlama Emaili Göndər",
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}