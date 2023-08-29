import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  List<Marker> markers = [];
  double currentZoom = 13.0;

  Future<List<DocumentSnapshot>> getReclamations() async {
    // Récupérer une référence à la collection "users"
    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');

    // Créer une liste pour stocker toutes les réclamations
    List<DocumentSnapshot> allReclamations = [];

    // Parcourir tous les utilisateurs
    final QuerySnapshot usersSnapshot = await usersRef.get();
    for (final userDoc in usersSnapshot.docs) {
      // Récupérer une référence à la sous-collection "reclamations" de l'utilisateur
      final CollectionReference reclamationsRef =
          userDoc.reference.collection('reclamations');

      // Récupérer les réclamations de l'utilisateur
      final QuerySnapshot reclamationsSnapshot = await reclamationsRef.get();
      allReclamations.addAll(reclamationsSnapshot.docs);
    }

    // Retourner la liste de toutes les réclamations
    return allReclamations;
  }

  void showReclamationDetails(DocumentSnapshot reclamation) async {
    // Récupérer une référence à l'utilisateur de la réclamation
    DocumentReference userRef =
        reclamation.reference.parent.parent as DocumentReference<Object?>;

    // Récupérer les données de l'utilisateur
    DocumentSnapshot userSnapshot = await userRef.get();

    // Récupérer le nom de l'utilisateur
    String nom = userSnapshot['nom'];
    String prenom = userSnapshot['prenom'];

    // Afficher les détails de la réclamation avec le nom de l'utilisateur
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Détails de la réclamation'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Utilisateur: $nom $prenom'),
              Text('Titre: ${reclamation['titre']}'),
              Text('Date: ${reclamation['date']}'),
              Text('Address: ${reclamation['address']}'),
              Text('Status: ${reclamation['status']}'),
              // Ajoutez ici d'autres informations spécifiques à la réclamation
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  void zoomIn() {
    setState(() {
      currentZoom++;
    });
  }

  void zoomOut() {
    setState(() {
      currentZoom--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: getReclamations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Afficher un indicateur de chargement si les données sont en cours de récupération
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Afficher un message d'erreur si une erreur s'est produite lors de la récupération des données
            return Center(child: Text('Une erreur s\'est produite'));
          }

          // Les données ont été récupérées avec succès
          final reclamations = snapshot.data;

          return Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  center: LatLng(35.9311500, 0.0891800),
                  zoom: currentZoom,
                  minZoom: 10,
                  maxZoom: 17,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      for (int i = 0; i < markers.length; i++) markers[i],
                      for (final reclamation in reclamations!)
                        Marker(
                          width: 100.0,
                          height: 100.0,
                          point: LatLng(reclamation['latitude'],
                              reclamation['longitude']),
                          builder: (ctx) => GestureDetector(
                            onTap: () {
                              showReclamationDetails(reclamation);
                            },
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 48.0,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 16.0,
                right: 16.0,
                child: Column(
                  children: [
                    FloatingActionButton(
                      backgroundColor: const Color.fromRGBO(22, 124, 172, 1),
                      onPressed: zoomIn,
                      child: const Icon(Icons.add),
                    ),
                    SizedBox(height: 16.0),
                    FloatingActionButton(
                      backgroundColor: const Color.fromRGBO(22, 124, 172, 1),
                      onPressed: zoomOut,
                      child: const Icon(Icons.remove),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
