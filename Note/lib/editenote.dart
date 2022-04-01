import 'dart:io';
import 'dart:math';
import 'dart:collection';
import 'package:path/path.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class editenote extends StatefulWidget {
  final doucid;
  final result;

  editenote({Key? key, this.doucid, this.result}) : super(key: key);

  @override
  _editenoteState createState() => _editenoteState();
}

class _editenoteState extends State<editenote> {
  var file;
  var note, title, usernote, nameimage1;

  var refstorge;

  awaitget(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please Waiting'),
            content: Container(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  GlobalKey<FormState> ii = new GlobalKey<FormState>();
  savenote(context) async {
    if (file == null) {
      var fromdata = ii.currentState;
      if (fromdata!.validate() != null) {
        fromdata.save();
        awaitget(context);
        FirebaseFirestore.instance
            .collection('note')
            .doc(widget.doucid)
            .update({
          'title': title,
          'note': note,
        }).then((value) {
          Navigator.of(context).pushReplacementNamed('home');
        }).catchError((e) {
          print(e);
        });
      }
    } else {
      var fromdata = ii.currentState;
      if (fromdata!.validate() != null) {
        fromdata.save();
        awaitget(context);
        await FirebaseStorage.instance
            .refFromURL(widget.result['image'])
            .delete();

        await refstorge.putFile(file);

        var url = await refstorge.getDownloadURL();
        FirebaseFirestore.instance
            .collection('note')
            .doc(widget.doucid)
            .update({
          'title': title,
          'note': note,
          'image': url,
        }).then((value) {
          Navigator.of(context).pushReplacementNamed('home');
        }).catchError((e) {
          print(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('edit'),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            color: Colors.blue[100],
            child: Form(
              key: ii,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: widget.result['title'],
                    onSaved: (value) {
                      title = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'password is Empty';
                      if (value.length >= 900) return 'password >100little';

                      if (value.length < 9) return 'password <8little';
                    },
                    decoration:
                        const InputDecoration(hintText: 'add tittle note'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      initialValue: widget.result['note'],
                      onSaved: (value) {
                        note = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'password is Empty';
                        if (value.length >= 900) return 'password >100little';

                        if (value.length < 9) return 'password <8little';
                      },
                      decoration: const InputDecoration(hintText: 'add note')),
                  ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                  height: 160,
                                  color: Colors.blue[100],
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 9,
                                      ),
                                      MaterialButton(
                                          height: 50,
                                          minWidth: 350,
                                          color: Colors.blue,
                                          onPressed: () async {
                                            final ImagePicker _picker =
                                                ImagePicker();
                                            final XFile? image =
                                                await _picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            if (image != null) {
                                              file = File(image.path);
                                              var nameimage =
                                                  basename(image.path);
                                              var random =
                                                  Random().nextInt(1000000);
                                              nameimage1 = '$nameimage$random';
                                              refstorge = FirebaseStorage
                                                  .instance
                                                  .ref('image')
                                                  .child(nameimage1);

                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('gallery'),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Icon(Icons
                                                    .picture_in_picture_outlined)
                                              ])),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      MaterialButton(
                                          height: 50,
                                          minWidth: 350,
                                          color: Colors.blue,
                                          onPressed: () async {
                                            final ImagePicker _picker =
                                                ImagePicker();
                                            final XFile? image =
                                                await _picker.pickImage(
                                                    source: ImageSource.camera);
                                            if (image != null) {
                                              file = File(image.path);
                                              var nameimage =
                                                  basename(image.path);
                                              var random =
                                                  Random().nextInt(1000000);
                                              nameimage1 = '$nameimage$random';
                                              refstorge = FirebaseStorage
                                                  .instance
                                                  .ref('image')
                                                  .child(nameimage1);

                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('camera'),
                                                SizedBox(
                                                  width: 18,
                                                ),
                                                Icon(Icons.camera)
                                              ])),
                                    ],
                                  ));
                            });
                      },
                      child: const Text('Add image')),
                  ElevatedButton(
                      onPressed: () async {
                        await savenote(context);
                      },
                      child: const Text('add note')),
                ],
              ),
            )));
  }
}
