import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String username,
    String password,
    String nom,
    String prenom,
    String telephone,
    bool isLogin,
    BuildContext ctx,
  ) submitAuthForm;
  final bool isLoading;

  AuthForm(this.submitAuthForm, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _isLoginAdmin = false;
  String _username = '';
  String _password = '';
  String _nom = '';
  String _prenom = '';
  String _telephone = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitAuthForm(
        _username.trim(),
        _password.trim(),
        _nom.trim(),
        _prenom.trim(),
        _telephone.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Affiche le texte "Login Admin" si _isLoginAdmin est vrai
                  if (_isLoginAdmin)
                    const Text(
                      'Login Admin',
                      style: TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 22, 124, 172),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  // Affiche le texte "Login User" si _isLoginAdmin est faux
                  if (!_isLoginAdmin)
                    Text(
                      _isLogin ? 'Login User' : 'Inscriptions',
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 22, 124, 172),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  // Affiche le champ de texte pour le nom d'utilisateur si _isLoginAdmin est vrai
                  if (_isLoginAdmin)
                    TextFormField(
                      key: ValueKey('username'),
                      decoration:
                          InputDecoration(labelText: 'Nom d\'utilisateur'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nom d\'utilisateur invalide';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                    ),
                  // Affiche le champ de texte pour le nom si _isLoginAdmin est faux et _isLogin est faux
                  if (!_isLoginAdmin)
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('nom'),
                        decoration: InputDecoration(labelText: 'Nom'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nom invalide';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _nom = value!;
                        },
                      ),
                  // Affiche le champ de texte pour le prénom si _isLoginAdmin est faux et _isLogin est faux
                  if (!_isLoginAdmin)
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('prenom'),
                        decoration: InputDecoration(labelText: 'Prénom'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Prénom invalide';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _prenom = value!;
                        },
                      ),
                  // Affiche le champ de texte pour le téléphone si _isLoginAdmin est faux et _isLogin est faux
                  if (!_isLoginAdmin)
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('telephone'),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(labelText: 'Téléphone'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Téléphone invalide';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _telephone = value!;
                        },
                      ),
                  // Affiche le champ de texte pour l'email
                  if (!_isLoginAdmin)
                    TextFormField(
                      key: ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Email invalide';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                    ),
                  // Affiche le champ de texte pour le mot de passe
                  TextFormField(
                    key: ValueKey('password'),
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Mot de passe'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return 'Mot de passe invalide (minimum 6 caractères)';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  SizedBox(height: 12),
                  // Affiche le widget CircularProgressIndicator si isLoading est vrai
                  if (widget.isLoading) CircularProgressIndicator(),
                  // Affiche le bouton "Se connecter" ou "S'inscrire" en fonction de _isLogin
                  if (!widget.isLoading)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 22, 124, 172), // Couleur de fond personnalisée
                      ),
                      child: Text(_isLogin ? 'Se connecter' : "S'inscrire"),
                      onPressed: _trySubmit,
                    ),
                  // Affiche le bouton "S'inscrire" ou "Se connecter" en fonction de _isLogin
                  if (!widget.isLoading)
                    if (!_isLoginAdmin)
                      TextButton(
                        child: Text(
                          _isLogin ? "S'inscrire" : 'Se connecter',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 22, 124, 172),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                      ),
                  // Affiche le bouton "Connexion utilisateur" ou "Connexion administrateur" en fonction de _isLoginAdmin
                  if (!widget.isLoading)
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 22, 124, 172), // Couleur de fond personnalisée
                      ),
                      child: Text(
                        _isLoginAdmin
                            ? 'Connexion utilisateur'
                            : 'Connexion administrateur',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isLoginAdmin = !_isLoginAdmin;
                        });
                      },
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
