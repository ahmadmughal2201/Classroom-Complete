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
import 'package:clipboard/clipboard.dart';
import 'package:classroom/utils/shared_prefrences_utils.dart';
import 'package:flutter/material.dart';
import 'package:classroom/pages/courseDetail.dart';
import 'package:classroom/utils/snackbar_utils.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class CreateClassScreen extends StatefulWidget {
  const CreateClassScreen({Key? key}) : super(key: key);

  _CreateClassScreenState createState() => _CreateClassScreenState();
}

class _CreateClassScreenState extends State<CreateClassScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  Future<void> _createClass() async {
    if (_formKey.currentState!.validate()) {
      // Validation passed, proceed with registration
      String name = _nameController.text.toString();
      String code = _codeController.text.toString();

      print(name);
      print(code);

      // Your backend registration endpoint URL
      var url = Uri.parse('http://localhost:3000/class/createClass');

      // JSON body containing registration data
      var userEmail = await SharedPrefrencesUtils.getUserEmail();
      print(userEmail); // Adjust property name accordingly
      var userName = await SharedPrefrencesUtils.getUserName();
      print(userName); // Adjust property name accordingly

      var body = jsonEncode({
        'name': name,
        'code': code,
        'teacherEmail': userEmail.toString(),
      });

      // Send a POST request to the backend
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['message'];
        SnackBarUtils.showSnackBar(context, '$errorMessage', Colors.green);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsPage(
              courseName: _nameController.text,
              teacherName: userName,
              backgroundImageUrl: 'assets/images/cover1.jpg',
            ),
          ),
        );
      } else {
        // Registration failed, show error SnackBar with the message from the backend
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['message'];
        SnackBarUtils.showSnackBar(
            context, 'Action failed: $errorMessage', Colors.red);
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
        title: Text('Create Class'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Subject Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a valid subject name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: AbsorbPointer(
                      absorbing: true,
                      child: TextFormField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          labelText: 'Generated Code',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Add code generation logic here
                      String generatedCode = generateCode();
                      _codeController.text = generatedCode;
                      print(generatedCode);

                      // Copy to clipboard
                      Clipboard.setData(ClipboardData(text: generatedCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Code copied to clipboard'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Text('Generate Code'),
                  ),
                ],
              ),
              SizedBox(height: 40),
              ElevatedButton(
                  onPressed: () {
                    _createClass();
                    // Navigate to courseDetail screen with subject name as an argument
                  },
                  child: Container(
                    width: double.infinity,
                    height: 20, // Set width to infinity for full width
                    child: Center(
                      child: Text(
                        'Create Class',
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

  String generateCode() {
    const String characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();

    // Generate a random 6-character code
    String code = '';
    for (int i = 0; i < 6; i++) {
      int randomIndex = random.nextInt(characters.length);
      code += characters[randomIndex];
    }

    return code;
  }
}
