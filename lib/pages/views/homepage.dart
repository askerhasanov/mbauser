import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mbauser/pages/views/courses.dart';
import 'package:mbauser/pages/views/garage.dart';
import 'package:mbauser/pages/views/landingPage.dart';
import 'package:mbauser/pages/views/posts.dart';

import '../../elements/colors.dart';

class HomePage extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbaColors.red,
      body: SafeArea(
          child: _widgetOptions.elementAt(_selectedIndex)
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: MbaColors.red,
        selectedItemColor: Colors.white,
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
    );
  }
}
