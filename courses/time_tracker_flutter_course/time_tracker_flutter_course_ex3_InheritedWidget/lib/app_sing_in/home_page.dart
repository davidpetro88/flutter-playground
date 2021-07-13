import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth_provider.dart';

class HomePage extends StatelessWidget {

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
            onPressed: () => _confirmSignOut(context),
          )
        ],
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Ok',
    );
    if(didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = AuthProvider.of(context);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
