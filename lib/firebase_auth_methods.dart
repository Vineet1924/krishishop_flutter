import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:krishishop/components/my_snackbar.dart';

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
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      });
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
}
