import 'dart:convert';
import 'package:ecourse_app/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CourseEnrollmentScreen extends StatefulWidget {
  final User user;

  const CourseEnrollmentScreen({super.key, required this.user});
  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<CourseEnrollmentScreen> {
  String? _selectedCourse;
  String? _selectedSubject;
  String? _selectedDate;
  String? _selectedDay;
  String? _selectedLecturer;
  String? _selectedPlace;

  List<String> courses = ['Course A', 'Course B', 'Course C'];
  List<String> subjects = ['Subject 1', 'Subject 2', 'Subject 3'];

  Map<String, String> subjectToLecturer = {
    'Subject 1': 'Lecturer X',
    'Subject 2': 'Lecturer Y',
    'Subject 3': 'Lecturer Z',
  };

  Map<String, Map<String, String>> subjectDetails = {
    'Subject 1': {
      'Time': '10:00 AM',
      'Day': 'Monday',
      'Place': 'Room 101',
    },
    'Subject 2': {
      'Time': '2:00 PM',
      'Day': 'Wednesday',
      'Place': 'Room 102',
    },
    'Subject 3': {
      'Time': '4:00 PM',
      'Day': 'Friday',
      'Place': 'Room 103',
    },
  };

  void _addCourse() async {
    if (_selectedCourse != null && _selectedSubject != null) {
      final Map<String, dynamic> courseData = {
        'course': _selectedCourse,
        'subject': _selectedSubject,
        'time': _selectedDate,
        'day': _selectedDay,
        'lecturer': _selectedLecturer,
        'place': _selectedPlace,
      };

      final url = Uri.https(
        'e-course-ebe3d-default-rtdb.asia-southeast1.firebasedatabase.app',
        'users/${widget.user.userId}/addCourse.json', // Updated URL endpoint
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

          setState(() {
            _selectedCourse = null;
            _selectedSubject = null;
            _selectedDate = null;
            _selectedDay = null;
            _selectedLecturer = null;
            _selectedPlace = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Failed to add course. Status Code: ${response.statusCode}'),
            ),
          );
        }
      } catch (error) {
        print('Error: $error'); // Add this line to print the error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both course and subject!')),
      );
    }
  }

  void _showSubjectDetailsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Subject Details'),
          content: Table(
            border: TableBorder.all(),
            children: [
              TableRow(children: [
                TableCell(child: Text('Time')),
                TableCell(child: Text(_selectedDate ?? 'N/A')),
              ]),
              TableRow(children: [
                TableCell(child: Text('Day')),
                TableCell(child: Text(_selectedDay ?? 'N/A')),
              ]),
              TableRow(children: [
                TableCell(child: Text('Lecturer')),
                TableCell(
                    child: Text(subjectToLecturer[_selectedSubject!] ?? 'N/A')),
              ]),
              TableRow(children: [
                TableCell(child: Text('Place')),
                TableCell(
                    child: Text(
                        subjectDetails[_selectedSubject!]!['Place'] ?? 'N/A')),
              ]),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Enrolment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCourse,
                hint: Text('Select Course'),
                items: courses.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCourse = newValue;
                    _selectedSubject = null;
                  });
                },
              ),
              SizedBox(height: 16.0),
              if (_selectedCourse != null)
                DropdownButtonFormField<String>(
                  value: _selectedSubject,
                  hint: Text('Select Subject'),
                  items: subjects.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedSubject = newValue;
                      _selectedDate = subjectDetails[newValue!]!['Time'];
                      _selectedDay = subjectDetails[newValue!]!['Day'];
                    });
                    _showSubjectDetailsDialog();
                  },
                ),
              SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed:
                        _addCourse, // Directly call the _addCourse method
                    child: Text('Add Course'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
