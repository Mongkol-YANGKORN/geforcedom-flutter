import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geforcedom/screen/option_screen.dart';
import 'package:geforcedom/screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.orange,
      ),
      home: SplashScreen(),
      //home: OptionScreen(),
    );
  }
}
