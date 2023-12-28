import 'package:classroom/main.dart';
import 'package:classroom/pages/home.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final String username;

  MyDrawer({required this.username});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/cover2.jpg'),
              ),
            ),
            child: Text(
              username,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text('Classrooms'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MyHomePage(), // Use an empty string if userEmail is null
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications_none_outlined),
            title: Text('Notifications'),
            onTap: () {
              // Add your custom action here
            },
          ),
        ],
      ),
    );
  }
}
