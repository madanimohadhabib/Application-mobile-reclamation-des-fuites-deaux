import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DetailReclamationParUserScreen extends StatefulWidget {
  final DocumentSnapshot user;
  final DocumentSnapshot data;
  const DetailReclamationParUserScreen(
      {super.key, required this.data, required this.user});

  @override
  State<DetailReclamationParUserScreen> createState() =>
      _DetailReclamationParUserScreenState();
}

class _DetailReclamationParUserScreenState
    extends State<DetailReclamationParUserScreen> {
  String? status;
  Color statusColor = Colors.red;

  @override
  void initState() {
    super.initState();
    // Retrieve the current status of the claim
    status = widget.data['status'];

    if (status == 'En cours') {
      statusColor = Colors.amber;
    } else if (status == 'Terminé') {
      statusColor = Colors.green;
    }
  }

  void _updateStatus(String newStatus) {
    // Update the status of the claim in the database
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.user.id)
        .collection("reclamations")
        .doc(widget.data.id)
        .update({'status': newStatus}).then((_) {
      setState(() {
        status = newStatus;
        // Update the color based on the new status
        if (newStatus == 'En cours') {
          statusColor = Colors.amber;
        } else if (newStatus == 'Terminé') {
          statusColor = Colors.green;
        } else {
          statusColor = Colors.red;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Statut mis à jour avec succès"),
          backgroundColor: Color.fromARGB(255, 7, 157, 5),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur lors de la mise à jour du statut"),
          backgroundColor: Color.fromARGB(255, 205, 9, 9),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String nom = widget.user['nom'];
    String prenom = widget.user['prenom'];
    String email = widget.user['email'];
    String telephone = widget.user['telephone'];

    String titre = widget.data['titre'];
    String description = widget.data['description'];
    String date = widget.data['date'];
    String image = widget.data['photoUrl'];
    double latitude = widget.data['latitude'];
    double longitude = widget.data['longitude'];
    String address = widget.data['address'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails de la réclamation"),
        backgroundColor: Color.fromRGBO(22, 124, 172, 1),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Informations de l'utilisateur :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Nom : $nom",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Prénom : $prenom",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Adresse : $email",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Téléphone : $telephone",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const Center(
                    child: Text(
                      "Détails de la réclamation :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Titre : $titre",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Description : $description",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Date : $date",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.transparent,
                      ),
                      width: 300,
                      height: 250,
                      child: Image(
                        image: NetworkImage(
                          image,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.transparent,
                      ),
                      width: 300,
                      height: 250,
                      child: FlutterMap(
                        options: MapOptions(
                          center: LatLng(latitude, longitude),
                          zoom: 12,
                          minZoom: 12,
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
                              Marker(
                                width: 80.0,
                                height: 80.0,
                                point: LatLng(latitude, longitude),
                                builder: (ctx) => Container(
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 48,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      "Statut de la réclamation :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        "Status actuel: ",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          status!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Show a dialog box to allow the administrator to modify the status
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Modifier le statut"),
                              content: DropdownButtonFormField<String>(
                                value: status,
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: 'En attente',
                                    child: Text("En attente"),
                                  ),
                                  const DropdownMenuItem<String>(
                                    value: 'En cours',
                                    child: Text("En cours"),
                                  ),
                                  const DropdownMenuItem<String>(
                                    value: 'Terminé',
                                    child: Text("Terminé"),
                                  ),
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    status = newValue;
                                    // Update the color based on the newly selected status
                                    if (newValue == 'En cours') {
                                      statusColor = Colors.yellow;
                                    } else if (newValue == 'Terminé') {
                                      statusColor = Colors.green;
                                    } else {
                                      statusColor = Colors.red;
                                    }
                                  });
                                },
                              ),
                              actions: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Update the status
                                    _updateStatus(status!);
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.save),
                                  label: const Text("Enregistrer"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: const Text("Modifier le statut"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
