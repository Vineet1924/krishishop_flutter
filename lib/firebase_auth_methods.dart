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
        await Timer(Duration(seconds: 5), () {
          showDialog(
              context: context,
              builder: (context) {
                return Center(child: CircularProgressIndicator());
              });
        });

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
}
