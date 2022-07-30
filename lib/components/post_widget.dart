// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Post extends StatelessWidget {
  const Post({this.postPicture, this.username, this.caption, this.userProfilePicture, this.numberOfLikes, this.numberofComments, this.myProfilePicture});

  final String? caption;
  final String? userProfilePicture;
  final String? username;
  final String? postPicture;
  final numberOfLikes;
  final numberofComments;
  final myProfilePicture;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
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
              Text(username!)
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: CachedNetworkImage(imageUrl: postPicture!),
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                child: FaIcon(
                  FontAwesomeIcons.heart,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                child: FaIcon(FontAwesomeIcons.comment),
              )
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
                Text('347,402 likes'),
                Text(caption!),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'View all 1,259 comments',
                  style: TextStyle(color: Color(0xFF515357)),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/cover3.jpg'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Add a comment...',
                      style: TextStyle(color: Color(0xFF515357)),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
