import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onSignOut;

  const HomePage({
    Key? key,
    required this.onSignOut,
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
      await FirebaseAuth.instance.signOut();
      onSignOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
