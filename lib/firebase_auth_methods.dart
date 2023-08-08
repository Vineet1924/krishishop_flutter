import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:krishishop/components/my_snackbar.dart';
import 'package:krishishop/login_page.dart';
import 'dasboard.dart';

class FirebaseAuthMethods {
  final FirebaseAuth auth;

  FirebaseAuthMethods(this.auth);

  Future<void> signUpWithEmail(
      {required email,
      required String password,
      required BuildContext context}) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await EasyLoading.showSuccess('Account Created!');
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      });
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          showErrorSnackBar(context, 'Invalid email format!');
          break;
        case 'weak-password':
          showErrorSnackBar(context, 'Select strong Password!');
          break;
        case 'email-already-in-use':
          showErrorSnackBar(context, 'email is already registerd!');
          break;
      }
    }
  }

  Future<void> signInWithEmail(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await EasyLoading.dismiss();
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          showErrorSnackBar(context, 'Password may be Incorrect!');
          break;
        case 'user-not-found':
          showErrorSnackBar(context, 'Email may be Incorrect!');
          break;
        case 'too-many-requests':
          showErrorSnackBar(
              context, 'Too many Wrong attempts! Try again latter');
          break;
        case 'invalid-email':
          showErrorSnackBar(context, 'Invalid email format!');
          break;
      }
    }
  }

signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
  
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  Future<void> logOut({required BuildContext context}) async {
    try {
      auth.signOut().then((value) async {
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar(context, e.code);
    }
  }
}
