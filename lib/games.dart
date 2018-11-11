import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Chat.dart';
import 'main.dart';
import 'const.dart';
import 'settings.dart';
import 'utils.dart';
import 'dart:convert';
import 'dart:math';
import 'GIdol.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Games extends StatefulWidget {
  @override
  State createState() => new GamesState();
}

class GamesState extends State<Games> {
  List<Game> games;
  var bands;
  int toShow;
  int type;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: new Center(child: getCurrentList()),
      onWillPop: onBackPress,
    );
  }

  Future<bool> onBackPress() {
    debugPrint("Back Pressed");
    setState(() {
      if (toShow > 0) toShow = toShow - 1;
    });
    return Future.value(false);
  }

  @override
  void dispose() {
    super.dispose();
    toShow = 0;
    debugPrint("Disposed");
  }

  @override
  void initState() {
    super.initState();
    games = [
      new Game(
          picture: Image.asset("images/Guess the song.png"),
          title: 'Guess the song',
          type: 0),
      new Game(
          picture: Image.asset("images/Guess the band.png"),
          title: 'Guess the band',
          type: 1),
      new Game(
          picture: Image.asset("images/Guess the idol.png"),
          title: 'Guess the idol',
          type: 2),
    ];
    toShow = 0;
    type = 0;
    Idols.init();
    Bands.init();
  }

  Widget buildItem(BuildContext context, Game game) {
    return new Container(
      child: FlatButton(
        child: Row(
          children: <Widget>[
            Material(
              child: Image.asset("images/${game.title}.png",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                  alignment: Alignment.center),
              borderRadius: BorderRadius.all(Radius.elliptical(50.0, 50.0)),
            ),
            new Flexible(
              child: Container(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      child: Text(
                        game.title,
                        style: TextStyle(color: primaryColor),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
          ],
        ),
        onPressed: () {
          _toNextList();
          setState(() {
            type = game.type;
          });
        },
        color: greyColor2,
        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
  }

  Widget getCurrentList() {
    if (toShow == 0)
      return ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, index) => buildItem(context, games[index]),
        itemCount: games.length,
      );
    else if (toShow == 1)
      return new Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new FlatButton(
              onPressed: () {
                startGame(null);
              },
              color: Colors.red,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: new Text(
                "All Random",
                style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.orangeAccent,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
            ),
            new FlatButton(
                onPressed: () {
                  _toNextList();
                },
                color: Colors.red,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                child: new Text(
                  "Select Band",
                  style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.orangeAccent,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ),
      );
    else if (toShow == 2) return displayAllBands();
  }

  void _toNextList() {
    setState(() {
      toShow = toShow + 1;
    });
  }

  Widget displayAllBands() {
    return ListView.builder(
      itemCount: Bands.all.length,
      itemBuilder: (context, index) {
        return new Center(
          child: new FlatButton(
              onPressed: () {
                startGame(Bands.all[index]);
              },
              color: Colors.red,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: new Text(
                "${Bands.all[index].name}",
                style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              )),
        );
      },
    );
  }

  void startGame(Band band) {
    if (band == null) {
      band = Bands.all[Random.secure().nextInt(Bands.all.length)];
      debugPrint("Selected : ${band.name}");
      //TODO: ALL Random
    }
//    debugPrint("Selected : ${band.name}");
    Navigator.push(context , new MaterialPageRoute(
      builder: (context) => GIdol(currentBand: band,)
    ));
  }
}
