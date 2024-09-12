import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mbauser/auth/views/register.dart';
import 'package:mbauser/elements/colors.dart';
import 'package:mbauser/firebase_options.dart';
import 'package:mbauser/providers/mbaProvider.dart';
import 'package:provider/provider.dart';

import 'auth/views/selectEntry.dart';
import 'entrance/walktrough.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {



  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
          SelectEntryPage.id : (context) => SelectEntryPage(),
          WalkThroughPage.id : (context) => WalkThroughPage(),
          RegisterPage.id : (context) => RegisterPage()
        },
        initialRoute: WalkThroughPage.id,
      ),
    );
  }
}


