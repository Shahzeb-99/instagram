import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAuth extends ChangeNotifier {
  final user = FirebaseAuth.instance;
  final cloud = FirebaseFirestore.instance;

  String username = '';
  String profilepicture = '';

  String? get uid => user.currentUser?.uid;

  String? get email => user.currentUser?.email;

  String? get profilePicture => user.currentUser?.photoURL;

  Future<void> getUserdata() async {
    await cloud
        .collection("publicUsers2")
        .where("uid", isEqualTo: uid)
        .get()
        .then(
      (value) {
        if (value.docs.isNotEmpty) {
          username = value.docs[0].get('username');
          profilepicture = value.docs[0].get('profilepicture');
        }
      },
    );

    notifyListeners();
  }
}
