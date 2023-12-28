import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart'; // Import your login screen file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreenPage(),
    );
  }
}

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();

    // Add a delay using Future.delayed
    Future.delayed(Duration(seconds: 7), () {
      // Navigate to the login screen after the delay
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set your desired background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash.gif',
              width: 600.0, // Adjust the width as needed
              height: 300.0, // Adjust the height as needed
            ),
            Text(
              'Classrooms',
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                fontFamily: 'Dance',
               color: Colors.blueAccent
              ),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(  valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent), // Set your desired color
            ), // Add a loading indicator if needed
          ],
        ),
      ),
    );
  }
}
