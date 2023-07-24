import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishishop/login_page.dart';

class DailogBox extends StatelessWidget {
  const DailogBox(
      {super.key,
      required this.title,
      required this.content,
      required this.buttonText});

  final String title;
  final String content;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close')),
        MaterialButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(buttonText)),
      ],
    );
  }
}
