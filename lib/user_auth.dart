import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAuth extends ChangeNotifier {
  final user = FirebaseAuth.instance;
  final cloud = FirebaseFirestore.instance;

  late String username;
  late String profilepicture;

  String? get uid => user.currentUser?.uid;

  String? get email => user.currentUser?.email;

  String? get profilePicture => user.currentUser?.photoURL;

  getUserdata() async {
    cloud.collection("publicUsers").where("email", isEqualTo: email).get().then(
      (value) {
        if (value.docs.isNotEmpty) {
          username = value.docs[0].get('email');
          profilepicture = value.docs[0].get('profilepicture');
        }
      },
    );
  }
}
