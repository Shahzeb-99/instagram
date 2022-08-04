import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadPicture extends StatefulWidget {
  final File pickedImage;
  final String  currentUsername;

  UploadPicture({required this.pickedImage,required this.currentUsername});

  @override
  State<UploadPicture> createState() => _UploadPictureState();
}

class _UploadPictureState extends State<UploadPicture> {

  String caption='';
  final storage = FirebaseStorage.instance;
  final cloud = FirebaseFirestore.instance;


  uploadData(String caption) async {
    String fileName = widget.pickedImage.path.split('/').last;
    final storageRef = storage.ref( ).child('posts/${fileName}');
    print(fileName);
    print(widget.currentUsername);
await storageRef.putFile(widget.pickedImage);


    // Waits till the file is uploaded then stores the download url
    String url = await storageRef.getDownloadURL();
    print(url);
    final post = {
      "username": widget.currentUsername,
      "url": url,
      "timestamp": Timestamp.now(),
      "caption" : caption,
      "noOfLikes" : 0
    };
    await cloud.collection('publicUsers').doc(widget.currentUsername).collection('posts').doc().set(post);
    Navigator.pop(context);



//     String fileName = widget.pickedImage.path.split('/').last;
// await storage.ref('posts/${fileName}').getDownloadURL();
// print(storage.ref('posts/${fileName}').getDownloadURL());
// Navigator.pop(context);



  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,title: Text('Post'),),
      body: Column(
        children: [
          Flexible(
            child: Image.file(widget.pickedImage),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (newCaption) {caption=newCaption;},
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Add a Caption',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide:
                            const BorderSide(color: Colors.white30, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide:
                            const BorderSide(color: Colors.white30, width: 1),
                      ),
                    ),
                  ),
                ),
                IconButton(onPressed: () {uploadData(caption);}, icon: const Icon(Icons.arrow_forward))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
