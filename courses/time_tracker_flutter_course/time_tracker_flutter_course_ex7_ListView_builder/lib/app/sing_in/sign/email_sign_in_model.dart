import 'package:time_tracker_flutter_course/app/sing_in/sign/validators.dart';

enum EmailsignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  final String email;
  final String password;
  final EmailsignInFormType formType;
  final bool isLoading;
  final bool submitted;

  EmailSignInModel({
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

  String? get passwordErrorText  {
    bool showErrorText = submitted && !passwordValidator.isValid(email);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String? get emailErrorText  {
    bool showErrorText =  submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }


  EmailSignInModel copyWith({
    String? email,
    String? password,
    EmailsignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}
