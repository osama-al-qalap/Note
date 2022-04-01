// ignore_for_file: unused_local_variable
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

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tttggg/vieweditnote.dart';

class home extends StatefulWidget {
  home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  final _formKey = GlobalKey<FormState>();
  final _openDropDownProgKey = GlobalKey<DropdownSearchState<String>>();
  var o = FirebaseFirestore.instance.collection('product').get();

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
            appBar: AppBar(
              title: Text('home'),
              leading: IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios_new),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).restorablePushNamed('addproduct');
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.green,
            ),
            body: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('product')
                    .where('uid',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, i) {
                        var result = snapshot.data!.docs[i].data()
                            as Map<String, dynamic>;
                        var doucid = snapshot.data!.docs[i].id;
                        return Dismissible(
                            onDismissed: (value) async {
                              await FirebaseFirestore.instance
                                  .collection('product')
                                  .doc(doucid)
                                  .delete();
                              await FirebaseStorage.instance
                                  .refFromURL(result['image'])
                                  .delete();
                            },
                            key: UniqueKey(),
                            child: InkWell(
                              onTap: () async {
                                // Navigator.of(context)
                                // .popAndPushNamed('addproduct');

                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return vieweditnote(
                                      doucid: doucid, result: result);
                                  Navigator.of(context)
                                      .popAndPushNamed('vieweditproduct');
                                }));
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Image.network(result['image'])),
                                    Expanded(
                                        flex: 3,
                                        child: ListTile(
                                          title: Text(
                                            '${result['title']}',
                                            maxLines: 1,
                                          ),
                                          subtitle: Text(result['product'],
                                              maxLines: 1),
                                          trailing: IconButton(
                                              onPressed: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return vieweditnote(
                                                      doucid: doucid,
                                                      result: result);
                                                }));
                                              },
                                              icon: Icon(Icons.edit)),
                                        ))
                                  ],
                                ),
                              ),
                            ));

                        //Image.network(result['uid'])
                      });
                })));
  }
}
/* floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).restorablePushNamed('addproduct');
            },
            child: const Icon(Icons.add),
            backgroundColor: Colors.green,
          ),*/