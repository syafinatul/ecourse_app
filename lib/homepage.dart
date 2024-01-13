import 'package:ecourse_app/add_course.dart';
import 'package:ecourse_app/course_enrollment.dart';
import 'package:ecourse_app/exam_results.dart';
import 'package:ecourse_app/schedule_course.dart';
import 'package:ecourse_app/user.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Course App Home'),
        backgroundColor: Colors.blue[900],
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // Logout icon
            onPressed: () {
              // Navigate to the login screen
              Navigator.pushNamed(context, '/');
            },
          )
        ],
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[400]!, Colors.blue[900]!],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Add your content here
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushNamed(context, '/homepage');
              },
            ),
            IconButton(
              icon: Icon(Icons.event),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ScheduleCourseScreen(user: user),
                ));
                print('jadi jadi');
              },
            ),
            IconButton(
              icon: Icon(Icons.add_box_rounded),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddCourseScreen(user: user),
                ));
              },
            ),
            IconButton(
              icon: Icon(Icons.assignment_turned_in),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ExamResultScreen(user: user),
                ));
              },
            ),
            IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CourseEnrollmentScreen(user: user),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
