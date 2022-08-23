import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/components/profile_others.dart';

class Comments extends StatefulWidget {
  Comments(
      {required this.loggedInUser,
      required this.userProfilePicture,
      required this.username,
      required this.postID});

  final String loggedInUser;
  final String username;
  final String postID;
  final String userProfilePicture;
  TextEditingController postcontroller = TextEditingController();

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final _fireStore = FirebaseFirestore.instance;
  List<CommentsCards> list = [];
  String comment = '';

  Future<void> getComments() async {
    await _fireStore
        .collection('publicUsers')
        .doc(widget.username)
        .collection('posts')
        .doc(widget.postID)
        .collection('comments')
        .get()
        .then(
      (value) {
        for (var users in value.docs) {
          final String comment = users.get('comment');
          final String username = users.get('username');
          final String url = users.get('profilepicture');
          CommentsCards userCard = CommentsCards(
            username: username,
            url: url,
            comment: comment,
          );
          list.add(userCard);
        }
      },
    );
    setState(() {});
  }

  @override
  void initState() {
    getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            list.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return list[index];
                      },
                    ),
                  )
                : Expanded(child: Center(child: CircularProgressIndicator())),
            Container(
              color: Colors.white12,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: TextField(
                        controller: widget.postcontroller,
                    onChanged: (newComment) {
                      comment = newComment;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Add a Comment',
                    ),
                  )),
                  TextButton(
                      onPressed: () {

                        CommentsCards userCard = CommentsCards(
                          username: widget.loggedInUser,
                          url: widget.userProfilePicture,
                          comment: comment,
                        );
                        list.add(userCard);


                        _fireStore
                            .collection('publicUsers')
                            .doc(widget.username)
                            .collection('posts')
                            .doc(widget.postID)
                            .collection('comments')
                            .doc()
                            .set({
                          'username': widget.loggedInUser,
                          'comment': comment,
                          'profilepicture': widget.userProfilePicture
                        });
                        _fireStore
                            .collection('publicUsers')
                            .doc(widget.username)
                            .collection('posts')
                            .doc(widget.postID)
                            .update({'noOfComments':FieldValue.increment(1)});
                        setState(() {
                          widget.postcontroller.clear();
                        });

                      },
                      child: const Text('Post'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CommentsCards extends StatelessWidget {
  CommentsCards(
      {required this.username, required this.url, required this.comment});

  final String url;
  final String username;
  final String comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        // height: MediaQuery.of(context).size.height * 0.1,
        // width: MediaQuery.of(context).size.width *0.5,
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(url, scale: 1),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: RichText(
                softWrap: true,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: username,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: '    $comment')
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
