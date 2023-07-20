import 'package:flutter/material.dart';
import 'package:krishishop/components/my_button.dart';
import 'package:krishishop/components/my_textfield.dart';
import 'package:krishishop/components/square_tile.dart';
import 'package:krishishop/login_page.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

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
                  controller: usernameController,
                  hintText: "Username",
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: passwordController,
                  hintText: "Confirm Password",
                  obscureText: false,
                ),
                const SizedBox(height: 30),
                MyButton(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
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
                    SquareTile(
                        imagePath: 'assets/images/google.png',
                        signInMethod: () {}),
                    SizedBox(
                      width: 25,
                    ),
                    SquareTile(
                        imagePath: 'assets/images/facebook.png',
                        signInMethod: () {}),
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
                    Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
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
