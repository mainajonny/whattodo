import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

import '../utils/controllers/auth_controller.dart';
import 'fire_store.dart';

var auth = Get.put(AuthController());

abstract class AuthenticationDatasource {
  Future<void> register(String email, String password, String passwordConfirm);
  Future<void> login(String email, String password);
  Future<void> logout();
}

class AuthenticationRemote extends AuthenticationDatasource {
  @override
  Future<void> login(String email, String password) async {
    auth.isLoading(true);
    auth.hasError(false);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } catch (e) {
      auth.hasError(true);
    } finally {
      auth.isLoading(false);
    }
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> register(
    String email,
    String password,
    String passwordConfirm,
  ) async {
    auth.regIsLoading(true);
    auth.regHasError(false);

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          )
          .then((value) {
            FirestoreDatasource().createUser(email);
          });
    } catch (e) {
      if (e.toString().contains('[firebase_auth/weak-password]')) {
        auth.regErrorMsg('Password should be at least 6 characters');
      } else {
        auth.regErrorMsg(e.toString());
      }
      auth.regHasError(true);
    } finally {
      auth.regIsLoading(false);
    }
  }
}

class GoogleSignInController extends GetxController {
  var userName = ''.obs;

  Future<UserCredential?> signInWithGoogle() async {
    GoogleSignInAccount? googleUser;
    GoogleSignInAuthentication? googleAuth;
    AuthCredential? authCredential;
    UserCredential? userCredential;

    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        forceCodeForRefreshToken: true,
        scopes: ['profile', 'email', 'openid'],
      );

      googleUser = await googleSignIn.signIn();

      googleAuth = await googleUser?.authentication;

      authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      userCredential = await FirebaseAuth.instance.signInWithCredential(
        authCredential,
      );
      userName(userCredential.user?.displayName);
    } on PlatformException catch (err) {
      String errMessage;

      if (err.code == 'sign_in_canceled') {
        errMessage = 'Authentication error\nUser cancelled authentication flow';
      } else if (err.code == 'network_error') {
        errMessage = 'Network error.\nPlease check your internet connection.';
      } else {
        errMessage = 'Something went wrong\n${err.code}';
      }
      debugPrint(errMessage.toString());
    } catch (err) {
      debugPrint(err.toString());
    }

    return userCredential;
  }
}
