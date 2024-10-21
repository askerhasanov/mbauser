import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
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
            ? Center(child: CircularProgressIndicator()) // Show a loader while user data is being fetched
            : _widgetOptions.elementAt(_selectedIndex), // Once data is loaded, show the selected screen
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
            left: 10, right: 10, bottom: 10), // Padding around the bottom nav bar
        child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: MbaColors.dark,
              borderRadius: BorderRadius.circular(20), // Rounded corners for the container
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: Colors.transparent,
              selectedItemColor: MbaColors.red,
              unselectedItemColor: MbaColors.lightRed3,
              type: BottomNavigationBarType.fixed,
              items: [
                _buildNavigationBarItem(Icons.home, 'Əsas', 0),
                _buildNavigationBarItem(Icons.sports_motorsports, 'Kurslar', 1),
                _buildNavigationBarItem(Icons.newspaper, 'Yeniliklər', 2),
                _buildNavigationBarItem(FontAwesome.motorcycle_solid, 'Qaraj', 3),
                _buildNavigationBarItem(FontAwesome.info_solid, 'Haqqımızda', 4),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build BottomNavigationBarItem with rectangular background for selected item
  BottomNavigationBarItem _buildNavigationBarItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: _selectedIndex == index ? MbaColors.lightRed3 : Colors.white, // Colored rectangle for the selected item
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20),
            Text(
              label,
              style: TextStyle(
                color: _selectedIndex == index ? MbaColors.red : MbaColors.lightRed3,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      label: label,
    );
  }
}
