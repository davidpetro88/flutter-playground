import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app_sing_in/sign/email_sign_in_form.dart';
import 'package:time_tracker_flutter_course/services/auth_provider.dart';

class EmailSignInPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        elevation: 8.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInForm(),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
