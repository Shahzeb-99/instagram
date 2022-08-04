import 'package:flutter/material.dart';
import 'package:instagram/components/login_screen.dart';
import 'package:instagram/components/registration_screen.dart';
import 'package:provider/provider.dart';
import 'components/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:instagram/components/listofpost.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final _auth=FirebaseAuth.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ListOfPost(),
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.black, selectedItemColor: Colors.white)),
        home:  _auth.currentUser==null?LoginScreen():HomeScreen(),
      ),
    );
  }
}
