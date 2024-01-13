import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecourse_app/user.dart';

class ExamResultScreen extends StatefulWidget {
  final User user;

  const ExamResultScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ExamResultScreenState createState() => _ExamResultScreenState();
}

class _ExamResultScreenState extends State<ExamResultScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _subject;
  late double _marks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Subject'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter subject';
                  }
                  return null;
                },
                onSaved: (value) => _subject = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Marks'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter marks';
                  }
                  return null;
                },
                onSaved: (value) => _marks = double.parse(value!),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _saveResult,
                child: Text('Save Result'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveResult() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final Map<String, dynamic> resultData = {
        'subject': _subject,
        'marks': _marks,
      };

      final url = Uri.https(
        'e-course-ebe3d-default-rtdb.asia-southeast1.firebasedatabase.app',
        'students/${widget.user.userId}/examResults.json',
      );

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(resultData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Result saved successfully!')),
          );
          _formKey.currentState!.reset();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Failed to save result. Status Code: ${response.statusCode}'),
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

  // Implement methods to edit and delete exam results as required
  // For example, you can use HTTP PUT and DELETE requests to update and delete exam results
}
