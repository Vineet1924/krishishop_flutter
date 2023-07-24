import 'package:flutter/material.dart';
import 'package:krishishop/components/OTP_box.dart';
import 'package:krishishop/forgot_password.dart';
import 'package:pinput/pinput.dart';
import 'components/my_button.dart';

class PhoneVerification extends StatelessWidget {
  const PhoneVerification({super.key});

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
                  color: Colors.blue,
                ),
                const SizedBox(height: 50),
                Text(
                  'Thank you for registering with Us!',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                Text(
                  'Please enter the OTP',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(height: 50),
                Pinput(
                  length: 6,
                  showCursor: true,
                  defaultPinTheme: PinTheme(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade700))),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Resend OTP?',
                        style: TextStyle(color: Colors.grey[600], fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                MyButton(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()));
                    },
                    title: 'Verify'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
