import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInManager {
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  SignInManager({
    required this.isLoading,
    required this.auth,
  });

  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      isLoading.value = true;
      // _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      // _setIsLoading(false);
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
      isLoading.value = true;
      return await signInWithEmailAndPassword(email, password);
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
//stop in Adding the StreamBuilder code
