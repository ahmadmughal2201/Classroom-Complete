import 'package:flutter/material.dart';
import 'package:classroom/pages/joinClass.dart';
import 'package:classroom/pages/createClass.dart';

class ClassOptionsBottomSheet extends StatelessWidget {
  const ClassOptionsBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Join Class'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet

                // Add your logic for joining a class
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JoinClassScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Create Class'),
              onTap: () {
                // Add your logic for creating a class
                Navigator.pop(context);
                // Close the bottom sheet

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateClassScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
