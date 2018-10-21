import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'utils.dart';
import 'const.dart';

class GIdol extends StatefulWidget {
  final Band currentBand;
  final bool random;

  GIdol({Key key, @required this.currentBand, @required this.random})
      : super(key: key);

  @override
  State createState() =>
      new GIdolState(currentBand: currentBand, random: random);
}

class GIdolState extends State<GIdol> {
  GIdolState({Key key, @required this.currentBand, @required this.random});

  bool random;
  Idol currentIdol;
  Band currentBand;
  Timer _timer;
  int _remainingTime;
  String _result;
  int _chances;
  int maxSeconds;

  @override
  void initState() {
    super.initState();
    maxSeconds = 60;
    _remainingTime = maxSeconds;
    resetTimer();
  }

  void setTimeLeft(Timer timer) {
    setState(() {
      _remainingTime = maxSeconds + 1 - _timer.tick;
      if (_remainingTime <= 0) {
        lose();
      }
    });
  }

  void win() {
    debugPrint("You Win");
  }

  void lose() {
    _timer.cancel();
    debugPrint("You Lost");
  }

  void checkWord() {}

  void resetTimer() {
    _timer = new Timer.periodic(new Duration(seconds: 1), setTimeLeft);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          "Guess the idol",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: new Container(
        child: new Text("Time remaning : $_remainingTime"),
//      child: new Image.asset(currentBand),
      ),
    );
    // TODO: implement build
  }

  void getRandomBand() {
    setState(() {
      currentBand = Bands.all[Random.secure().nextInt(Bands.all.length)];
    });
  }
}
