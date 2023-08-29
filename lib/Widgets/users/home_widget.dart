import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Screens/users/reclamation_screen.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Color.fromRGBO(22, 124, 172, 1),
          ),
          onPressed: () {
            Navigator.pushNamed(context, ReclamationScreen.screenRoute);
          },
          icon: Icon(Icons.report),
          label: Text("Réclamation"),
        ),
      ),
    );
  }
}
