import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  
  User? _user;
  String? _userName;

  User? get user => _user;
  String? get userName => _userName;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        _fetchUserData(user.uid);
      }
      notifyListeners();
    });
  }

  Future<void> _fetchUserData(String uid) async {
    final snapshot = await _db.child('users/$uid').get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      _userName = data['name'];
      notifyListeners();
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> register(String username, String email, String password, String gender) async {
    try {
      // Check if username exists
      final userSnap = await _db.child('usernames/${username.toLowerCase()}').get();
      if (userSnap.exists) return "Username already taken";

      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      // Save User Data
      await _db.child('users/${cred.user!.uid}').set({
        'name': username,
        'email': email,
        'gender': gender,
        'isBanned': false,
        'joined': ServerValue.timestamp,
        'photoURL': 'https://api.dicebear.com/9.x/avataaars/svg?seed=$username',
      });
      await _db.child('usernames/${username.toLowerCase()}').set(cred.user!.uid);
      
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _userName = null;
    notifyListeners();
  }
}