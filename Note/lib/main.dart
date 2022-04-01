import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:tttggg/addnote.dart';
import 'package:tttggg/creat.dart';
import 'package:tttggg/home.dart';
import 'package:tttggg/login.dart';
import 'package:tttggg/vieweditnote.dart';

bool islogn = false;
@override
void initState() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Future<String?> messaging =
      FirebaseMessaging.instance.getToken().then((value) {});
}

@override
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.currentUser == null ? islogn = false : islogn = true;

  runApp(MaterialApp(
    home: islogn == false ? login_() : home(),
    theme: ThemeData(
        hintColor: Colors.black,
        cardColor: Colors.blue[150],
        textTheme: TextTheme(headline2: TextStyle(fontSize: 16)),
        errorColor: Colors.blue,
        textSelectionTheme: TextSelectionThemeData()),
    debugShowCheckedModeBanner: false,
    debugShowMaterialGrid: false,
    routes: {
      'own': (context) => login_(),
      'two': (context) => CreateNew(),
      'home': (context) => home(),
      'addnote': (context) => addnote(),
      'vieweditnote': (context) => vieweditnote(),
    },
  ));
}
