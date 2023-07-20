import 'package:flutter/material.dart';
import 'package:krishishop/components/my_button.dart';

class PhoneRegister extends StatelessWidget {
  const PhoneRegister({super.key});

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
                  'Welcome to our Community!',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                Text(
                  'Confirm your mobile number to get Started',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade600),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 50,
                            child: TextField(
                              controller: TextEditingController(text: '+91'),
                              decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: TextStyle(
                                  fontSize: 24, color: Colors.grey[600]),
                              keyboardType: TextInputType.number,
                            )),
                        SizedBox(width: 1),
                        Text(
                          '|',
                          style:
                              TextStyle(fontSize: 30, color: Colors.grey[600]),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller:
                                TextEditingController(text: '9327289321'),
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            style: TextStyle(
                                fontSize: 24, color: Colors.grey[600]),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                MyButton(onTap: () {}, title: 'Send Code'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
