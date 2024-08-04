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

  TabController? _tabController;
  bool _remindMe = false;
  bool _obscureText = true;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                  SizedBox(height: 50,),
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
                  SizedBox(height: 20,),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            TabBar(
                              overlayColor:WidgetStateProperty.all<Color>(Colors.transparent),
                              tabAlignment: TabAlignment.start,
                              dividerHeight: 0,
                              labelColor: Colors.red,
                              indicator: const UnderlineTabIndicator(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 4,
                                  )
                              ),
                              isScrollable: true,
                              controller: _tabController,
                              tabs: const [
                                Tab(
                                  child: Row(
                                    children: [
                                      Icon(EvaIcons.email_outline),
                                      SizedBox(width: 10,),
                                      Text('Email'),
                                    ],
                                  ),
                                ),
                                Tab(
                                  child: Row(
                                    children: [
                                      Icon(EvaIcons.phone_call_outline),
                                      SizedBox(width: 10,),
                                      Text('Telefon'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ]
                        ),
                        Container(
                          height: 300,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildEmailLogin(),
                              _buildPhoneLogin(),
                            ],
                          ),
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
                      Text('Remind Me', ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          // Forgot password action
                        },
                        child: Text('Forgot Password?',),
                      ),
                    ],
                  ),
                  MbaDivider(text: 'və ya', lineColor: Colors.red),
              
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(shape: CircleBorder()),
                          onPressed: (){
                            UiHelpers.showSnackBar(context, 'Google login gelecekde elave edilecekdir.');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Brand(Brands.google),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(shape: CircleBorder()),
                          onPressed: (){
                            UiHelpers.showSnackBar(context, 'Apple login gelecekde elave edilecekdir.');
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

    Widget _buildPhoneLogin() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Nömrəniz',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Center(
            child: TextField(
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
          ),
        ]
      );
    }

    Widget _buildSocialButton(String assetPath) {
      return CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage(assetPath),
      );
    }
}

