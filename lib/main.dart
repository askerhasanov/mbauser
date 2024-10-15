import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mbauser/auth/views/register.dart';
import 'package:mbauser/elements/colors.dart';
import 'package:mbauser/firebase_options.dart';
import 'package:mbauser/providers/mbaProvider.dart';
import 'package:mbauser/services/notifactionService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'auth/views/selectEntry.dart';
import 'entrance/walktrough.dart';
import 'pages/views/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessagingService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showWalkthrough = true;
  bool _isLoading = true;
  String? _initialRoute;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  // Check if it's the user's first time opening the app
  Future<void> _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenWalkthrough = prefs.getBool('hasSeenWalkthrough') ?? false;

    // Check if user is logged in
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (mounted) {
      setState(() {
        if (currentUser != null) {
          // User is logged in, go to HomePage
          _initialRoute = HomePage.id;
        } else {
          // Determine whether to show walkthrough or entry page
          _initialRoute = hasSeenWalkthrough ? SelectEntryPage.id : WalkThroughPage.id;
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ChangeNotifierProvider(
      create: (BuildContext context) => MBAProvider(),
      child: MaterialApp(
        title: 'MBA User',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: MbaColors.red),
          useMaterial3: true,
        ),
        routes: {
          SelectEntryPage.id: (context) => const SelectEntryPage(),
          WalkThroughPage.id: (context) => WalkThroughPage(onComplete: _completeWalkthrough),
          RegisterPage.id: (context) => const RegisterPage(),
          HomePage.id: (context) => const HomePage(),
        },
        initialRoute: _initialRoute,
      ),
    );
  }

  void _completeWalkthrough() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenWalkthrough', true);
    if (mounted) {
      setState(() {
        _showWalkthrough = false;
      });
    }
  }
}
