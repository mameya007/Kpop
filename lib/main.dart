import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kpop/feeds.dart';
import 'const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';

//void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Angels',
      theme: new ThemeData(
        primaryColor: themeColor,
      ),
      home: LoginScreen(title: 'Angels'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;
  bool isLoading = false;
  bool isLoggedIn = false;
  static FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  static FirebaseUser get User {
    return currentUser;
  }

  void isSignedIn() async {
    isLoggedIn = await facebookSignIn.isLoggedIn;
    if (isLoggedIn) Login();
  }

  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  Future<Null> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding:
                EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: themeColor,
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                height: 100.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Exit app',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Are you sure to exit app?',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'CANCEL',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'YES',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
        break;
    }
  }

  void Login() async {
    this.setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    Fluttertoast.showToast(
        msg: "Connecting...", toastLength: Toast.LENGTH_SHORT);
    final FacebookAccessToken accessToken =
        await facebookSignIn.currentAccessToken;
    currentUser =
        await firebaseAuth.signInWithFacebook(accessToken: accessToken.token);
    if (currentUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: currentUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
            .collection('users')
            .document(currentUser.uid)
            .setData({
          'nickname': currentUser.displayName,
          'photoUrl': currentUser.photoUrl,
          'id': currentUser.uid
        });

        // Write data to local
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('nickname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoUrl);
      } else {
        // Write data to local
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('nickname', documents[0]['nickname']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
      }

      this.setState(() {
        isLoading = false;
      });
      final QuerySnapshot docs =
          await Firestore.instance.collection("rooms").getDocuments();
      List<DocumentSnapshot> _rooms = docs.documents;
      Fluttertoast.showToast(msg: "Connected", toastLength: Toast.LENGTH_SHORT);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Feeds(),
          ));
    } else {
      this.setState(() {
        isLoading = false;
      });
    }
  }

  void handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });
    final FacebookLoginResult result = await facebookSignIn
        .logInWithReadPermissions(['email', 'public_profile']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        Fluttertoast.showToast(
            msg: "Connecting...", toastLength: Toast.LENGTH_SHORT);
        currentUser = await firebaseAuth.signInWithFacebook(
            accessToken: result.accessToken.token);
        debugPrint('''
         Logged in!
         Name: ${currentUser.displayName}
         Email: ${currentUser.email}
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        break;
      case FacebookLoginStatus.cancelledByUser:
        debugPrint('Login cancelled by the user.');
        Fluttertoast.showToast(
            msg: "Login has been cancelled", toastLength: Toast.LENGTH_LONG);
        break;
      case FacebookLoginStatus.error:
        debugPrint('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        Fluttertoast.showToast(
            msg: result.errorMessage, toastLength: Toast.LENGTH_LONG);
        break;
    }

//    FirebaseUser firebaseUser = await firebaseAuth.signInWithEmailAndPassword(email: "mameya.mseddi@gmail.com", password: "1996medmsd");
    if (currentUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: currentUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
            .collection('users')
            .document(currentUser.uid)
            .setData({
          'nickname': currentUser.displayName,
          'photoUrl': currentUser.photoUrl,
          'id': currentUser.uid
        });

        // Write data to local
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('nickname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoUrl);
        await prefs.setBool("isLoggedIn", true);
      } else {
        // Write data to local
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('nickname', documents[0]['nickname']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
        await prefs.setBool("isLoggedIn", true);
      }

      this.setState(() {
        isLoading = false;
      });
      final QuerySnapshot docs =
          await Firestore.instance.collection("rooms").getDocuments();
      List<DocumentSnapshot> _rooms = docs.documents;
      Fluttertoast.showToast(msg: "Connected", toastLength: Toast.LENGTH_SHORT);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Feeds(),
          ));
    } else {
      this.setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child :Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Stack(
          children: <Widget>[
            Center(
              child: FlatButton(
                  onPressed: handleSignIn,
                  child: Text(
                    'SIGN IN WITH FACEBOOK',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: Color(0xffdd4b39),
                  highlightColor: Color(0xffff7f7f),
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
            ),

            // Loading
            Positioned(
              child: isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                        ),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
        onWillPop: onBackPress,
      );
  }
}
