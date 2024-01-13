import 'dart:convert';
import 'package:ecourse_app/add_course.dart';
import 'package:ecourse_app/homepage.dart';
import 'package:ecourse_app/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

const String firebaseUrl =
    'e-course-ebe3d-default-rtdb.asia-southeast1.firebasedatabase.app';

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List<User> _userList = [];

  void _login2() async {
    print('login button tapped');
    final url = Uri.https(
      'e-course-ebe3d-default-rtdb.asia-southeast1.firebasedatabase.app',
      'users.json',
    );
    final response = await http.get(url);
    print('#debug login.dart');
    print(response.body);
    final Map<String, dynamic> listData = json.decode(response.body);
    print('#debug Login.dart');
    print(listData);
    final List<User> _loadedData = [];
    for (final data in listData.entries) {
      _loadedData.add(
        User(
          userId: data.key,
          username: data.value['username'],
          password: data.value['password'],
        ),
      );
    }

    setState(() {
      _userList = _loadedData;
      print('user list: ${_userList.length}');
    });

    // Get the entered username and password from the controllers
    String enteredUsername = _usernameController.text;
    String enteredPassword = _passwordController.text;

    // Check if the entered username and password match any user's data in _userList
    User? matchedUser = _userList.firstWhereOrNull((user) =>
        user.username == enteredUsername && user.password == enteredPassword);

    if (matchedUser != null) {
      // Navigate to the homepage or perform other actions like storing user session
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomePage(user: matchedUser),
      ));

      // Clear the text fields after successful login
      _usernameController.clear();
      _passwordController.clear();
    } else {
      // Show an error message if no matching user is found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid credentials. Please try again.'),
        ),
      );
    }
  }

  // void _login() async {
  //   final url = Uri.https(firebaseUrl, 'users.json');
  //   List<User> users = [];

  //   try {
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic>? usersJson = json.decode(response.body);
  //       final List<User> _loadedData = [];
  //       for (final data in usersJson.entries) {
  //         _loadedData.add(User(userId: data.key, username: data.value['username'], password: data.value['username']))
  //       }
  //       // usersJson?.forEach((key, value) {
  //       //   users.add(User(
  //       //     userId: ,
  //       //     username: value['username'],
  //       //     password: value['password'],
  //       //   ));
  //       // });

  //       var user = users.firstWhere(
  //         (user) => user.username == _usernameController.text,
  //         orElse: () => User(userId: '', username: '', password: ''),
  //       );

  //       if (user.username == _usernameController &&
  //           user.password == _passwordController.text) {
  //         Navigator.pushNamed(context, '/homepage');
  //         _usernameController.clear();
  //         _passwordController.clear();
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('Invalid credentials. Please try again.'),
  //           ),
  //         );
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Error: ${response.body}'),
  //         ),
  //       );
  //     }
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error: $error'),
  //       ),
  //     );
  //   }
  // }

  void _navigateToSignUp() {
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Student Login'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.school,
                size: 100.0,
                color: Colors.blueAccent,
              ),
              SizedBox(height: 30.0),
              TextFormField(
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _login2,
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: _navigateToSignUp,
                    child: Text('Sign Up'),
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
