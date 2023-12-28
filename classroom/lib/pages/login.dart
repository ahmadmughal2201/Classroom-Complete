import 'package:classroom/main.dart';
import 'package:classroom/pages/home.dart';
import 'package:classroom/pages/register.dart';
import 'package:classroom/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      // Validation passed, proceed with registration
      String email = _emailController.text;
      String password = _passwordController.text;

      // Your backend registration endpoint URL
      var url = Uri.parse('http://localhost:3000/api/login');

      // JSON body containing registration data
      var body = jsonEncode({
        'email': email,
        'password': password,
      });

      // Send a POST request to the backend
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String userEmail = responseBody['email'];
        String userName = responseBody['name'];
        WidgetsFlutterBinding.ensureInitialized();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userEmail', userEmail);
        prefs.setString('userName', userName);

        if (prefs.containsKey('userEmail')) {
          // SnackBarUtils.showSnackBar(context, 'Login successful', Colors.green);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MyHomePage(), // Use an empty string if userEmail is null
            ),
          );
        } else {
          // SnackBarUtils.showSnackBar(
          //     context, 'Login failed : unable to save user email', Colors.red);
        }
      } else {
        // Registration failed, show error SnackBar with the message from the backend
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['message'];
        SnackBarUtils.showSnackBar(
            context, 'Login failed: $errorMessage', Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            // Blue background
            color: Colors.lightBlueAccent,
            width: double.infinity,
            height: double.infinity,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.9),
                  ],
                ),
              ),              height: 500,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Dance',
                            color: Colors.blueAccent),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                15.0), // Set the radius here
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              // Set your desired color for focused border
                              width: 2.0, // Set the border width
                            ),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null ||
                              !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                  .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                15.0), // Set the radius here
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              // Set your desired color for focused border
                              width: 2.0, // Set the border width
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 4) {
                            return 'Password must be at least 4 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _loginUser();
                        },
                        child: Container(
                            width: double.infinity,
                            height: 30, // Set width to infinity for full width
                            child: Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white),
                              ),
                            )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );
                        },
                        child: Text(
                          'Not a member? Register',
                          style: TextStyle(
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
