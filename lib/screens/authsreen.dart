import 'package:flutter/material.dart';

import '../widgets/authwidget.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Image.network(
              //     'https://s.tmimgcdn.com/scr/1200x627/207600/family-online-shopping-free-vector-illustration-concept_207629-original.jpg'),
              const SizedBox(height: 150),
              Container(
                height: MediaQuery.of(context).size.height * .1,
                width: MediaQuery.of(context).size.width * .8,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    color: Colors.purple[400],
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: const Text(
                  'Shop Application',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: AuthWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
