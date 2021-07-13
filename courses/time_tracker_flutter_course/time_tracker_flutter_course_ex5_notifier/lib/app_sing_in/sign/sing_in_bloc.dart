import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInBloc {
  final AuthBase auth;
  final StreamController<bool> _isLoadingController = StreamController<bool>();

  SignInBloc({required this.auth});

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }

  Future<User?> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);

  Future<User?> signWithGoogle() async => await _signIn(auth.signWithGoogle);

  Future<User?> signInWithFacebook() async =>
      await _signIn(auth.signInWithFacebook);

  Future<User?> signInWithEmailAndPassword(
      String? email, String? password) async {
    try {
      _setIsLoading(true);
      return await signInWithEmailAndPassword(email, password);
    } catch (e) {
      rethrow;
    } finally {
      _setIsLoading(false);
    }
  }
}
//stop in Adding the StreamBuilder code
