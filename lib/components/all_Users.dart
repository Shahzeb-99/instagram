import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/components/profile_others.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key, this.currentusername}) : super(key: key);
  final currentusername;

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  final _fireStore = FirebaseFirestore.instance;
  List<SearchCards> list = [];

  Future<void> getData() async {
    await _fireStore.collection('publicUsers').get().then(
      (value) {
        for (var users in value.docs) {
          final String username = users.get('username');
          final String url = users.get('profilepicture');
          SearchCards userCard = SearchCards(
            username: username,
            url: url,
            currentusername: widget.currentusername,
          );
          list.add(userCard);
        }
      },
    );
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    Icon(Icons.search),
                    Text('Search'),
                  ],
                ),
              ),
            ),
            list.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return list[index];
                      },
                    ),
                  )
                : Expanded(child: Center(child: CircularProgressIndicator()))
          ],
        ),
      ),
    );
  }
}

class SearchCards extends StatelessWidget {
  SearchCards(
      {required this.username,
      required this.url,
      required this.currentusername});

  final String url;
  final String username;
  final String currentusername;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            ProfilePageOthers(currentUsername:username,
                currentUserProfilePicture: url)));
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          // height: MediaQuery.of(context).size.height * 0.1,
          // width: MediaQuery.of(context).size.width *0.5,
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: CachedNetworkImageProvider(url, scale: 1),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                username,
                style: TextStyle(fontSize: 17),
              )
            ],
          ),
        ),
      ),
    );
  }
}
