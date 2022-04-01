import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateNew extends StatefulWidget {
  const CreateNew({Key? key}) : super(key: key);

  @override
  _CreateNewState createState() => _CreateNewState();
}

awaitget(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text('Please waite a litte'),
            content: Container(child: CircularProgressIndicator()));
      });
}

class _CreateNewState extends State<CreateNew> {
  dynamic password1, password2, phone, email1, user1;

  GlobalKey<FormState> hhh = new GlobalKey<FormState>();

  satst() async {
    var fromdata = hhh.currentState;
    if (fromdata!.validate() == true) {
      fromdata.save();
      try {
        awaitget(context);
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email1,
          password: password1,
        );
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              body: Text('The password provided is too weak.'))
            ..show();
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
              context: context,
              body: Text('The account already exists for that email.'))
            ..show();
        }
      } catch (e) {
        print(e);
      }
    } else
      AwesomeDialog(context: context, body: Text('is empty'))..show();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  Navigator.of(context).pushReplacementNamed('own');
                },
                icon: Icon(Icons.exit_to_app))
          ],
        ),
        body: Container(
            color: Colors.blueGrey,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: hhh,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Row(children: [
                    // ignore: avoid_unnecessary_containers
                    Container(
                        child: const Text(
                      'Create an account:',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    )),
                  ]),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: TextFormField(
                        onSaved: (val) {
                          user1 = val;
                        },
                        validator: (val) {
                          if (val!.contains('@') || val.contains('.com'))
                            return 'worng @ OR com';
                        },
                        decoration: const InputDecoration(
                          hintText: 'User name',
                          hintStyle: TextStyle(fontSize: 18),
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 10)),
                        )),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: TextFormField(
                        onSaved: (val) {
                          email1 = val;
                        },
                        validator: (val) {
                          print(val);
                        },
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(fontSize: 18),
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 10)),
                        )),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: TextFormField(
                        onSaved: (value) {
                          phone = value;
                          print('============================');
                          print(phone);
                          print('============================');
                        },
                        decoration: InputDecoration(
                          hintText: 'Phone',
                          hintStyle: const TextStyle(fontSize: 18),
                          prefixIcon: const Icon(Icons.phone_android),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(width: 10)),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: TextFormField(
                        onSaved: (val) {
                          password1 = val;
                          print('============================');
                          print(password1);
                          print('============================');
                        },
                        autocorrect: false,

                        // ignore: unused_label
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return 'password is Empty';
                          if (val.length >= 100) return 'password >100little';

                          if (val.length < 9) return 'password <8little';
                        },
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(fontSize: 18),
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 10),
                          ),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: TextFormField(
                        onSaved: (val) {
                          password2 = val;
                        },
                        validator: (value) {},
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(fontSize: 18),
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 10)),
                        )),
                  ),
                  Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.blue,
                      ),
                      child: MaterialButton(
                          onPressed: () async {
                            var responce = satst();
                            if (responce != null) {
                              if (FirebaseAuth.instance.currentUser != null) {
                                Navigator.of(context)
                                    .pushReplacementNamed('home');
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .add({
                                  'name': user1,
                                  'phone': phone,
                                  'email': email1,
                                });
                              }
                            }
                          },
                          child: Text(
                            'CREATE',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3),
                            textWidthBasis: TextWidthBasis.longestLine,
                          ))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have ?"),
                      InkWell(
                        child: Text(
                          'Login here',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onTap: () {
                          Navigator.of(context).popAndPushNamed('own');
                        },
                      ),
                    ],
                  )
                ],
              ),
            )));
  }
}
