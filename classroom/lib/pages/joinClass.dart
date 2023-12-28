import 'dart:convert';
import 'package:classroom/pages/courseDetail.dart';
import 'package:classroom/utils/shared_prefrences_utils.dart';
import 'package:classroom/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class JoinClassScreen extends StatelessWidget {
  JoinClassScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();

  Future<void> _joinClass(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String code = _codeController.text.toString();
      print(code);

      // Your backend join class endpoint URL
      var url = Uri.parse('http://localhost:3000/class/joinClass');

      var userEmail = await SharedPrefrencesUtils.getUserEmail();
      print(userEmail);

      var body = jsonEncode({
        'classCode': code,
        'userEmail': userEmail.toString(),
      });

      try {
        var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> responseBody = jsonDecode(response.body);
          print(responseBody);
          String successMessage = responseBody['message'];
          SnackBarUtils.showSnackBar(context, '$successMessage', Colors.green);

          // Navigate to the course details page upon successful enrollment
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailsPage(
                // Adjust properties accordingly
                courseName: responseBody['name'],
                teacherName: responseBody['teacher']['username'],
                backgroundImageUrl: 'assets/images/cover1.jpg',
              ),
            ),
          );
        } else {
          Map<String, dynamic> responseBody = jsonDecode(response.body);
          String errorMessage = responseBody['message'];
          SnackBarUtils.showSnackBar(
              context, 'Action failed: $errorMessage', Colors.red);
        }
      } catch (error) {
        print('Error joining class: $error');
        SnackBarUtils.showSnackBar(context, 'Error joining class', Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context); // Close the current screen
          },
        ),
        title: Text('Join Class'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage("assets/images/dp.png"),
                ),
                title: FutureBuilder<String>(
                  future: SharedPrefrencesUtils.getUserName(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!);
                    } else {
                      return Text('Loading...');
                    }
                  },
                ),
                subtitle: FutureBuilder<String>(
                  future: SharedPrefrencesUtils.getUserEmail(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!);
                    } else {
                      return Text('Loading...');
                    }
                  },
                ),
              ),
              Divider(),
              SizedBox(height: 10),
              Text(
                'Ask your teacher for the class code and enter it below.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Class Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a valid class code';
                  }
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    _joinClass(context);
                  },
                  child: Container(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Join Class',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),

                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
