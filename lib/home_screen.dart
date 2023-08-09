import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'firebase_auth_methods.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  Future signOut() async {
    await EasyLoading.show(status: 'Loging out...');
    await FirebaseAuthMethods(FirebaseAuth.instance).logOut(context: context);
    await EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Krishishop",
            style: TextStyle(color: Colors.white),
          )),
      body: Center(
          child: SafeArea(
              child: ElevatedButton(
        onPressed: signOut,
        child: Text("Logout"),
      ))),
    );
  }
}
