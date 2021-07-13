import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/app/sing_in/sign/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/app/sing_in/sign/validators.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  final AuthBase auth;
  String email;
  String password;
  EmailsignInFormType formType;
  bool isLoading;
  bool submitted;

  EmailSignInChangeModel({
    required this.auth,
    this.email = '',
    this.password = '',
    this.formType = EmailsignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  String get primaryButtonText {
    return formType == EmailsignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailsignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String? get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(email);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String? get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  void updateWith({
    String? email,
    String? password,
    EmailsignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  void toggleFormType() {
    final formType = this.formType == EmailsignInFormType.signIn
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

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      // await Future.delayed(Duration(seconds: 3));
      if (this.formType == EmailsignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(this.email, this.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            this.email, this.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

}
