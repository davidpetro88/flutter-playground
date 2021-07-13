import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class HomePage extends StatelessWidget {
  final AuthBase auth;
  final VoidCallback onSignOut;

  const HomePage({
    Key? key,
    required this.onSignOut,
    required this.auth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Home Page'),
        actions: [
          TextButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: _signOut,
          )
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      await auth.signOut();
      onSignOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
