import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListOfPost extends ChangeNotifier {
  final cloud = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  List<Container> list = [];

  void getPost(String currentUsername) {
    if (kDebugMode) {
      print(currentUsername);
    }
    list = [];
    cloud
        .collection("publicUsers")
        .doc(currentUsername)
        .collection("posts")
        .get()
        .then(
      (value) {
        for (var posts in value.docs) {
          final url = posts.get('url');
          if (kDebugMode) {
            print(url);
          }
          final post = Container(child:CachedNetworkImage(imageUrl: url,fit: BoxFit.fill,));
          list.add(post);
          print(list.length);
          notifyListeners();
        }
      },
    );
    notifyListeners();
  }
}
