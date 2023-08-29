import 'package:flutter/material.dart';

import '../../Screens/admin/home_screen.dart';

import '../../Screens/auth/Login_or_register_screen.dart';
import './auth_widget.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AdminHomeScreen(); // Afficher l'écran d'accueil de l'administrateur si des données sont disponibles
        } else {
          return LoginOrRegisterScreen(); // Sinon, afficher l'écran de connexion ou d'inscription
        }
      },
    );
  }
}
