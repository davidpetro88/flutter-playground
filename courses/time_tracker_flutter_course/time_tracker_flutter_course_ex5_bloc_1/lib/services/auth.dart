import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  Stream<User?> get authStateChanges;

  User? get currentUser;

  Future<User?> signInAnonymously();

  Future<User?> signInWithEmailAndPassword(String? email, String? password);

  Future<User?> signWithGoogle();

  Future<User?> signInWithFacebook();

  Future<User?> createUserWithEmailAndPassword(String? email, String? password);

  Future<void> signOut();
}

class Auth extends AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  @override
  Future<User?> signInWithEmailAndPassword(
      String? email, String? password) async {
    if( email != null && password != null) {
      assert(email.length > 6, 'email need be greater than 6');
      assert(password.length >= 6, 'password need be greater than 6');
      final userCredential = await _firebaseAuth.signInWithCredential(
          EmailAuthProvider.credential(email: email, password: password));
      return userCredential.user;
    }
    throw Exception("Email and password is required!");
  }

  @override
  Future<User?> signWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      print('test ---> $googleAuth');
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    }
    throw FirebaseAuthException(
      code: 'ERROR_ABORTED_BY_USER',
      message: 'Sign in aborted by user',
    );
  }

  @override
  Future<User?> signInWithFacebook() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        print('test ---> $accessToken');
        if (accessToken != null) {
          final userCredential = await _firebaseAuth.signInWithCredential(
            FacebookAuthProvider.credential(accessToken.token),
          );
          return userCredential.user;
        }
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: response.error?.developerMessage,
        );
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<User?> createUserWithEmailAndPassword(
      String? email, String? password) async {
    if( email != null && password != null) {
      assert(email.length > 6, 'email need be greater than 6');
      assert(password.length >= 6, 'password need be greater than 6');
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    }
    throw Exception("Email and password is required!");
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();

    await _firebaseAuth.signOut();
  }
}
