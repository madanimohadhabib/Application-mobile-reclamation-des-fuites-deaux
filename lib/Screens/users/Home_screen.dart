import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Widgets/users/app_Drawer.dart';
import '../../Widgets/users/home_widget.dart';
import '../../Widgets/users/history_widget.dart';
import '../../Widgets/users/profile_widget.dart';

class HomeScreen extends StatefulWidget {
  static String screenRoute = 'HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Liste des widgets disponibles pour chaque onglet
    List<Widget> widgetOptions = <Widget>[
      HomeWidget(),
      HistoryWidget(),
      ProfileWidget()
    ];

    void _onItemTapped(int index) {
      // Met à jour l'index sélectionné lorsque l'utilisateur appuie sur un onglet
      setState(() {
        selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 22, 124, 172),
      ),
      drawer: AppDrawer(),
      body: Center(
        // Affiche le widget correspondant à l'onglet sélectionné
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Color.fromARGB(255, 22, 124, 172),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
                backgroundColor: Color.fromARGB(255, 22, 124, 172)),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Color.fromARGB(255, 22, 124, 172),
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: selectedIndex,
          selectedItemColor: Colors.white,
          iconSize: 32,
          onTap: _onItemTapped,
          elevation: 5),
    );
  }
}
