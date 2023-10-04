import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class ReclamationForm extends StatefulWidget {
  final Function onSubmit;

  ReclamationForm({required this.onSubmit});

  @override
  _ReclamationFormState createState() => _ReclamationFormState();
}

class _ReclamationFormState extends State<ReclamationForm> {
  final _formKey = GlobalKey<FormState>();
  String titre = '';
  String description = '';
  String date = '';
  File? photo;
  double selectedLatitude = 0.0;
  double selectedLongitude = 0.0;
  String selectedAddress = '';

  Future<void> _pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(source: source);

    if (pickedImage != null) {
      setState(() {
        photo = File(pickedImage.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(titre, description, date, photo, selectedLatitude,
          selectedLongitude, selectedAddress);

      // Réinitialiser le formulaire après l'enregistrement de la réclamation
      _formKey.currentState!.reset();
      titre = '';
      description = '';
      date = '';
      selectedLatitude = 0.0;
      selectedLongitude = 0.0;
      selectedAddress = '';

      // Afficher une notification ou une confirmation à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Réclamation soumise avec succès.'),
        backgroundColor: Color.fromARGB(255, 6, 129, 10),
      ));
    }
  }

  void _onLocationPicked(
    LatLong latLong,
  ) {
    setState(() {
      selectedLatitude = latLong.latitude;
      selectedLongitude = latLong.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TextFormField for the title
                TextFormField(
                  decoration: InputDecoration(labelText: 'Titre'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer un titre.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      titre = value;
                    });
                  },
                ),
                // TextFormField for the description
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer une description.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                ),
                // DateTimePicker for selecting the date
                DateTimePicker(
                  initialValue: '',
                  firstDate: DateTime(2018),
                  lastDate: DateTime(2100),
                  dateLabelText: 'Date',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer à la date de réclamation';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      date = value;
                    });
                  },
                ),
                // Row containing buttons to pick image from gallery or camera
                Row(
                  children: [
                    Flexible(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(22, 124, 172, 1),
                        ),
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: Icon(Icons.photo_library),
                        label: Text('Ajouter depuis la galerie'),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(22, 124, 172, 1),
                        ),
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: Icon(Icons.camera),
                        label: Text('Prendre une photo'),
                      ),
                    ),
                  ],
                ),
                // Container to display the selected photo
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(22, 124, 172, 1),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.transparent,
                  ),
                  child: photo != null ? Image.file(photo!) : Container(),
                ),
                SizedBox(height: 5),
                // Container for OpenStreetMapSearchAndPick widget
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(22, 124, 172, 1),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.transparent,
                  ),
                  width: 380,
                  height: 348,
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(35.9311500, 0.0891800),
                      zoom: 13.0,
                      minZoom: 10,
                      maxZoom: 17,
                      onTap: (tapPosition, point) => _onLocationPicked(
                          LatLong(point.latitude, point.longitude)),
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
                            width: 100.0,
                            height: 100.0,
                            point: LatLng(selectedLatitude, selectedLongitude),
                            builder: (ctx) => Container(
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
                ),
                SizedBox(height: 10.0),
                // Submit button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(22, 124, 172, 1),
                  ),
                  onPressed: _submitForm,
                  icon: Icon(Icons.send),
                  label: Text('Soumettre'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
