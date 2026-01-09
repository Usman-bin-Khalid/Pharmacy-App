import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/admin/admin_login.dart';
import 'package:pharmacy_app/pages/bottom_nav.dart';
import 'package:pharmacy_app/pages/detail_page.dart';
import 'package:pharmacy_app/pages/home.dart';
import 'package:pharmacy_app/pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const Home(),
      home: Login(),
    );
  }
}
