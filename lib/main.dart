import 'package:flutter/material.dart';
import 'signup.dart';
import 'login.dart';
// import 'add_course.dart';
// import 'schedule_course.dart';
// import 'course_enrollment.dart';
// import 'exam_results.dart';
// import 'homepage.dart'; // Import the HomePage

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      initialRoute: '/', // Sets the initial route to LoginScreen
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        // '/homepage': (context) => HomePage(), // Add the HomePage route
        // '/add_course': (context) => AddCourseScreen(),
        //'/schedule_course': (context) => ScheduleCourseScreen(),
        //'/course_enrollment': (context) => CourseEnrollmentScreen(),
        // '/exam_results': (context) => ExamResultsScreen(),
      },
    );
  }
}
