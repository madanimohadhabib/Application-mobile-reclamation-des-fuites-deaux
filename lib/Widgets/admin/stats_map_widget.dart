import 'package:flutter/material.dart';

import './map_widget.dart';
import './statistique_widget.dart';

class StatsMapWidget extends StatelessWidget {
  const StatsMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(22, 124, 172, 1),
          title: const Text('Statistiques'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Statistique',
                icon: Icon(Icons.insert_chart),
              ),
              Tab(
                text: 'Map',
                icon: Icon(Icons.map),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StatistiqueWidget(), // Statistique
            MapWidget(), // Map Tab
          ],
        ),
      ),
    );
  }
}
