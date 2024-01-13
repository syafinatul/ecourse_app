import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecourse_app/user.dart';

class AddCourseScreen extends StatefulWidget {
  final User user;

  const AddCourseScreen({Key? key, required this.user}) : super(key: key);

  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _course;
  late String _subject;
  late String _date;
  late String _day;
  late String _lecturer;
  late String _place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Course'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter course';
                  }
                  return null;
                },
                onSaved: (value) => _course = value!,
              ),
              // Add other TextFormFields for subject, date, day, lecturer, and place here
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _addCourse();
                  }
                },
                child: Text('Add Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addCourse() async {
    final Map<String, dynamic> courseData = {
      'course': _course,
      'subject': _subject,
      'date': _date,
      'day': _day,
      'lecturer': _lecturer,
      'place': _place,
    };

    final url = Uri.https(
      'e-course-ebe3d-default-rtdb.asia-southeast1.firebasedatabase.app',
      'students/${widget.user.userId}/courses.json',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(courseData),
      );

      if (response.statusCode == 200) {
        print('Response Body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course added successfully!')),
        );

        _formKey.currentState!.reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to add course. Status Code: ${response.statusCode}'),
          ),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }
}
