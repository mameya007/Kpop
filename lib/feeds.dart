import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Rooms.dart';
import 'games.dart';
import 'main.dart';
import 'const.dart';
import 'settings.dart';
import 'utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Feeds extends StatefulWidget {
  @override
  State createState() => new RoomsState();
}

class RoomsState extends State<Feeds> {
   List<Game> games =[
    new Game(picture:Image.asset("images/Guess the song.png"),title: 'Guess the song',type: 0),
    new Game(picture:Image.asset("images/Guess the band.png"),title: 'Guess the band',type: 1),
    new Game(picture:Image.asset("images/Guess the idol.png"),title: 'Guess the idol',type: 2),
  ];
  TabController tabController;
  bool isLoading = false;
  static int size = 0;

  Future<Null> _rooms =
      Firestore.instance.collection('rooms').getDocuments().then((snap) {
    size = snap.documents.length;
  });
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new  DefaultTabController(length: 2,
      child: Scaffold(
        appBar: PreferredSize(child: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Feeds',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<Choice>(
              onSelected: onItemMenuPress,
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                      value: choice,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            choice.icon,
                            color: primaryColor,
                          ),
                          Container(
                            width: 10.0,
                          ),
                          Text(
                            choice.title,
                            style: TextStyle(color: primaryColor),
                          ),
                        ],
                      ));
                }).toList();
              },
            ),
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.chat), text: "Rooms"),
              Tab(icon: Icon(Icons.videogame_asset), text: "Games")
            ],
          ),
        ),
          preferredSize: Size.fromHeight(100.0),
    ),
        body: TabBarView(children: <Widget>[Rooms(), Games(games: games,)])),
    );
  }

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
      handleSignOut();
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Settings()));
    }
  }

  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LoginScreenState.facebookSignIn.logOut();
    await FirebaseAuth.instance.signOut();
    await prefs.setBool("isLoggedIn", false);
    Fluttertoast.showToast(
        msg: "Disconnected", toastLength: Toast.LENGTH_SHORT);
    this.setState(() {
      isLoading = false;
    });
    Navigator.pop(context, MaterialPageRoute(builder: (context) => MyApp()));
  }
}
