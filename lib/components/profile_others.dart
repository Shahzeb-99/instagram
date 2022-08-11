import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
  bool following = false;
  bool progressHUD = true;
  String currentUsername = '';
  bool isButtonActive = true;

  Future<void> toggleFollow(String currentProfileUsername) async {
    final cloud = FirebaseFirestore.instance;
    String documentid = '';

    if (following == true) {
      final follower = await cloud
          .collection('publicUsers')
          .doc(currentProfileUsername)
          .collection('followers')
          .where('username', isEqualTo: currentUsername)
          .get();
      documentid = follower.docs[0].id;
      cloud
          .collection('publicUsers')
          .doc(currentProfileUsername)
          .collection('followers')
          .doc(documentid)
          .delete();

      final following = await cloud
          .collection('publicUsers')
          .doc(currentUsername)
          .collection('following')
          .where('username', isEqualTo: currentProfileUsername)
          .get();
      documentid = following.docs[0].id;
      cloud
          .collection('publicUsers')
          .doc(currentUsername)
          .collection('following')
          .doc(documentid)
          .delete();
    } else {
      cloud
          .collection('publicUsers')
          .doc(currentProfileUsername)
          .collection('followers')
          .doc()
          .set({'username': currentUsername});
      cloud
          .collection('publicUsers')
          .doc(currentUsername)
          .collection('following')
          .doc()
          .set({'username': currentProfileUsername});
    }
  }

  void isFollowing(String currentProfileUsername) async {
    final auth = FirebaseAuth.instance;
    final cloud = FirebaseFirestore.instance;
    var currentUser = cloud
        .collection('publicUsers')
        .where('email', isEqualTo: auth.currentUser?.email)
        .get();
    await currentUser.then((value) {
      currentUsername = value.docs[0].get('username');
      cloud
          .collection('publicUsers')
          .doc(value.docs[0].get('username'))
          .collection('following')
          .where('username', isEqualTo: currentProfileUsername)
          .get()
          .then((value) {
        if (value.docs[0].get('username') == currentProfileUsername) {
          setState(() {
            following = true;
          });
        } else {
          following = false;
        }


      });

    });
    setState(() {
      progressHUD = false;
    });


  }

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
        }
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    isFollowing(widget.currentUsername);
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
        body: ModalProgressHUD(
          color: Colors.black,
          opacity: 1,
          progressIndicator: const CircularProgressIndicator(),
          inAsyncCall: progressHUD,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            following ? Colors.white10 : Colors.blueAccent)),
                    onPressed: () async {
                      if (isButtonActive == true) {
                        isButtonActive = false;
                        await toggleFollow(widget.currentUsername);
                        setState(() {
                          following = !following;
                        });
                        isButtonActive = true;
                      }
                    },
                    child: following
                        ? const Text('Following')
                        : const Text(
                            'Follow',
                          )),
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
                  child: GridView.builder(
                      itemCount: list.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 3,
                        crossAxisSpacing: 3,
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () {}, child: list[index]);
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
