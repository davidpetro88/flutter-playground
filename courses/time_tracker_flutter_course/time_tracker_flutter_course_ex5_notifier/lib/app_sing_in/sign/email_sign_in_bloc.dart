import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker_flutter_course/app_sing_in/sign/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class EmailSignInBloc {
  final AuthBase auth;

  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  EmailSignInBloc({required this.auth});

  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  void toggleFormType() {
    final formType = _model.formType == EmailsignInFormType.signIn
        ? EmailsignInFormType.register
        : EmailsignInFormType.signIn;

    updateWith(
      email: '',
      password: '',
      isLoading: false,
      submitted: false,
      formType: formType,
    );
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String? email,
    String? password,
    EmailsignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    //update model
    _model = _model.copyWith(
        email: email,
        password: password,
        formType: formType,
        isLoading: isLoading,
        submitted: submitted);

    // add update model to _modelControler
    _modelController.add(_model);
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      // await Future.delayed(Duration(seconds: 3));
      if (_model.formType == EmailsignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }
}
