import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:krishishop/dasboard.dart';
import 'package:krishishop/login_page.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices services = SplashServices();

  @override
  void initState() {
    super.initState();
    services.getCurrentUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animation/farmer.json',
                height: 200.0,
                repeat: true,
                reverse: true,
                animate: true,
              ),
            ],
          ),
        ));
  }
}

class SplashServices {
  void getCurrentUser(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      Timer(Duration(seconds: 5), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      });
    } else {
      Timer(Duration(seconds: 5), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    }
  }
}
