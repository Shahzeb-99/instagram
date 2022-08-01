import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'listofpost.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {Key? key,
      required this.currentUsername,
      required this.currentUserProfilePicture})
      : super(key: key);

  final String currentUsername;
  final String currentUserProfilePicture;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.currentUsername,
                style: const TextStyle(fontSize: 25),
              ),
              Expanded(
                child: Container(),
              ),
              const Icon(Icons.add_box_outlined)
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: CachedNetworkImageProvider(
                    widget.currentUserProfilePicture,
                  ),
                ),
                const Text(
                  '1\n Posts',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
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
          const Icon(Icons.grid_on_sharp),
          Expanded(
            child: Consumer(
              builder:  (BuildContext context, profilePosts, Widget? child){return GridView.builder(
                  itemCount: Provider.of<ListOfPost>(context).list.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Provider.of<ListOfPost>(context).list[index];
                  });},

            ),
          )
        ],
      ),
    );
  }
}

// GridView.builder(
// itemCount: Provider.of<ListOfPost>(context).list.length,
// gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// crossAxisCount: 3,
// ),
// itemBuilder: (BuildContext context, int index) {
// return Provider.of<ListOfPost>(context).list[index];
// })
