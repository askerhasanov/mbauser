import 'package:flutter/material.dart';
import 'package:mbauser/auth/views/register.dart';
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
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPvgG42cbWEZ671jfzHk7vCoMu-5cafhoCbw&s')),
              SizedBox(height: 100,),
              Container(
                child: Column(
                  children: [
                    MbaButton(callback: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                    }, bgColor: Colors.black, text: "Giris"),
                    SizedBox(height: 20,),
                    MbaButtonOutline(callback: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
                    }, lineColor: Colors.black, text: "Qediyyat"),
                    SizedBox(height: 20,),
                  ],
                ),
              )
            ],
          ),
        )));
  }
}






