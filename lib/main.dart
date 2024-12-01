import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mbauser/auth/views/register.dart';
import 'package:mbauser/elements/colors.dart';
import 'package:mbauser/firebase_options.dart';
import 'package:mbauser/providers/mbaProvider.dart';
import 'package:mbauser/services/notifactionService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uni_links2/uni_links.dart';
import 'package:mbauser/helpers/deep_link_handler.dart'; // Import new handler
import 'auth/views/selectEntry.dart';
import 'entrance/walktrough.dart';
import 'pages/views/homepage.dart';
import 'dart:async';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late DeepLinkHandler deepLinkHandler; // Declare deep link handler

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessagingService.initialize();
  deepLinkHandler = DeepLinkHandler(navigatorKey); // Initialize deep link handler
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  String? _initialRoute;
  StreamSubscription<Uri?>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
    _initDeepLinkListener();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenWalkthrough = prefs.getBool('hasSeenWalkthrough') ?? false;

    User? currentUser = FirebaseAuth.instance.currentUser;

    if (mounted) {
      setState(() {
        _initialRoute = currentUser != null
            ? HomePage.id
            : (hasSeenWalkthrough ? SelectEntryPage.id : WalkThroughPage.id);
        _isLoading = false;
      });
    }
  }

  void _initDeepLinkListener() {
    _linkSubscription = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        deepLinkHandler.handleDeepLink(uri); // Delegate to the handler
      }
    }, onError: (err) {
      debugPrint('Deep link error: $err');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ChangeNotifierProvider(
      create: (BuildContext context) => MBAProvider(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'MBA User',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: MbaColors.red),
          useMaterial3: true,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          SelectEntryPage.id: (context) => const SelectEntryPage(),
          WalkThroughPage.id: (context) =>
              WalkThroughPage(onComplete: _completeWalkthrough),
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
  }
}
