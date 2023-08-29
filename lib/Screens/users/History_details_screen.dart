import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HistoryDetailsScreen extends StatefulWidget {
  static String screenRoute = 'HistoryDetailsScreen';
  Map<String, dynamic> data;
  HistoryDetailsScreen({super.key, required this.data});

  @override
  State<HistoryDetailsScreen> createState() => _HistoryDetailsScreenState();
}

class _HistoryDetailsScreenState extends State<HistoryDetailsScreen> {
  String? status;
  Color statusColor = Colors.red;

  @override
  void initState() {
    super.initState();
    // Récupérer le statut actuel de la réclamation
    status = widget.data['status'];

    if (status == 'En cours') {
      statusColor = Colors.amber;
    } else if (status == 'Terminé') {
      statusColor = Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    double latitude = widget.data['latitude'];
    double longitude = widget.data['longitude'];
    return Scaffold(
      appBar: AppBar(
        title: Text("Réclamation de " + widget.data['titre']),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 22, 124, 172),
      ),
      body: SizedBox(
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Affichage du problème
                    Text(
                      "Problème: ${widget.data['titre']}",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Affichage de la description
                    Text(
                      "Description: ${widget.data['description']}",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Affichage de la date
                    Text(
                      "Date: ${widget.data['date']}",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Affichage de l'image
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.transparent,
                      ),
                      width: 330,
                      height: 200,
                      child: Image(
                        image: NetworkImage(
                          widget.data['photoUrl'],
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Affichage des informations de localisation
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.transparent,
                      ),
                      width: 330,
                      height: 200,
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
                    Text(
                      "address: " + widget.data['address'],
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Affichage du statut actuel avec une couleur de fond correspondante
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
