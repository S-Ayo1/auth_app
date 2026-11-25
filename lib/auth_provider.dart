import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
    User? user = FirebaseAuth.instance.currentUser;

  AuthProvider() {
    FirebaseAuth.instance.authStateChanges().listen((newUser) {
      user = newUser;
      notifyListeners();
    });
  }
}