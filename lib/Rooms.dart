import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Chat.dart';
import 'main.dart';
import 'const.dart';
import 'settings.dart';
import 'utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Rooms extends StatefulWidget {
  @override
  State createState() => new RoomsState();
}

class RoomsState extends State<Rooms> {
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
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Rooms',
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
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            // List
            Container(
//              child : ListView.builder(
//                                padding: EdgeInsets.all(10.0),
//                      itemBuilder: (context, index) => buildItem(context,documents),
//                  itemCount: size,
//        ),),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('rooms')
                    .getDocuments()
                    .asStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) =>
                          buildItem(context, snapshot.data.documents[index]),
                      itemCount: snapshot.data.documents.length,
                    );
                  }
                },
              ),
            ),

            // Loading
            Positioned(
              child: isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(themeColor)),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            )
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }


  Future<bool> onBackPress() {
//    openDialog();
    debugPrint("Rooms");
    return Future.value(false);
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
//    debugPrint(''''
//    Nom : ${document.documentID}
//    Data : ${document.reference.collection('Messages')}
//    Length : ${document.data.length}
//    '''''
//    );
    return Container(
      child: FlatButton(
        child: Row(
          children: <Widget>[
            Material(
              child: Image.asset("images/${document.documentID}.jpg",
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
                        'Room Name: ${document.documentID}',
                        style: TextStyle(color: primaryColor),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
//                    new Container(
//                      child: Text(
//                        'About me: ${document['aboutMe'] ?? 'Not available'}',
//                        style: TextStyle(color: primaryColor),
//                      ),
//                      alignment: Alignment.centerLeft,
//                      margin: new EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
//                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new Chat(
                        groupChatId: document.documentID,
                      )));
        },
        color: greyColor2,
        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
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
