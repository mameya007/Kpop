import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'utils.dart';
import 'const.dart';

class GIdol extends StatefulWidget {
  final Band currentBand;

  GIdol({Key key, @required this.currentBand}) : super(key: key);

  @override
  State createState() => new GIdolState(currentBand: currentBand);
}

class GIdolState extends State<GIdol> {
  GIdolState({Key key, @required this.currentBand});

  final _random = new Random();
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
    debugPrint(currentBand.members.length.toString());
    currentIdol =
        currentBand.members[_random.nextInt(currentBand.members.length)];
    debugPrint("Idol Name: " + currentIdol.name);
    debugPrint("Idol Pictures " + currentIdol.pictures.length.toString());
    currentIdol.pictures.shuffle();
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
      body: new Stack(
        children: <Widget>[
          new Container(child: new Text("Time remaning : $_remainingTime")),
          new ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemBuilder: (context, index) => buildItem(index),
            itemCount: 2,
//            reverse: true,
          ),
        ],
      ),
    );
  }

  Widget buildItem(int index) {
    debugPrint(currentIdol.pictures[index].toString());
//    return DecoratedBox(
//      decoration: BoxDecoration(
//        image: DecorationImage(
//          image: AssetImage("images/BTS/Members/Jin/"+(index+1).toString()+".jpg"),
//          // ...
//        ),
//        // ...
//      ),
//    );
    return new Container(
      child: new Image.asset("images/BTS/Members/Jin/"+(index+1).toString()+".jpg"),
      height: 75.0,
      width: 75.0,
    );
  }

  void getRandomBand() {
    setState(() {
      currentBand = Bands.all[Random.secure().nextInt(Bands.all.length)];
    });
  }
}