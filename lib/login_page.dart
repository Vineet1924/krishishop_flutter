import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:krishishop/components/my_button.dart';
import 'package:krishishop/components/my_textfield.dart';
import 'package:krishishop/components/square_tile.dart';
import 'package:krishishop/firebase_auth_methods.dart';
import 'package:krishishop/forgot_password.dart';
import 'package:krishishop/phone_register.dart';
import 'package:krishishop/signup_page.dart';

import 'components/my_snackbar.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signInUser() async {
    await EasyLoading.show(status: 'Loging in...');
    if (emailController.text.trim() == "") {
      showErrorSnackBar(context, 'Email is required!');
    } else if (passwordController.text.trim() == "") {
      showErrorSnackBar(context, 'Password is required!');
    } else {
      FirebaseAuthMethods(FirebaseAuth.instance).signInWithEmail(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Icon(
                  Icons.lock,
                  size: 120,
                  color: Colors.black,
                ),
                const SizedBox(height: 50),
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(height: 30),
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                  inputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                  inputType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Text(
                          'Forgot Password!',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                MyButton(
                  onTap: signInUser,
                  title: 'Sign in',
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.8,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Or Continue with',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.8,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      imagePath: 'assets/images/google.png',
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    SquareTile(
                      imagePath: 'assets/images/facebook.png',
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    GestureDetector(
                      child: SquareTile(
                        imagePath: 'assets/images/phone.png',
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhoneRegister()));
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a Member?',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      child: Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
