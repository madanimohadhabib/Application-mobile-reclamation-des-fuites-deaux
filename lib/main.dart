import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import './Screens/Main_Screen.dart';
import 'Screens/auth/Login_or_register_screen.dart';
import './Screens/users/Home_screen.dart';
import './Screens/users/reclamation_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChaakwaMob',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: MainScreen.screenRoute,
        routes: {
          MainScreen.screenRoute: (context) => MainScreen(),
          LoginOrRegisterScreen.screenRoute: (context) =>
              LoginOrRegisterScreen(),
          HomeScreen.screenRoute: (context) => const HomeScreen(),
          ReclamationScreen.screenRoute: (context) => ReclamationScreen(),
        });
  }
}
