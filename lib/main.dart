import 'package:demo/firebase_options.dart';
import 'package:demo/presentation/pages/bottom_nav_bar/bottom_nav.dart';
import 'package:demo/presentation/pages/login_page/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  print('working');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home:
          FirebaseAuth.instance.currentUser != null ? BottomNav() : LoginPage(),
    );
  }
}
