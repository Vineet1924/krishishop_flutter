import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:krishishop/components/my_button.dart';
import 'package:krishishop/components/my_snackbar.dart';
import 'package:krishishop/components/my_textfield.dart';
import 'package:krishishop/components/square_tile.dart';
import 'package:krishishop/dasboard.dart';
import 'package:krishishop/login_page.dart';
import 'firebase_services/firebase_auth_methods.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassword = TextEditingController();
  bool user = false;
  final bool isEditable = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  Future signUpUser() async {
    await EasyLoading.show(status: 'Creating your Account!');
    if (emailController.text.trim() == "") {
      showErrorSnackBar(context, 'Email is required!');
    } else if (passwordController.text.trim() == "") {
      showErrorSnackBar(context, 'Password is required!');
    } else if (confirmPassword.text.trim() == "") {
      showErrorSnackBar(context, 'Confirm Password is Empty!');
    } else if (passwordController.text.trim() != confirmPassword.text.trim()) {
      showErrorSnackBar(context, 'Password not Matched!');
    } else {
      await FirebaseAuthMethods(FirebaseAuth.instance).signUpWithEmail(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          context: context);
    }
    await EasyLoading.dismiss();
  }

  Future<void> signInWithGoogle() async {
    await FirebaseAuthMethods(FirebaseAuth.instance).signInWithGoogle(context);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Dashboard()));
    await EasyLoading.dismiss();
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
                  'Let\'s create your Account!',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(height: 30),
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                  inputType: TextInputType.emailAddress,
                  isEditable: isEditable,
                ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                  inputType: TextInputType.text,
                  isEditable: isEditable,
                ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: confirmPassword,
                  hintText: "Confirm Password",
                  obscureText: false,
                  inputType: TextInputType.text,
                  isEditable: isEditable,
                ),
                const SizedBox(height: 30),
                MyButton(
                  onTap: signUpUser,
                  title: 'Sign up',
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
                    GestureDetector(
                      child: SquareTile(
                        imagePath: 'assets/images/google.png',
                      ),
                      onTap: () {
                        signInWithGoogle();
                      },
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
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have and Account?',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
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
