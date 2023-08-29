import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './Detail_reclamation_par user_screen.dart';

class TousRecmationParUserScreen extends StatelessWidget {
  final DocumentSnapshot user;

  const TousRecmationParUserScreen({Key? key, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtenez une référence à la collection "reclamations" du document utilisateur spécifié
    CollectionReference reclamationsCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(user.id)
        .collection("reclamations");

    // Couleur par défaut pour l'état des réclamations
    Color statusColor = Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Réclamations de ${user['nom']} ${user['prenom']}",
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: Color.fromRGBO(22, 124, 172, 1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: reclamationsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Obtenez la liste des documents de réclamation à partir du snapshot
          List<QueryDocumentSnapshot> reclamations = snapshot.data!.docs;

          if (reclamations.isEmpty) {
            // Affiche un message s'il n'y a pas de réclamations pour cet utilisateur
            return Center(
                child: Text("Aucune réclamation pour cet utilisateur"));
          }

          // Affiche la liste des réclamations sous forme de ListView
          return ListView.builder(
            itemCount: reclamations.length,
            itemBuilder: (context, index) {
              // Obtenez le document de réclamation actuel
              DocumentSnapshot reclamation = reclamations[index];
              String titre = reclamation['titre'];
              String date = reclamation['date'];
              String status = reclamation['status'];

              // Détermine la couleur de l'état en fonction de la valeur de "status"
              if (status == 'En cours') {
                statusColor = Colors.amber;
              } else if (status == 'Terminé') {
                statusColor = Colors.green;
              } else {
                statusColor = Colors.red;
              }

              // ... Accédez aux autres champs de la réclamation

              // Affiche une tuile ListTile pour chaque réclamation
              return InkWell(
                onTap: () {
                  // Naviguez vers l'écran de détail de la réclamation lorsque l'utilisateur appuie dessus
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailReclamationParUserScreen(
                        data: reclamation,
                        user: user,
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(titre),
                  subtitle: Text(date),
                  trailing: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
