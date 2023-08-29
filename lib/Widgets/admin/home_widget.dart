import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Screens/admin/Tous_réclamation_par_user_screen.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late Stream<List<DocumentSnapshot>> _usersStream;

  @override
  void initState() {
    super.initState();
    // Définition du stream qui écoute les modifications de la collection "users"
    _usersStream = FirebaseFirestore.instance
        .collection("users")
        .snapshots()
        .asyncMap((snapshot) async {
      // Liste pour stocker les utilisateurs avec des réclamations
      List<DocumentSnapshot> usersWithReclamations = [];

      // Parcours de chaque document dans la collection "users"
      for (DocumentSnapshot document in snapshot.docs) {
        String uid = document.id;
        // Récupération des réclamations de l'utilisateur courant
        QuerySnapshot reclamationsSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("reclamations")
            .get();

        // Si l'utilisateur a des réclamations, on l'ajoute à la liste
        if (reclamationsSnapshot.docs.isNotEmpty) {
          usersWithReclamations.add(document);
        }
      }

      // Retourne la liste des utilisateurs avec réclamations
      return usersWithReclamations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListTile(
        title: const Text(
          "Listes des utilisateurs avec réclamations",
          style: TextStyle(
            fontSize: 22,
            color: Color.fromARGB(255, 22, 124, 172),
          ),
          textAlign: TextAlign.center,
        ),
        subtitle: Center(
          child: StreamBuilder<List<DocumentSnapshot>>(
            stream: _usersStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // Récupération des utilisateurs avec réclamations à partir du snapshot
              List<DocumentSnapshot>? usersWithReclamations = snapshot.data;

              if (usersWithReclamations == null ||
                  usersWithReclamations.isEmpty) {
                return const Center(
                    child: Text("Aucun utilisateur avec réclamations"));
              }

              return ListView.builder(
                itemCount: usersWithReclamations.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot user = usersWithReclamations[index];
                  String nom = user['nom'];
                  String prenom = user['prenom'];
                  // ... Accédez aux autres champs de l'utilisateur

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Card(
                            shadowColor:
                                const Color.fromARGB(255, 22, 124, 172),
                            child: InkWell(
                              onTap: () {
                                // Naviguer vers l'écran de réclamations pour l'utilisateur sélectionné
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TousRecmationParUserScreen(
                                      user: user,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(
                                    radius: 30.0,
                                    backgroundColor: Colors.blue,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${nom.substring(0, 1)}${prenom.substring(0, 1)}',
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    nom + " " + prenom,
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
