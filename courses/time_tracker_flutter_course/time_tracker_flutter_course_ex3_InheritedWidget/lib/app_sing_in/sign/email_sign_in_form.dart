import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app_sing_in/sign/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/auth_provider.dart';

enum EmailsignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

  String? get _email => _emailController.text;

  String? get _password => _passwordController.text;
  EmailsignInFormType _formType = EmailsignInFormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });

    try {
      // await Future.delayed(Duration(seconds: 3));
      final auth = AuthProvider.of(context);
      if (_formType == EmailsignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (e) {
      debugPrint(e.toString());
      showAlertDialog(context,
          title: 'Sign in failed',
          content: e.toString(),
          defaultActionText: 'OK');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailsignInFormType.signIn
          ? EmailsignInFormType.register
          : EmailsignInFormType.signIn;

      _emailController.clear();
      _passwordController.clear();
    });
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailsignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final secondaryText = _formType == EmailsignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';

    // bool submitEnabled = _email!.isNotEmpty && _password!.isNotEmpty;
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    return [
      _buildEmailTextField(),
      SizedBox(
        height: 16.0,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 16.0,
      ),
      ElevatedButton(
        onPressed: submitEnabled ? _submit : null,
        child: Text(primaryText),
      ),
      SizedBox(
        height: 16.0,
      ),
      TextButton(
        onPressed: !_isLoading ? _toggleFormType : null,
        child: Text(secondaryText),
      )
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_email);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
          labelText: 'Passowrd',
          errorText: showErrorText ? widget.invalidPasswordErrorText : null),
      enabled: _isLoading == false,
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: (password) => _updateState(),
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: showErrorText ? widget.invalidEmailErrorText : null),
      enabled: _isLoading == false,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      onEditingComplete: _emailEditingComplete,
      // onChanged: (value) => print(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        // button large
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }

  void _updateState() {
    setState(() {});
  }
}
