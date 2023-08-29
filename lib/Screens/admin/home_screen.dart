import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Widgets/admin/auth_widget.dart';
import '../../Widgets/admin/home_widget.dart';
import '../../Widgets/admin/stats_map_widget.dart';

import '../../Widgets/admin/Profile_widget.dart';

class AdminHomeScreen extends StatefulWidget {
  AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final User? user = Auth().currentUser; // Utilisateur actuellement connecté

  Future<void> signOut() async {
    await user?.delete(); // Déconnexion de l'utilisateur
  }

  Widget _title() {
    return const Text("Admin Panel"); // Titre de l'application
  }

  Widget _userUid() {
    return Text(user?.email ??
        'User email'); // Affichage de l'adresse e-mail de l'utilisateur connecté
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'), // Bouton de déconnexion
    );
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      HomeWidget(),
      StatsMapWidget(),
      ProfileWidget(),
    ];

    void _onItemTapped(int index) {
      setState(() {
        selectedIndex =
            index; // Mettre à jour l'index de l'élément sélectionné dans la barre de navigation
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: _title(), // Afficher le titre dans la barre d'applications
        backgroundColor: Color.fromRGBO(
            22, 124, 172, 1), // Couleur de fond de la barre d'applications
      ),
      body: Center(
        child: widgetOptions.elementAt(
            selectedIndex), // Afficher le widget correspondant à l'index sélectionné
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Color.fromRGBO(22, 124, 172, 1),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart),
              label: 'Statistique',
              backgroundColor: Color.fromRGBO(22, 124, 172, 1),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Color.fromRGBO(22, 124, 172, 1),
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex:
              selectedIndex, // Index de l'élément actuellement sélectionné
          selectedItemColor: Colors.white, // Couleur de l'élément sélectionné
          iconSize: 32, // Taille des icônes de la barre de navigation
          onTap:
              _onItemTapped, // Appelé lorsque l'utilisateur sélectionne un élément de la barre de navigation
          elevation: 5),
    );
  }
}
