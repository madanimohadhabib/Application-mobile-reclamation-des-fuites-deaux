import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/admin/widget_tree.dart';
import '../Widgets/users/app_Drawer.dart';
import '../Widgets/auth/auth_widget.dart';
import './users/Home_screen.dart';
import 'auth/Login_or_register_screen.dart';

class MainScreen extends StatelessWidget {
  static String screenRoute = 'mainscreen';

  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('images/logo.jpg'),
      title: const Text(
        "الجزائرية للمياه وحدة مستغانم",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.grey.shade400,
      showLoader: true,
      loadingText: Text("Loading..."),
      navigator: FutureBuilder<User?>(
        // Use FutureBuilder to handle the asynchronous operation
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the authentication result, show a loading indicator
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            // If the user is authenticated, navigate to HomeScreen
            return HomeScreen();
          } else {
            // If not authenticated, navigate to LoginOrRegisterScreen
            return LoginOrRegisterScreen();
          }
        },
      ),
      durationInSeconds: 6,
    );
  }
}
