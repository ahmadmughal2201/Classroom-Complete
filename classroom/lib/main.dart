import 'package:classroom/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:classroom/components/courseCard.dart';
import 'package:classroom/components/drawer.dart';
import 'package:classroom/components/bottomModal.dart';
import 'package:classroom/pages/splash.dart';


void main() {
   
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classroom Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreenPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

