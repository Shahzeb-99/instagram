// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, use_build_context_synchronously

import 'dart:core';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instagram/components/image_picker.dart';
import 'package:instagram/components/listofpost.dart';
import 'package:instagram/components/profile_page.dart';
import 'post_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Index of Page view
  PageController pageController = PageController(); // Pageview controller

  void _onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic);
  }

  bool postCheck =
      false; // Used to show Circle Progress Indicator while fetching posts
  late bool
      postLiked; // Check if post is liked or not, used in fill color of like icon
  final cloud = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  String currentUserProfilePicture = '';
  String currentUsername = '';
  late List<Post> listOfPost; // List of Post used in Listview Builder

  Future<void> updateNewsfeed() async {
    setState(() {
      postCheck = false;
    });
    await getPosts();
    setState(() {
      postCheck = true;
    });

    return Future.delayed(const Duration(seconds: 0));
  }

  Future<void> getPosts() async {
    listOfPost = []; // Reset on update
    final currentUser = auth.currentUser;
    await cloud
        .collection("publicUsers")
        .where("email", isEqualTo: "${currentUser?.email}")
        .get()
        .then(
      (value) {
        currentUsername = value.docs[0].get('username');
        currentUserProfilePicture = value.docs[0].get('profilepicture');
        print(currentUsername);
      },
    );
    Provider.of<ListOfPost>(context, listen: false).getPost(currentUsername); // Refresh ProfilePage Posts
    await cloud
        .collection("publicUsers")
        .doc(currentUsername)
        .collection("following")
        .get()
        .then(
      (value) async {
        for (var user in value.docs) {
          print(user.get('username'));
          await cloud
              .collection("publicUsers")
              .doc(user.get('username'))
              .collection("posts")
              .get()
              .then(
            (value) async {
              for (var posts in value.docs) {
                print(currentUsername);
                final postid = posts.id;

                await posts.reference
                    .collection('likes')
                    .where('username', isEqualTo: currentUsername)
                    .get()
                    .then((value) {
                  if (value.docs.isNotEmpty) {
                    postLiked = true;
                  } else {
                    postLiked = false;
                  }
                });
                final url = posts.get('url');
                print(url);
                final username = posts.get('username');
                print(username);
                final caption = posts.get('caption');
                print(caption);
                final timestamp = posts.get('timestamp');
                final noOfComments = posts.get('noOfComments');
                final noOfLikes = posts.get('noOfLikes');
                print(noOfLikes);
                final post = Post(
                  userProfilePicture: currentUserProfilePicture,
                  numberofComments: noOfComments,
                  postLiked: postLiked,
                  loggedinUser: currentUsername,
                  postID: postid,
                  numberOfLikes: noOfLikes,
                  postPicture: url,
                  username: username,
                  caption: caption,
                );

                setState(() {
                  listOfPost.add(post);
                });
              }
            },
          );
        }
      },
    );
  }

  @override
  void initState() {
    updateNewsfeed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        // selectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home_filled),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: Icon(Icons.add_box_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.portrait),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: PageView(
          onPageChanged: (value) {
            setState(
              () {
                _selectedIndex = value;
              },
            );
          },
          controller: pageController,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: Image.asset('assets/Instagram_logo.png'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: listOfPost.isNotEmpty // Check list of post
                      ? RefreshIndicator(
                          onRefresh: updateNewsfeed,
                          child: ListView.builder(
                            physics: const ScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            key: const PageStorageKey<String>(''),
                            itemCount: listOfPost.length,
                            itemBuilder: (BuildContext context, int index) {
                              return listOfPost[index];
                            },
                          ),
                        )
                      : postCheck == false // If List is empty and updateNewfeed() still running show CircleProgressIndicator else Text and Refresh Button
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('No Post'),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  OutlinedButton(
                                      style: ButtonStyle(
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  Colors.cyanAccent)),
                                      onPressed: () {
                                        Future.delayed(Duration(seconds: 1),
                                            () {
                                          updateNewsfeed();
                                        });
                                      },
                                      child: const Text('Tap to Refresh'))
                                ],
                              ),
                            ),
                ), // Post()
              ],
            ),
            UploadPage(
              currentUsername: currentUsername,
            ),
            ProfilePage(
              currentUsername: currentUsername,
              currentUserProfilePicture: currentUserProfilePicture,
            )
          ],
        ),
      ),
    );
  }
}
