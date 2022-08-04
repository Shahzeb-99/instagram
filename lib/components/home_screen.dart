// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:core';
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
  int _selectedIndex = 0;
  PageController pageController = PageController();

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

  final cloud = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  String currentUserProfilePicture = '';
  String currentUsername = '';
  late List<Post> listOfPost;

  Future<void> updateNewsfeed() async {
    await getPosts();
    setState(() {});
    return Future.delayed(const Duration(seconds: 0));
  }

  Future<void> getPosts() async {
    listOfPost = [];
    final currentUser =  auth.currentUser;
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
    Provider.of<ListOfPost>(context,listen: false).getPost(currentUsername);
    await cloud
        .collection("publicUsers")
        .doc(currentUsername)
        .collection("following")
        .get()
        .then(
      (value) {
        for (var user in value.docs) {
          print(user.get('username'));
          cloud
              .collection("publicUsers")
              .doc(user.get('username'))
              .collection("posts")
              .get()
              .then(
            (value) {
              for (var posts in value.docs) {
                final url = posts.get('url');
                print(url);
                final username = posts.get('username');
                print(username);
                final caption = posts.get('caption');
                print(caption);
                final timestamp = posts.get('timestamp');
                print(timestamp);
                final noOfLikes = posts.get('noOfLikes');
                print(noOfLikes);
                final post = Post(
                  numberOfLikes: noOfLikes,
                  postPicture: url,
                  username: username,
                  caption: caption,
                );
                listOfPost.add(post);
                setState(() {});
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
            RefreshIndicator(
              onRefresh: updateNewsfeed,
              child: Container(
                child: Column(
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
                      child: listOfPost.isNotEmpty
                          ? ListView.builder(
                              key: const PageStorageKey<String>('2'),
                              itemCount: listOfPost.length,
                              itemBuilder: (BuildContext context, int index) {
                                return listOfPost[index];
                              },
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                    ), // Post()
                  ],
                ),
              ),
            ),
            UploadPage(currentUsername: currentUsername,),
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
