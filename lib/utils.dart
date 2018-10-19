import 'dart:async';
import 'dart:io';
import 'utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'const.dart';
import 'package:intl/intl.dart';

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

class Game {
  const Game({this.picture, this.title, this.type});

  final Image picture;
  final String title;
  final int type;
}

class Idol {
  Idol({this.picture, this.name, this.band});

  Image picture;
  String name;
  Band band;
}

class Idols {
  static List<Idol> all;
  static void init() {
    jin = new Idol(
        picture: Image.asset("images/BTS/Members/Jin/Jin.jpg"),
        name: "JIN",
        band: Bands.bts);
    all=[jin];
  }

  static Idol jin;
}

class Band {
  const Band({this.members, this.name});

  final List<Idol> members;
  final String name;
}

class Bands {
  static List<Idol> _bts;
  static Band bts;
  static List<Band> all;

  static void init() {
    _bts = [Idols.jin];
    bts = new Band(members: _bts, name: 'BTS');
    all = [
      Bands.bts,
    ];
  }
}

class Song {
  const Song({this.picture, this.title, this.band});

  final Image picture;
  final String title;
  final Band band;
}

class Songs {
//  static void init();
}

class MembersScreen extends StatefulWidget {
  String groupChatId;

  MembersScreen({Key key, @required this.groupChatId});

  @override
  State createState() => new MembersScreenState(groupChatId: groupChatId);
}

class MembersScreenState extends State<MembersScreen> {
  MembersScreenState({Key key, @required this.groupChatId});

  String groupChatId;
  int numbersOnline;
  final ScrollController listScrollController = new ScrollController();
  var listMembers;
  ListView listView;

  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection("rooms")
        .document(groupChatId)
        .collection("Members")
        .snapshots()
        .listen((data) {
      debugPrint("Hello ${data.documents.length}");
      setState(() {
        numbersOnline = data.documents.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Members Online $numbersOnline ",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
//        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('rooms')
            .document(groupChatId)
            .collection('Members')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor)));
          } else {
            listMembers = snapshot.data.documents;
            debugPrint("Length $numbersOnline");
            listView = ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildMember(snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              reverse: false,
              controller: listScrollController,
            );
            return listView;
          }
        },
      ),
    );
  }

  Widget buildMember(DocumentSnapshot document) {
    debugPrint("Display Name  ${document['displayName']}");
    return new Text(
      document['displayName'],
      style: TextStyle(color: primaryColor),
      textAlign: TextAlign.center,
//        ),
    );
  }
}
