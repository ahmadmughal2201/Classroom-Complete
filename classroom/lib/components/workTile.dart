import 'package:flutter/material.dart';

class WorkTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isNewAssignment;

  const WorkTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.isNewAssignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:10.0,right:10.0,bottom:10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(5.0),
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.assignment_outlined,
              color: Colors.white,
            ),
          ),
          title: Text(
            isNewAssignment ? 'New Assignment' : 'New Content',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
          trailing: Icon(Icons.more_vert),
          tileColor: Colors.white,
        ),
      ),
    );
  }
}
