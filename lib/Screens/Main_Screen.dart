import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/admin/widget_tree.dart';

import '../Widgets/users/app_Drawer.dart';
import '../Widgets/auth/auth_widget.dart';

import './users/Home_screen.dart';
import 'auth/Login_or_register_screen.dart';

class MainScreen extends StatelessWidget {
  static String screenRoute = 'mainscreen';
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 186, 216, 229),
      appBar: AppBar(
        title: const Text('MoBشكوى'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 22, 124, 172),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(30),
              color: Color.fromARGB(255, 186, 216, 229),
              child: Image(
                image: AssetImage("images/logo.jpg"),
                width: 140,
                height: 140,
              ),
            ),
            Text(
              'الجزائرية للمياه وحدة مستغانم',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 31, 110, 189),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 30.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StreamBuilder(
                              // StreamBuilder pour écouter les modifications de l'état d'authentification
                              stream: FirebaseAuth.instance.authStateChanges(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  // Si l'utilisateur est connecté, afficher l'écran HomeScreen
                                  return HomeScreen();
                                } else {
                                  // Sinon, afficher l'écran LoginOrRegisterScreen
                                  return LoginOrRegisterScreen();
                                }
                              },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 22, 124, 172),
                        minimumSize: const Size(320, 99),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: Colors.white, width: 1),
                        ),
                        elevation: 30,
                      ),
                      child: const Text(
                        "Utilisateur",
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
