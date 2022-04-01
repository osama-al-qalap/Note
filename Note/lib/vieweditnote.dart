import 'dart:collection';
import 'dart:math';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class vieweditnote extends StatefulWidget {
  var result;
  var doucid;
  vieweditnote({Key? key, this.result, this.doucid}) : super(key: key);

  @override
  _vieweditnoteState createState() => _vieweditnoteState();
}

class _vieweditnoteState extends State<vieweditnote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView(
          children: [
            Container(
              child: Image.network(
                widget.result['image'],
                fit: BoxFit.fill,
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                border: Border.all(width: 10),
                color: Colors.blue[300],
              ),
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Text(
                widget.result['title'],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              ),
            ),
            RichText(
              text: TextSpan(
                text: widget.result['note'],
                style: TextStyle(color: Color(0xff462446), fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
