/*
name: { type: String, required: true, trim: true },
  code: { type: String, required: true, unique: true, trim: true },
  description: { type: String, },
  teacher: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true, },
  students: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User', // Assuming you have a User model for students
    },
  ],
*/
import 'dart:math';

import 'package:classroom/components/bottomModal.dart';
import 'package:classroom/components/courseCard.dart';
import 'package:classroom/components/drawer.dart';
import 'package:classroom/utils/shared_prefrences_utils.dart';
import 'package:classroom/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, String>> courseImages = [
    {
      'backgroundImage': 'assets/images/cover1.jpg',
    },
    {
      'backgroundImage': 'assets/images/cover3.jpg',
    },
    {
      'backgroundImage': 'assets/images/cover4.jpg',
    },
    {
      'backgroundImage': 'assets/images/cover5.jpg',
    },
    {
      'backgroundImage': 'assets/images/cover6.jpg',
    },
    // Add more data as needed
  ];
  var loggedInuser;

List<Map<String, dynamic>> courseData = [];

  @override
  void initState() {
    super.initState();
    // Call the function to get classes when the widget is created
    getClasses();
  }

  Future<void> getClasses() async {
    try {
      var userEmail = await SharedPrefrencesUtils.getUserEmail();
      var userName = await SharedPrefrencesUtils.getUserName();

      loggedInuser=userName;
      print(userEmail);
      var url = Uri.parse('http://localhost:3000/class/getClasses/$userEmail');

      // Send a POST request to the backend
      var response =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          courseData = List<Map<String, dynamic>>.from(jsonData['data']);
        });
        print(courseData);
        SnackBarUtils.showSnackBar(context, 'Classes fetched', Colors.green);
      } else {
        // Handle other status codes
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['message'];
        SnackBarUtils.showSnackBar(
            context, 'Classes failed to load: $errorMessage', Colors.red);
      }
    } catch (error) {
      // Handle network or other errors
      print('Error fetching classes: $error');
      SnackBarUtils.showSnackBar(
          context, 'Classes failed to load: $error', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          title: Text('Classroom'),
          actions: const <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black12, // Set your desired background color

                radius: 20,
                child: Icon(
                  Icons.person,
                  color: Colors.grey,
                ),              ),
            ),
          ],
        ),
        drawer: MyDrawer(username: loggedInuser,),
        body: Center(
          child: courseData.isEmpty
              ? Text('No courses available.')
              : ListView.builder(
            itemCount: courseData.length,
            itemBuilder: (context, index) {

              // Get a random index to select a background image
              int randomImageIndex = Random().nextInt(courseImages.length);

              return CourseCard(
                backgroundImage: courseImages[randomImageIndex]['backgroundImage']!,
                courseTitle: courseData[index]['name']!,
                teacherName: courseData[index]['teacher']['username']!,
              );
            },
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Show the bottom sheet when the button is pressed
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return ClassOptionsBottomSheet();
              },
            );
          },
          tooltip: 'Add',
          backgroundColor: Colors.white,
          // Set background color to white
          foregroundColor: Colors.blue,
          // Set icon color to blue
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
