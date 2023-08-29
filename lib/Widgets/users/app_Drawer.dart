import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
     
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('MoBشكوى',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 245, 246, 247),
            ),
            
            ),
            backgroundColor:Color.fromARGB(255, 22, 124, 172) ,
            centerTitle: true,
            automaticallyImplyLeading: false,
            
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text(' La langue'),
            onTap: () {
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('À propos de nous'),
            onTap: () {
          showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("À propos de nous"),
                  content: const Text("Une application mobile permettant aux utilisateurs de signaler les fuites d'eau"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        color: Color.fromARGB(255, 22, 124, 172) ,
                        padding: const EdgeInsets.all(14),
                        child: const Text(
                          "close",
                        style: TextStyle(
              
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 245, 246, 247),
            ),),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.contact_mail),
            title: Text('Contacter nous'),
            onTap: () {
          showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Contacter nous"),
                  content: Center(
                    child: Column(
                      children: <Widget>[
                         Text(
                    'ALGERIENNE DES EAUX',
                    style: TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 31, 110, 189)),
                  ),
                  Text(
                    'الجزائرية للمياه',
                    style: TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 31, 110, 189)),
                  ),
                  Divider(),
                   Text(
                    'Adresse:Réservor Sidi Benhaoua',
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  Divider(),
                   Text('Site web: www.ade.dz',
                    style: TextStyle(fontSize: 15),
                   ),
                   Divider(),
                   Text(
                      'Facebook: ADE Mostaganem ',
                    style: TextStyle(fontSize: 15),
                   ),
                  Divider(),
                   Text(
                      'Email: contact@ade.dz ',
                    style: TextStyle(fontSize: 15),
                   ),
                   Divider(),
                  Text(
                      'Tél : 045333234 / 045333457 ',
                    style: TextStyle(fontSize: 15),
                   ),
                   Divider(),
                  Text(
                    'Fax: 045333464',
                    style: TextStyle(fontSize: 15),
                  ),
                  Divider(),
                  Text(
                    'Numéro vert: 1593',
                    style: TextStyle(fontSize: 15),
                  ),
                  
            
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        color: Color.fromARGB(255, 22, 124, 172) ,
                        padding: const EdgeInsets.all(14),
                        child: const Text(
                          "close",
                        style: TextStyle(
              
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 245, 246, 247),
            ),),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
