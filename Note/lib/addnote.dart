import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';


class addproduct extends StatefulWidget {
  addproduct({Key? key}) : super(key: key);

  @override
  _addproductState createState() => _addproductState();
}

class _addproductState extends State<addproduct> {
  var file;
  var product, title, userproduct, nameimage1;

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
  saveproduct(context) async {
    if (file == null)
      return AwesomeDialog(
          context: context, title: 'worng', body: Text('add image'))
        ..show();
    var fromdata = ii.currentState;
    if (fromdata!.validate() != null) {
      fromdata.save();
      awaitget(context);

      await refstorge.putFile(file);

      var url = await refstorge.getDownloadURL();

      FirebaseFirestore.instance.collection('product').add({
        'title': title,
        'product': product,
        'image': url,
        'uid': FirebaseAuth.instance.currentUser!.uid
      }).then((value) {
        Navigator.of(context).pushReplacementNamed('home');
      }).catchError((e) {
        print(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            color: Colors.blue[100],
            child: Form(
              key: ii,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (value) {
                      title = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'tittle is Empty';
                      if (value.length >= 900) return 'title >100little';

                      if (value.length < 9) return 'title <8little';
                    },
                    decoration:
                        const InputDecoration(hintText: 'add tittle product'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      onSaved: (value) {
                        product = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'sub is Empty';
                        if (value.length >= 900) return 'password >100little';

                        if (value.length < 9) return 'password <8little';
                      },
                      decoration:
                          const InputDecoration(hintText: 'add product')),
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
                        await saveproduct(context);
                      },
                      child: const Text('add product')),
                ],
              ),
            )));
  }
}
