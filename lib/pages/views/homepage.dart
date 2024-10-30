import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../elements/colors.dart';
import '../../models/user.dart';
import '../../providers/mbaProvider.dart';
import 'courses.dart';
import 'garage.dart';
import 'landingPage.dart';
import 'posts.dart';

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
        DatabaseReference userRef = FirebaseDatabase.instance.ref('users/${user.uid}');
        await userRef.update({'token': token});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the current user data from the provider
    UserModel? user = Provider.of<MBAProvider>(context).currentUser;

    return Scaffold(
      backgroundColor: MbaColors.lightBg,
      body: SafeArea(
        child: user == null
            ? const Center(child: CircularProgressIndicator()) // Show a loader while user data is being fetched
            : _widgetOptions.elementAt(_selectedIndex), // Once data is loaded, show the selected screen
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: MbaColors.red,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20.0),
          child: SalomonBottomBar(
            currentIndex: _selectedIndex,
            selectedItemColor: MbaColors.white,
            unselectedItemColor: MbaColors.dark,
            backgroundColor: MbaColors.red,
            itemPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            onTap: _onItemTapped,
            items: [
              _bottomBarItem(Icons.home, 'Əsas',),
              _bottomBarItem(Icons.sports_motorsports, 'Kurslar'),
              _bottomBarItem(Icons.newspaper, 'Yeniliklər',),
              _bottomBarItem(Icons.warehouse, 'Qaraj',),
              _bottomBarItem(Icons.info_outline, 'Info',),
            ],
          ),
        ),
      ),
    );
  }

  SalomonBottomBarItem _bottomBarItem(IconData icon, String label){
    return SalomonBottomBarItem(
      icon: Icon(icon,),
      title: Text(label),
    );
  }

}
