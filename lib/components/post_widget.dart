// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instagram/components/comments.dart';
import '../data/user_auth.dart';
import 'profile_others.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Post extends StatefulWidget {
  Post(
      {Key? key,
      required this.numberofComments,
      required this.postLiked,
      required this.postID,
      this.postPicture,
      this.username,
      this.caption,
      required this.userProfilePicture,
      required this.numberOfLikes,
      this.myProfilePicture})
      : super(key: key);

  bool postLiked;

  final String? caption;
  final String userProfilePicture;
  final String? username;
  final String? postPicture;
  final String postID;
  int numberOfLikes;

  int numberofComments;
  final myProfilePicture;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  var orignalValue;

  //Transform controller value
  final cloud = FirebaseFirestore.instance;

  bool likeButtonActive = true;

  TransformationController tcontroller = TransformationController();

  Future<void> likeToggle() async {
    likeButtonActive = false;
    await cloud
        .collection('publicUsers')
        .doc(widget.username)
        .collection('posts')
        .doc(widget.postID)
        .collection('likes')
        .where('username', isEqualTo: Provider.of<UserAuth>(context).username)
        .get()
        .then(
      (value) {
        if (value.docs.isEmpty) {
          cloud
              .collection('publicUsers')
              .doc(widget.username)
              .collection('posts')
              .doc(widget.postID)
              .collection('likes')
              .doc()
              .set({'username': Provider.of<UserAuth>(context).username});
          cloud
              .collection('publicUsers')
              .doc(widget.username)
              .collection('posts')
              .doc(widget.postID)
              .update({'noOfLikes': FieldValue.increment(1)});
          widget.numberOfLikes++;
        } else {
          cloud
              .collection('publicUsers')
              .doc(widget.username)
              .collection('posts')
              .doc(widget.postID)
              .collection('likes')
              .doc(value.docs[0].id)
              .delete();

          cloud
              .collection('publicUsers')
              .doc(widget.username)
              .collection('posts')
              .doc(widget.postID)
              .update({'noOfLikes': FieldValue.increment(-1)});
          widget.numberOfLikes--;
        }
      },
    );
    likeButtonActive = true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePageOthers(
                      currentUsername: widget.username!,
                      currentUserProfilePicture:
                          "https://i1.sndcdn.com/artworks-000212816587-3pxa7y-t500x500.jpg"),
                ),
              );
            },
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    "https://i1.sndcdn.com/artworks-000212816587-3pxa7y-t500x500.jpg",
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(widget.username!)
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          InteractiveViewer(
            transformationController: tcontroller,
            onInteractionStart: (detail) {
              orignalValue = tcontroller.value;
            },
            onInteractionEnd: (detail) {
              tcontroller.value = orignalValue;
            },
            child: Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: CachedNetworkImage(
                imageUrl: widget.postPicture!,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () async {
                  if (likeButtonActive) {
                    setState(() {
                      widget.postLiked = !widget.postLiked;
                    });
                    await likeToggle();
                    setState(() {});
                  }
                },
                child: widget.postLiked
                    ? Container(
                        child: FaIcon(
                          FontAwesomeIcons.solidHeart,
                          color: Colors.red,
                        ),
                      )
                    : Container(
                        child: FaIcon(
                          FontAwesomeIcons.heart,
                        ),
                      ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                child: FaIcon(FontAwesomeIcons.comment),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.numberOfLikes} likes'),
                Text(widget.caption!),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Comments(
                                  postID: widget.postID,
                                  username: widget.username!,
                                  userProfilePicture: widget.userProfilePicture,
                                )));
                  },
                  child: Text(
                    'View all ${widget.numberofComments} comments',
                    style: TextStyle(color: Color(0xFF515357)),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        Provider.of<UserAuth>(context).profilepicture,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Add a comment...',
                      style: TextStyle(color: Color(0xFF515357)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//
// void likeToggle() async {
//   bool isLiked = false;
//   print(username);
//   print(postID);
//   print(loggedinUser);
//   var sda= await cloud
//       .collection('publicUsers')
//       .doc(username)
//       .collection('posts')
//       .doc(postID)
//       .collection('likes')
//       .where('username', isEqualTo: loggedinUser).get().then((value) {
//     if(value.docs[0].get('username')==loggedinUser){
//       cloud
//           .collection('publicUsers')
//           .doc(username)
//           .collection('posts')
//           .doc(postID)
//           .collection('likes').doc(value.docs[0].id).delete();
//
//       cloud
//           .collection('publicUsers')
//           .doc(username)
//           .collection('posts')
//           .doc(postID).update({'noOfLikes':FieldValue.increment(-1)});
//       isLiked=true;
//     }
//   },onError:(onError){
//     cloud
//         .collection('publicUsers')
//         .doc(username)
//         .collection('posts')
//         .doc(postID)
//         .collection('likes').doc().set({'username': loggedinUser});
//     cloud
//         .collection('publicUsers')
//         .doc(username)
//         .collection('posts')
//         .doc(postID).update({'noOfLikes':FieldValue.increment(1)});
//   } );
//   sda.
//
// }
