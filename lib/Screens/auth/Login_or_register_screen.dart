import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Widgets/auth/auth_widget.dart';
import '../../Widgets/users/app_drawer.dart';
import '../admin/home_screen.dart';

class LoginOrRegisterScreen extends StatefulWidget {
  static String screenRoute = 'LoginOrRegisterScreen';

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false, _isLoginAdmin = true;

  void _submitAuthForm(
    String username,
    String password,
    String nom,
    String prenom,
    String telephone,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userCredential;

    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        if (_isLoginAdmin) {
          // Vérifier si l'utilisateur est un administrateur
          CollectionReference adminCollection =
              FirebaseFirestore.instance.collection('Admin');
          QuerySnapshot querySnapshot = await adminCollection
              .where('username', isEqualTo: username)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            QueryDocumentSnapshot adminDoc = querySnapshot.docs.first;
            if (adminDoc['password'] == password) {
              // Connexion réussie en tant qu'administrateur
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => AdminHomeScreen()),
                (route) => false,
              );
            } else {
              // Mot de passe incorrect pour l'administrateur
              throw PlatformException(
                code: 'invalid-password',
                message: 'Mot de passe invalide',
              );
            }
          } else {
            // Connexion en tant qu'utilisateur normal
            userCredential = await _auth.signInWithEmailAndPassword(
              email: username,
              password: password,
            );
          }
        }
      } else {
        // Création d'un nouvel utilisateur
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: username,
          password: password,
        );

        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('users');
        DocumentReference userDocument =
            usersCollection.doc(userCredential.user?.uid);

        // Sauvegarde des informations de l'utilisateur dans la base de données
        await userDocument.set({
          'uid': userDocument.id,
          'nom': nom,
          'prenom': prenom,
          'telephone': telephone,
          'email': username,
          'password': password,
        });
      }
    } on PlatformException catch (err) {
      var message =
          'Une erreur s\'est produite, veuillez vérifier vos informations d\'identification !';

      if (err.message != null) {
        message = err.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err.toString());
      String errorMessage =
          'Une erreur s\'est produite, veuillez vérifier vos informations d\'identification !';

      if (err is FirebaseAuthException) {
        if (err.code == 'email-already-in-use') {
          errorMessage =
              'Cette adresse e-mail est déjà utilisée par un autre compte.';
        } else if (err.code == 'invalid-email') {
          errorMessage = 'Adresse e-mail invalide.';
        } else if (err.code == 'weak-password') {
          errorMessage = 'Le mot de passe est trop faible.';
        } else if (err.code == 'user-not-found') {
          errorMessage = 'Utilisateur non trouvé.';
        } else if (err.code == 'wrong-password') {
          errorMessage = 'Mot de passe incorrect.';
        } else {
          errorMessage = 'Une erreur s\'est produite lors de la connexion.';
        }
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 186, 216, 229),
      body: Center(
        child: AuthForm(
          _submitAuthForm,
          _isLoading,
        ),
      ),
    );
  }
}
