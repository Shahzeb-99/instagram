import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/components/home_screen.dart';
import 'package:instagram/components/login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String email;
  late String password;
  late String username;
  late String fullname;
  final _auth = FirebaseAuth.instance;
  final _cloud = FirebaseFirestore.instance;
  late bool isFollowing;

  void getUsernames() async {await _cloud
        .collection('publicUsers')
        .where("username", isEqualTo: username)
        .get()
        .then(
      (value) {
         {
          _auth.createUserWithEmailAndPassword(
              email: email, password: password);
          final user = {
            "username": username,
            "fullname": fullname,
            "profilepicture":
                "https://media.istockphoto.com/vectors/default-profile-picture-avatar-photo-placeholder-vector-illustration-vector-id1223671392?k=20&m=1223671392&s=170667a&w=0&h=kEAA35Eaz8k8A3qAGkuY8OZxpfvn9653gDjQwDHZGPE=",
            "email": email,
          };
          _cloud.collection('publicUsers').doc(username).set(user);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.white30)),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/Instagram_logo.png',
                    scale: 15,
                  ),
                  const SizedBox(
                    width: 250,
                    child: Divider(
                      thickness: 1,
                      color: Colors.white30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextField(
                      onChanged: (newEmailEntry) {
                        email = newEmailEntry;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Email',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextField(
                      onChanged: (newFullnameEntry) {
                        fullname = newFullnameEntry;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Fullname',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: TextField(
                      onChanged: (newUsernameEntry) {
                        username = newUsernameEntry;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Username',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: TextField(
                      obscureText: true,
                      onChanged: (newPasswordEntry) {
                        password = newPasswordEntry;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Password',
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
                  ElevatedButton(
                    onPressed: () async {
                      getUsernames();

                      // await _auth.createUserWithEmailAndPassword(
                      //     email: email, password: password);
                      // await _cloud
                      //     .collection('publicUsers')
                      //     .doc('username')
                      //     .set({
                      //   '$username': {
                      //     'email': {email, fullname}
                      //   }
                      // });
                    },
                    style: ButtonStyle(
                      // backgroundColor: MaterialStateProperty.all<Color>(
                      //   Color(0xFF16A3AD),
                      // ),
                      elevation: MaterialStateProperty.all(5),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Sign up',
                      //style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Row(
                    children: [
                      const Text('Already have an account?'),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: const Text(
                          ' Sign in',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
