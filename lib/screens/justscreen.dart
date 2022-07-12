import 'package:flutter/material.dart';

class JustScreen extends StatelessWidget {
  const JustScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
        'WAITING...',
        style: TextStyle(fontSize: 30),
      )),
    );
  }
}
