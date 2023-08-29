import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_time_format/date_time_format.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late String nom, prenom, telephone, email;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return CircularProgressIndicator();
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
                                  Colors.blue, // Couleur de fond du cercle
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.center,
                                child: Text(
                                  '${nom.substring(0, 1)}${prenom.substring(0, 1)}',
                                  style: TextStyle(
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Nom et Prénom: $nom $prenom", // Affiche le nom et le prénom
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Téléphone: $telephone", // Affiche le numéro de téléphone
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Email: $email", // Affiche l'adresse email
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromRGBO(22, 124, 172, 1),
                            ),
                            onPressed: () async {
                              await FirebaseAuth.instance
                                  .signOut(); // Déconnecte l'utilisateur
                            },
                            icon: Icon(Icons.logout),
                            label: Text('Déconnecter'),
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
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          nom = documentSnapshot.get('nom'); // Récupère le nom depuis Firestore
          prenom = documentSnapshot
              .get('prenom'); // Récupère le prénom depuis Firestore
          telephone = documentSnapshot.get(
              'telephone'); // Récupère le numéro de téléphone depuis Firestore
          email = documentSnapshot
              .get('email'); // Récupère l'adresse email depuis Firestore
        }
      });
    }
  }
}
