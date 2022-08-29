import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/data/user_auth.dart';
import 'package:provider/provider.dart';

class Comments extends StatefulWidget {
  Comments(
      {Key? key,
      required this.userProfilePicture,
      required this.username,
      required this.postID})
      : super(key: key);

  final String username;
  final String postID;
  final String userProfilePicture;
  final TextEditingController postcontroller = TextEditingController();

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
        title: const Text('Comments'),
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
                : const Expanded(
                    child: Center(child: CircularProgressIndicator())),
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
                          username: Provider.of<UserAuth>(context).username,
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
                          'username': Provider.of<UserAuth>(context).username,
                          'comment': comment,
                          'profilepicture':
                              Provider.of<UserAuth>(context).profilepicture
                        });
                        _fireStore
                            .collection('publicUsers')
                            .doc(widget.username)
                            .collection('posts')
                            .doc(widget.postID)
                            .update({'noOfComments': FieldValue.increment(1)});
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
  const CommentsCards(
      {Key? key,
      required this.url,
      required this.username,
      required this.comment})
      : super(key: key);

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
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: RichText(
                softWrap: true,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: username,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
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
