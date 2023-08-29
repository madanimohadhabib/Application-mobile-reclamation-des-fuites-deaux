import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../Widgets/users/reclamation_widget.dart';

class ReclamationScreen extends StatefulWidget {
  static String screenRoute = 'ReclamationScreen';

  @override
  State<ReclamationScreen> createState() => _ReclamationScreenState();
}

class _ReclamationScreenState extends State<ReclamationScreen> {
  void _submitReclamation(String titre, String description, String date,
      File? photo, double latitude, double longitude, String address) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? firebaseUser = auth.currentUser;

    if (firebaseUser != null) {
      String uid = firebaseUser.uid;

      // Récupérer les informations de l'utilisateur depuis Firestore
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          String nom = documentSnapshot.get('nom');
          String prenom = documentSnapshot.get('prenom');
          String telephone = documentSnapshot.get('telephone');
          String email = documentSnapshot.get('email');

          // Définir le nom du fichier pour la photo de la réclamation
          String fileName = 'photo_$photo.jpg';

          // Référence de stockage pour la photo dans Firebase Storage
          firebase_storage.Reference storageRef = firebase_storage
              .FirebaseStorage.instance
              .ref()
              .child('reclamation_photos/$fileName');

          // Tâche d'upload de la photo vers Firebase Storage
          firebase_storage.UploadTask uploadTask = storageRef.putFile(photo!);

          // Attendre la fin de l'upload de la photo
          firebase_storage.TaskSnapshot snapshot = await uploadTask;

          if (snapshot.state == firebase_storage.TaskState.success) {
            // Récupérer l'URL de téléchargement de la photo depuis Firebase Storage
            String photoUrl = await storageRef.getDownloadURL();

            // Référence à la collection "reclamations" de l'utilisateur
            CollectionReference reclamationsCollection =
                FirebaseFirestore.instance.collection("users");

            // Ajouter une nouvelle réclamation dans la collection "reclamations"
            DocumentReference reclamationDocument = await reclamationsCollection
                .doc(uid)
                .collection("reclamations")
                .add({
              'titre': titre,
              'description': description,
              'date': date,
              'photoUrl': photoUrl,
              'latitude': latitude,
              'longitude': longitude,
              'address': address,
              'status': 'En attente',
            });

            String reclamationId = reclamationDocument.id;

            // Mettre à jour l'UID de la réclamation avec son ID
            await reclamationDocument.update({'uid': reclamationId});

            if (reclamationDocument.id.isNotEmpty) {
              // Réclamation enregistrée avec succès
              print('Réclamation enregistrée avec succès.');
            } else {
              // Échec de l'enregistrement de la réclamation
              print('Échec de l\'enregistrement de la réclamation.');
            }
          } else {
            // Échec du téléchargement de la photo
            print('Échec du téléchargement de la photo.');
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(22, 124, 172, 1),
        title: const Text('Formulaire de réclamation'),
      ),
      body: ReclamationForm(
        onSubmit: _submitReclamation,
      ),
    );
  }
}
