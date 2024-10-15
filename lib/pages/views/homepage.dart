import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mbauser/pages/views/courses.dart';
import 'package:mbauser/pages/views/garage.dart';
import 'package:mbauser/pages/views/landingPage.dart';
import 'package:mbauser/pages/views/posts.dart';
import 'package:provider/provider.dart';

import '../../elements/colors.dart';
import '../../providers/mbaProvider.dart';

class HomePage extends StatefulWidget {
  static const id = 'homepage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    LandingPage(),
    CoursesPage(),
    PostsPage(),
    GaragePage(),
    Text('Profile Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MBAProvider>(context, listen: false).loadCurrentUser();
    });
    _updateToken();
  }

  Future<void> _updateToken() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        DatabaseReference userRef =
        FirebaseDatabase.instance.ref('users/${user.uid}');
        await userRef.update({
          'token': token,
        });
      }
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbaColors.red,
      body: SafeArea(
          child: _widgetOptions.elementAt(_selectedIndex)
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent
        ),
        child: BottomNavigationBar(
          backgroundColor: MbaColors.dark,
          selectedItemColor: MbaColors.red,
          unselectedItemColor: MbaColors.lightRed2,
          type: BottomNavigationBarType.fixed,
          items:  const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Əsas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_motorsports),
              label: 'Kurslar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper),
              label: 'Yeniliklər',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesome.motorcycle_solid),
              label: 'Qaraj',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesome.info_solid),
              label: 'Haqqımızda',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,

        ),
      ),
    );
  }
}
