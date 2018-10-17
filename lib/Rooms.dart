import 'dart:async';
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
class Rooms extends StatelessWidget{
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: Stack(
        children: <Widget>[
          // List
          Container(
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
    );
  }
  Future<bool> onBackPress() {
//    openDialog();
    debugPrint("Rooms");
    return Future.value(false);
  }
  Widget buildItem(BuildContext context, DocumentSnapshot document) {
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


}