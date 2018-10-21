import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart';
import 'utils.dart';

void main() {
  runApp(new MaterialApp(
    home: new Splash(),
    title: "Angels",
  ));
}

class Splash extends StatefulWidget {
  @override
  State createState() => new SplashState();
}

class SplashState extends State<Splash> {
  var _timer;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GestureDetector(
        onTap: toMainScreen,
        child: Container(
          decoration: const BoxDecoration(
            image: const DecorationImage(
              fit: BoxFit.fill,
              image: const AssetImage("images/Logo.png"),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _timer = new Timer(const Duration(seconds: 5), toMainScreen);
  }

  void toMainScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyApp()));
  }
}
