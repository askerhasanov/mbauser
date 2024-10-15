import 'package:flutter/material.dart';
import 'package:mbauser/auth/views/register.dart';
import 'package:mbauser/elements/colors.dart';
import '../../elements/mbabutton.dart';
import '../../elements/mbabuttonoutline.dart';
import 'login.dart';


class SelectEntryPage extends StatefulWidget {
  const SelectEntryPage({super.key});

  static const id = "selectEntry";

  @override
  State<SelectEntryPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<SelectEntryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbaColors.lightBg,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 50,),
                    Image.asset('images/mbalogo.png', height: 100,),
                    const SizedBox(height: 30,),
                    const Text('XOŞ GƏLMİSİNİZ', style: TextStyle(color: MbaColors.red, fontWeight: FontWeight.bold, fontSize: 40),),
                    const SizedBox(height: 20,),
                    const Text('Yeni macəranıza başlamağa hazır olun!', style: TextStyle(color: MbaColors.black, fontWeight: FontWeight.bold, fontSize: 18),),
                    const SizedBox(height: 45,),
                    Image.asset('images/welcome.png', width: MediaQuery.of(context).size.width*0.95,),
                  ],
                )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: SizedBox(
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    MbaButton(callback: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginPage()));
                    }, bgColor: MbaColors.red, text: "DAXİL OL"),
                    const SizedBox(height: 30,),
                    MbaButtonOutline(callback: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const RegisterPage()));
                    }, lineColor: MbaColors.red, text: "QEYDİYYAT"),
                    const SizedBox(height: 80,),
                  ],
                ),
              ),
            )
          ],
        )));
  }
}






