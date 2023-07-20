import 'package:flutter/material.dart';

class OtpField extends StatelessWidget {
  const OtpField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black)),
        width: 55,
        child: TextField(
          textAlign: TextAlign.center,
          controller: TextEditingController(text: '1'),
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          style: TextStyle(fontSize: 20, color: Colors.grey[600]),
          keyboardType: TextInputType.number,
        ));
  }
}
