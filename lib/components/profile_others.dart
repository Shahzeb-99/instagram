import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'listofpost.dart';
import 'package:provider/provider.dart';

class ProfilePageOthers extends StatefulWidget {
  const ProfilePageOthers(
      {Key? key,
      required this.currentUsername,
      required this.currentUserProfilePicture})
      : super(key: key);

  final String currentUsername;
  final String currentUserProfilePicture;

  @override
  State<ProfilePageOthers> createState() => _ProfilePageOthersState();
}

class _ProfilePageOthersState extends State<ProfilePageOthers> {
  List<Container> list = [];

  void getPost(String currentUsername) {
    final cloud = FirebaseFirestore.instance;
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
          final post = Container(
              child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.fill,
          ));
          list.add(post);
          if (kDebugMode) {
            print(list.length);
          }
        }
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    getPost(widget.currentUsername);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.currentUsername),
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: CachedNetworkImageProvider(
                      widget.currentUserProfilePicture,
                    ),
                  ),
                  Text(
                    '${list.length}\n Posts',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const Text(
                    '1\n Followers',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                  const Text(
                    '1\n Following',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.white, width: 2))),
              child: const Icon(Icons.grid_on_sharp),
            ),
            Expanded(
              child: Consumer(
                builder: (BuildContext context, profilePosts, Widget? child) {
                  return GridView.builder(
                      itemCount: list.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(onTap:(){},child: list[index]);
                      });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}



class LocalPosts extends ChangeNotifier {
  final cloud = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  List<Container> localList = [];

  void getPost(String currentUsername) {
    if (kDebugMode) {
      print(currentUsername);
    }
    localList = [];
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
          final post = Container(
              child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.fill,
          ));
          localList.add(post);
          if (kDebugMode) {
            print(localList.length);
          }
          notifyListeners();
        }
      },
    );
    notifyListeners();
  }
}
