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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Games extends StatefulWidget {

  @override
  State createState() => new GamesState();
}

class GamesState extends State<Games> {
  List<Game> games;
  var bands;
  int toShow=0;
  int type;
  Idol jin = new Idol(
      picture: Image.asset("images/BTS/Members/Jin/Jin.jpg"),
      name: "JIN",
      band: null);


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

  Widget getCurrentList() {
    if (toShow == 0)
      return ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, index) => buildItem(context, games[index]),
        itemCount: games.length,
      );
    else if (toShow == 1)
      return new Center(
        child: new Row(
          children: <Widget>[
            new FlatButton(onPressed: (){startGame(null);}, child: new Text("All Random")),
            new FlatButton(onPressed: () {_toNextList();}, child: new Text("Select Band"))
          ],
        ),
      );
    else if(toShow==2)
      return displayAllBands();
  }

  @override
  void initState() {
    super.initState();
    games=[
      new Game(picture:Image.asset("images/Guess the song.png"),title: 'Guess the song',type: 0),
      new Game(picture:Image.asset("images/Guess the band.png"),title: 'Guess the band',type: 1),
      new Game(picture:Image.asset("images/Guess the idol.png"),title: 'Guess the idol',type: 2),
    ];
    toShow = 0;
    type=0;
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
          setState(() {type=game.type;});
        },
        color: greyColor2,
        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
    );
  }

  void _toNextList() {
    debugPrint(Bands.bts.members[0].name);
    setState(() {
      toShow = toShow + 1;
    });
  }


  Widget displayAllBands() {
//    List<Band> bands = Bands.all;
    return ListView.builder(
      itemCount: bands.length,
      itemBuilder: (context, index) {
        return new Center(
          child: new FlatButton(
              onPressed: () {
                startGame(bands[index]);
              },
              child: new Text("${bands[index].name}")),
        );
      },
    );
  }

  void startGame(Band band) {
    if (band == null) {
      //TODO: ALL Random
    } else {
      //TODO: From One Band
    }
  }
}
