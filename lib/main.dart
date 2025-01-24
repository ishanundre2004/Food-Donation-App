import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodon/profile_screen.dart';
// import 'package:foodon/login_screen.dart';
// import 'package:foodon/signup_screen.dart';
import 'package:foodon/wrapper.dart';
// import 'package:foodzy/auth/login_screen.dart';
// import 'package:foodzy/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodon',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const Wrapper(),
      routes: {
        '/profile': (context) => ProfilePage(),
        // other routes
      },
    );
  }
}
