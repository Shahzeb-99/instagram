// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/components/all_Users.dart';
import 'package:instagram/components/login_screen.dart';
import 'package:instagram/components/upload_page.dart';
import 'package:animations/animations.dart';
import 'package:instagram/data/user_auth.dart';
import 'package:provider/provider.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);



  // ignore: use_key_in_widget_constructors

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final auth = FirebaseAuth.instance;
  final picker = ImagePicker();
  late File pickedImage;

  XFile? pickedFile;

  Future<void> _chooseImage() async {
    pickedFile = await picker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    pickedImage = File((pickedFile?.path)!);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UploadPicture(
                  pickedImage: pickedImage,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        alignment: Alignment.center,
        child: Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        OpenContainer(
          transitionType: ContainerTransitionType.fadeThrough,
          middleColor: Colors.grey.shade700,
          openColor: Colors.black,
          closedColor: Colors.transparent,
          openElevation: 10,
          closedElevation: 0,
          transitionDuration: const Duration(milliseconds: 500),
          closedBuilder: (BuildContext c, VoidCallback action) => Card(
            color: Colors.grey.shade700,
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
          openBuilder: (BuildContext c, VoidCallback action) =>
              AllUsers(currentusername: Provider.of<UserAuth>(context).username),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    _chooseImage();
                  },
                  icon: const Icon(Icons.camera_alt)),
              Container(
                height: 40.0,
              ),
              TextButton(
                onPressed: () {
                  auth.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (route) => false);
                },
                child: const Text('Sign Out'),
              )
            ],
          ),
        ),
      ],
        ),
      ),
    );
  }
}
