import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Screens/users/History_details_screen.dart';

class HistoryWidget extends StatefulWidget {
  @override
  _HistoryWidgetState createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late User firebaseUser;
  late String uid;

  @override
  void initState() {
    super.initState();
    firebaseUser = auth.currentUser!;
    uid = firebaseUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.red;

    return StreamBuilder<QuerySnapshot>(
      // Stream to listen to changes in the Firestore collection
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('reclamations')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(
              'Une erreur s\'est produite'); // Display error message if there's an error
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:
                  CircularProgressIndicator()); // Display loading spinner while waiting for data
        }

        List<QueryDocumentSnapshot> reclamationDocuments = snapshot.data!.docs;

        if (reclamationDocuments.isEmpty) {
          // Display a message if no reclamations are found
          return Center(
            child: Text(
              'Aucune réclamation trouvée.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 22, 124, 172),
              ),
            ),
          );
        }

        return ListTile(
          title: const Text(
            "Mes Historique",
            style: TextStyle(
              fontSize: 22,
              color: Color.fromARGB(255, 22, 124, 172),
            ),
            textAlign: TextAlign.center,
          ),
          subtitle: Center(
            child: ListView.builder(
              itemCount: reclamationDocuments.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> reclamationData =
                    reclamationDocuments[index].data() as Map<String, dynamic>;
                String uid = reclamationData['uid'];
                String titre = reclamationData['titre'];
                String date = reclamationData['date'];
                String description = reclamationData['description'];
                String image = reclamationData['photoUrl'];
                String status = reclamationData['status'];
                if (status == 'En cours') {
                  statusColor = Colors.amber;
                } else if (status == 'Terminé') {
                  statusColor = Colors.green;
                } else {
                  statusColor = Colors.red;
                }

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryDetailsScreen(
                          data: reclamationData,
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
            ),
          ),
        );
      },
    );
  }
}
