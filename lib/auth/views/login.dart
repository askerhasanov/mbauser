import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mbauser/auth/views/register.dart';
import '../../elements/mbabutton.dart';
import '../../elements/mbadivider.dart';
import '../../elements/uiHelpers.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin{

  bool _remindMe = false;
  bool _obscureText = true;




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
                  SizedBox(height: 80,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Giriş',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 40,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text('Moto Baku Akademiyə xoş gəlmişsiniz!',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 300,
                          child: _buildEmailLogin(),
                        ),
                      ],
                    ),
                  ),
                  //rememberme
                  Row(
                    children: [
                      Checkbox(
                        value: _remindMe,
                        onChanged: (value) {
                          setState(() {
                            _remindMe = value!;
                          });
                        },
                      ),
                      Text('Məni xatırla', ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          // Forgot password action
                        },
                        child: Text('Şifrənizi unutmusunuz?',),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  MbaDivider(text: 'və ya', lineColor: Colors.red),
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(shape: CircleBorder()),
                          onPressed: (){
                            UiHelpers.showSnackBar(context: context, title: 'Google login gelecekde elave edilecekdir.');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Brand(Brands.google),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(shape: CircleBorder()),
                          onPressed: (){
                            UiHelpers.showSnackBar(context: context, title: 'Apple login gelecekde elave edilecekdir.');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Brand(Brands.apple_logo),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //donthaveaccount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Hesabınız yoxdur?'),
                      TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
                            }, child: Text('Qeydiyyatdan kecin')),
                    ],
                  ),
                ]
              ),
            ),
          )
      ),
    );
  }

  Widget _buildEmailLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
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
          decoration: InputDecoration(
            hintText: '***********@mail.com',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            'Şifrəniz',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        TextField(
          obscureText: _obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: "************",
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),),
        ),
        SizedBox(height: 20,),
        MbaButton(callback: () {}, bgColor: Colors.red, text: 'Daxil ol')
      ],
    );
  }
}

