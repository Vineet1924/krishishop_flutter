import 'package:flutter/material.dart';
import 'package:krishishop/components/my_dailogbox.dart';
import 'package:krishishop/components/my_textfield.dart';
import 'components/my_button.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 200),
                Icon(
                  Icons.lock,
                  size: 120,
                  color: Colors.black,
                ),
                const SizedBox(height: 50),
                Text(
                  'Reset your Password!',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                Text(
                  'Regain access to your Account',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(height: 50),
                MyTextField(
                  controller: TextEditingController(),
                  hintText: 'Email',
                  obscureText: false,
                  inputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 30),
                MyButton(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return DailogBox(
                              title: 'Success',
                              content: 'Password sent to your Email address!',
                              buttonText: 'Login',
                            );
                          });
                    },
                    title: 'Send'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
