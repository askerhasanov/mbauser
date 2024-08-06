import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mbauser/elements/colors.dart';
import 'package:mbauser/elements/mbabutton.dart';
import 'package:mbauser/elements/uiHelpers.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../../pages/views/homepage.dart';


class VerifyPhonePage extends StatefulWidget {
  const VerifyPhonePage({super.key});

  @override
  State<VerifyPhonePage> createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage> {

  Timer? countdownTimer;
  Duration myDuration = const Duration(minutes: 2);
  int tryCount = 0;

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        myDuration = const Duration(minutes: 2);
        tryCount++;
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }


  final OtpFieldController _otpController = OtpFieldController();
  String otp = '';



  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50,),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: '+994 50 562 6565',
                      style: const TextStyle(fontFamily: 'Spark-Bold', color: Colors.black, fontSize: 16),
                      children: const [
                        TextSpan(
                          text: '  nömrəsinə təsdiq mesajı göndərilmişdir! Zəhmət olmazsa mesajdakı 6 rəqəmli kodu daxil edin.',
                          style: TextStyle(fontFamily: 'Spark-Medium', color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15,),
                  // Full Name
                  OTPTextField(
                      controller: _otpController,
                      length: 6,
                      width: MediaQuery.of(context).size.width,
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldWidth: 45,
                      fieldStyle: FieldStyle.box,
                      outlineBorderRadius: 15,
                      style: const TextStyle(fontSize: 17),
                      onChanged: (pin) {
                        print("Changed: $pin");
                      },
                      onCompleted: (pin) {
                        setState(() {
                          otp = pin;
                        });
                      }),
                  const SizedBox(height: 15,),
                  Text('Təsdiq mesajı yenidən göndəriləcək: $minutes:$seconds'),
                  const SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: MbaButton(callback: () {
                      // check network availability
                      //var connectivityResult = await Connectivity().checkConnectivity();
                      //if(!connectivityResult.contains(ConnectivityResult.mobile)  && !connectivityResult.contains(ConnectivityResult.wifi)){
                      //  UiHelpers.showSnackBar(context, 'İnternetə bağlanmaq mümkün deyil!');
                     //   return;
                     // }
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                      //loginUser();
                    }, bgColor: MbaColors.red, text: 'Davam')
                  ),
                  const SizedBox(height: 40,),
                ],
              ),
            ),
          )
      ),
    );
  }
}
