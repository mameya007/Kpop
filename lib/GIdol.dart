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
    if (currentBand == null) {
      currentBand = getRandomBand();
    }
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
          new Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: new GridView.builder(
              padding: EdgeInsets.all(5.0),
              itemBuilder: (context, index) => buildItem(index),
              itemCount: 4,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),

//            reverse: true,
            ),
          ),
          //TODO:Buttons of Characters Alphabets
          new Container(
              alignment: Alignment(0.0, 0.45),
              child: new DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: new Text(
                    "Kim S_____",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        letterSpacing: 5.0,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  ))),

          new Container(
            margin: EdgeInsets.fromLTRB(0.0, 425.0, 0.0, 0.0),
            alignment: Alignment(0.0, 0.8),
            child: new Table(
              children: [
                TableRow(children: [
                  new MaterialButton(
                      onPressed: () {},
                      child: new Text(
                        "A",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      )),
                  new MaterialButton(
                      onPressed: () {},
                      child: new Text(
                        "A",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      )),
                  new MaterialButton(
                      onPressed: () {},
                      child: new Text(
                        "A",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      )),
                  new MaterialButton(
                      onPressed: () {},
                      child: new Text(
                        "A",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      )),
                  new MaterialButton(
                      onPressed: () {},
                      child: new Text(
                        "A",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      )),
                ]),
                TableRow(children: [
                  new MaterialButton(
                      onPressed: () {},
                      child: new Text(
                        "A",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      )),
                  new MaterialButton(
                      onPressed: () {},
                      child: new Text(
                        "A",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      )),
                  new MaterialButton(
                      onPressed: () {},
                      child: new Text(
                        "A",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      )),
                  new MaterialButton(
                      onPressed: () {},
                      child: new Text(
                        "A",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      )),
                  new MaterialButton(
                      onPressed: () {},
                      child: new Text(
                        "A",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      )),
                ]),
              ],
            ),
//              child: new GridView.builder(
//                addRepaintBoundaries: false,
//                addAutomaticKeepAlives: false,
//                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                    crossAxisCount: 5),
//                itemBuilder: (context, index) => buildCharacter(index),
//                itemCount: 10,
//              ),
          ),
        ],
      ),
    );
  }

  Widget buildCharacter(int index) {
    return new MaterialButton(
        minWidth: 20.0,
        height: 40.0,
        onPressed: () {
          debugPrint(index.toString());
        },
        child: new Text(
          "A",
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ));
  }

  Widget buildItem(int index) {
    debugPrint(currentIdol.pictures[index].toString());
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        image: DecorationImage(
          image: AssetImage(
              "images/BTS/Members/Jin/" + (index + 1).toString() + ".jpg"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Band getRandomBand() {
    return currentBand = Bands.all[_random.nextInt(Bands.all.length)];
  }
}
