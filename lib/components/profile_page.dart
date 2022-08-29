import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/listofpost.dart';
import 'package:provider/provider.dart';

import '../data/user_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15),
          child: Row(
            children: [
              Text(
                Provider.of<UserAuth>(context).username,
                style: const TextStyle(fontSize: 25),
              ),
              Expanded(
                child: Container(),
              ),
              const Icon(Icons.add_box_outlined)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: CachedNetworkImageProvider(
                  Provider.of<UserAuth>(context).profilepicture,
                ),
              ),
              Text(
                '${Provider.of<ListOfPost>(context).list.length}\n Posts',
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
              border:
                  Border(bottom: BorderSide(color: Colors.white, width: 2))),
          child: const Icon(Icons.grid_on_sharp),
        ),
        Expanded(
          child: Consumer(
            builder: (BuildContext context, profilePosts, Widget? child) {
              return GridView.builder(
                  controller: ScrollController(initialScrollOffset: 5),
                  itemCount: Provider.of<ListOfPost>(context).list.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Provider.of<ListOfPost>(context).list[index];
                  });
            },
          ),
        )
      ],
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
