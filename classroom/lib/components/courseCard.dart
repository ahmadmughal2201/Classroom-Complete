import 'package:flutter/material.dart';
import 'package:classroom/pages/courseDetail.dart';

class CourseCard extends StatelessWidget {
  final String backgroundImage;
  final String courseTitle;
  final String teacherName;

  const CourseCard({
    Key? key,
    required this.backgroundImage,
    required this.courseTitle,
    required this.teacherName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsPage(
              courseName: courseTitle,
              teacherName: teacherName,
              backgroundImageUrl: backgroundImage,
            ),
          ),
        );
      },
      child: Hero(
        tag: backgroundImage,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    courseTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    teacherName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Teacher: $teacherName',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
