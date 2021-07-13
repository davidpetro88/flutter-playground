import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app_sing_in/sign/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/app_sing_in/sign/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app_sing_in/sign/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/auth_provider.dart';

class SignInPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 16.0,
      ),
      body: _buildContainer(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContainer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 32.0,
          ),
          SocialSignInButton(
            text: 'Sign in with Google',
            logo: Image.asset('images/google-logo.png'),
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: () => _signWithGoogle(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            text: 'Sign in with Facebook',
            logo: Image.asset('images/facebook-logo.png'),
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: () => _signInWithFacebook(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Sign in with email',
            textColor: Colors.white,
            color: Colors.teal[700]!,
            onPressed: () => _signInWithEmail(context),
          ),
          // CustomElevatedButton(),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'or',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Go anonymous',
            textColor: Colors.black,
            color: Colors.lime[700]!,
            onPressed: () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      final auth = AuthProvider.of(context);
      await auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signWithGoogle(BuildContext context) async {
    try {
      final auth = AuthProvider.of(context);
      await auth.signWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      final auth = AuthProvider.of(context);
      await auth.signInWithFacebook();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithEmail(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => EmailSignInPage(),
      ),
    );
  }

  void _signInWithGoogle() {
    print('click');
  }
}
