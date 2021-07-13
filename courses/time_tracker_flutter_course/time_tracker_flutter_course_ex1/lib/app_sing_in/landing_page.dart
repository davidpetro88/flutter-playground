import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app_sing_in/home_page.dart';
import 'package:time_tracker_flutter_course/app_sing_in/sign/app_sing_in.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _updateUser(FirebaseAuth.instance.currentUser);
  }

  void _updateUser(User? user) {
    if(user != null) {
      print('User id: ${user.uid}');
      setState(() {
        _user = user;
      });
    }
  }

  void _signOut() {
    setState(() {
      _user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        onSignIn: _updateUser,
      );
    }
    return HomePage(onSignOut: _signOut);
  }
}
