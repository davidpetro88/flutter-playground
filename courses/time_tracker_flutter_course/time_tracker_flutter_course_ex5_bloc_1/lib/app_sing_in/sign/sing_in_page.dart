
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app_sing_in/sign/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/app_sing_in/sign/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app_sing_in/sign/sing_in_bloc.dart';
import 'package:time_tracker_flutter_course/app_sing_in/sign/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInPage extends StatelessWidget {

  static Widget create(BuildContext context) {
    return Provider<SignInBloc>(
        create: (_) => SignInBloc(),
      child: SignInPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 16.0,
      ),
      body: StreamBuilder<bool>(
        stream: bloc.isLoadingStream,
        initialData: false,
        builder: (context, snapshot) {
          return _buildContainer(context, checkLoadginIsNull(snapshot.data));
        }
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContainer(BuildContext context, bool isLoading) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 64.0,
            child: _buildHeader(isLoading),
          ),
          SizedBox(
            height: 32.0,
          ),
          SocialSignInButton(
            text: 'Sign in with Google',
            logo: Image.asset('images/google-logo.png'),
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: isLoading ?  null : () => _signWithGoogle(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            text: 'Sign in with Facebook',
            logo: Image.asset('images/facebook-logo.png'),
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: isLoading ?  null : () => _signInWithFacebook(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Sign in with email',
            textColor: Colors.white,
            color: Colors.teal[700]!,
            onPressed: isLoading ?  null : () => _signInWithEmail(context),
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
            onPressed: isLoading ?  null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  bool checkLoadginIsNull(bool? data) => data == null ? false: data;

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign In',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }


  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Sign in failed',
      exception: exception,
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    try {
      bloc.setIsLoading(true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
      print(e.toString());
    } finally {
      bloc.setIsLoading(false);
    }
  }

  Future<void> _signWithGoogle(BuildContext context) async {
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    try {
      bloc.setIsLoading(true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
      print(e.toString());
    } finally {
      bloc.setIsLoading(false);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    final bloc = Provider.of<SignInBloc>(context, listen: false);
    try {
      bloc.setIsLoading(true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithFacebook();
    } on Exception catch (e) {
      _showSignInError(context, e);
      print(e.toString());
    } finally {
      bloc.setIsLoading(false);
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
}
