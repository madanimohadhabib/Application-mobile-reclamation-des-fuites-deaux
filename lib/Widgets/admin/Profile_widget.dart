import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_time_format/date_time_format.dart';

import '../../Screens/auth/Login_or_register_screen.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late String nom;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          getData(), // Appelle la méthode getData() pour obtenir les données
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return CircularProgressIndicator(); // Affiche un indicateur de chargement tant que les données ne sont pas prêtes
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: CircleAvatar(
                              radius: 60.0,
                              backgroundColor:
                                  Colors.amber, // Couleur de fond du cercle
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.center,
                                child: Text(
                                  '${nom.substring(0, 2)}',
                                  style: const TextStyle(
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "User: $nom",
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromRGBO(22, 124, 172, 1),
                            ),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .terminate(); // Ferme la connexion à Firestore
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LoginOrRegisterScreen()),
                                (route) => false,
                              );
                            },
                            icon: const Icon(Icons.logout),
                            label: const Text('Déconnecter'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  getData() async {
    await FirebaseFirestore.instance
        .collection('Admin')
        .doc('vVQO1IbVWTIK6TO70eeb')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        nom = documentSnapshot.get(
            'username'); // Récupère la valeur du champ 'username' dans le document 'AdminLogin'
      }
    });
  }
}
