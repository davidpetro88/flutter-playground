import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app_sing_in/sign/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app_sing_in/sign/social_sign_in_button.dart';

class SignInPage extends StatelessWidget {

  final void Function(User) onSignIn;

  const SignInPage({Key? key, required this.onSignIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        // leading: Text('lending'),
        // actions: [Text('lending')],
        elevation: 16.0,
      ),
      body: _buildContainer(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContainer() {
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
            onPressed: _signInWithGoogle,
          ),
          SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            text: 'Sign in with Facebook',
            logo: Image.asset('images/facebook-logo.png'),
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: _signInWithGoogle,
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Sign in with email',
            textColor: Colors.white,
            color: Colors.teal[700]!,
            onPressed: _signInWithGoogle,
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
            onPressed: _signInAnonymously,
          ),
          // Text(
          //   'Login',
          //   style: TextStyle(fontSize: 16.0, color: Colors.purple),
          // ),
        ],
      ),
    );
  }

  Future<void> _signInAnonymously() async {
    try {
      // throw Exception('Failled to authentication!!');
      final userCredentials = await FirebaseAuth.instance.signInAnonymously();
      onSignIn(userCredentials.user!);
    } catch(e) {
      print(e.toString());
    }
  }

  void _signInWithGoogle() {
    print('click');
  }
}
