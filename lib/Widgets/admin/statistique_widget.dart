import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class StatistiqueWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // Variables to store the counts
        int nombreUtilisateurs = 0;
        int nombreReclamationsEnAttente = 0;
        int nombreReclamationsEnCours = 0;
        int nombreReclamationsTerminees = 0;

        // Function to fetch reclamations for each user
        List<Future<void>> fetchReclamations(List<DocumentSnapshot> users) {
          List<Future<void>> futures = [];

          for (var user in users) {
            String userId = user.id;
            Future<void> future = FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('reclamations')
                .get()
                .then((reclamationsSnapshot) {
              reclamationsSnapshot.docs.forEach((reclamation) {
                String status = reclamation['status'];

                // Increment the counts based on the status
                if (status == 'En attente') {
                  nombreReclamationsEnAttente++;
                } else if (status == 'En cours') {
                  nombreReclamationsEnCours++;
                } else if (status == 'Terminé') {
                  nombreReclamationsTerminees++;
                }
              });
              if (reclamationsSnapshot.docs.isNotEmpty) {
                nombreUtilisateurs++;
              }
            });

            futures.add(future);
          }

          return futures;
        }

        // List of colors for the pie chart
        final colorList = <Color>[
          const Color.fromARGB(255, 205, 31, 19),
          const Color.fromARGB(255, 255, 204, 17),
          const Color.fromARGB(255, 25, 158, 30),
        ];

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder<void>(
                  // Wait for the fetchReclamations function to complete
                  future: Future.wait(fetchReclamations(snapshot.data!.docs)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      return Column(
                        children: [
                          GridView.count(
                            crossAxisCount: 4,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              // Display stat cards for different counts
                              StatCard(
                                color: Colors.lightBlue,
                                count: nombreUtilisateurs,
                                title: 'Nombre d\'users ',
                              ),
                              StatCard(
                                title: 'En attente',
                                count: nombreReclamationsEnAttente,
                                color: const Color.fromARGB(255, 205, 31, 19),
                              ),
                              StatCard(
                                title: 'En cours',
                                count: nombreReclamationsEnCours,
                                color: const Color.fromARGB(255, 255, 204, 17),
                              ),
                              StatCard(
                                title: 'Terminé',
                                count: nombreReclamationsTerminees,
                                color: const Color.fromARGB(255, 25, 158, 30),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          PieChart(
                            dataMap: {
                              'En attente':
                                  nombreReclamationsEnAttente.toDouble(),
                              'En cours': nombreReclamationsEnCours.toDouble(),
                              'Terminé': nombreReclamationsTerminees.toDouble(),
                            },
                            chartType: ChartType.ring,
                            baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                            colorList: colorList,
                            chartValuesOptions: ChartValuesOptions(
                              showChartValuesInPercentage: true,
                            ),
                            totalValue:
                                (nombreReclamationsEnAttente.toDouble() +
                                    nombreReclamationsEnCours.toDouble() +
                                    nombreReclamationsTerminees.toDouble()),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const StatCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              count.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
