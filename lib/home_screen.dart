import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
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
          child: Text("Home Screen"),
        ));
  }
}
