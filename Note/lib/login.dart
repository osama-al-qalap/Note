import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:awesome_dialog/awesome_dialog.dart';

class login_ extends StatefulWidget {
  login_({Key? key}) : super(key: key);

  @override
  _login_State createState() => _login_State();
}

awaitget(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('please Waiting'),
          content: Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        );
      });
}

class _login_State extends State<login_> {
  dynamic password1, email1;
  GlobalKey<FormState> hhh = new GlobalKey<FormState>();

  satst1() async {
    var fromdata = hhh.currentState;
    if (fromdata!.validate() == true) {
      fromdata.save();
      try {
        awaitget(context);

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email1, password: password1);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          AwesomeDialog(
              context: context, body: Text('No user found for that email.'))
            ..show();
          ;
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              body: Text('Wrong password provided for that user.'))
            ..show();
        }
      }
    } else
      print('Not voide');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(),
        body: Container(
            color: Colors.blueGrey,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: hhh,
              child: ListView(
                children: [
                  Container(
                    child: Image.asset('images/10.jpg'),
                  ),
                  TextFormField(
                      onSaved: (val) {
                        email1 = val;
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty)
                          return 'password is Empty';
                        if (val.length >= 100) return 'password >100little';

                        if (val.length < 9) return 'password <8little';
                      },
                      decoration: InputDecoration(
                        hintText: 'Usaer login',
                        hintStyle: TextStyle(fontSize: 18),
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 10),
                            borderRadius: BorderRadius.circular(20)),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      onSaved: (val) {
                        password1 = val;
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty)
                          return 'password is Empty';
                        if (val.length >= 100) return 'password >100little';

                        if (val.length < 9) return 'password <8little';
                      },
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(fontSize: 18),
                        prefixIcon: Icon(Icons.lock),
                        suffix: InkWell(
                          child: Icon(Icons.remove_red_eye),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 10),
                            borderRadius: BorderRadius.circular(20)),
                      )),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(children: [
                      Text('you have Email/ '),
                      InkWell(
                        child: Text(
                          'Click her',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('two');
                        },
                      )
                    ]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.blue,
                    ),
                    width: double.infinity,
                    height: 50,
                    child: MaterialButton(
                      onPressed: () async {
                        var response = await satst1();

                        if (response != null) {
                          Navigator.of(context).pushNamed('home');
                        } else {
                          var fromdata = hhh.currentState;
                          if (fromdata!.validate() == true)
                            Navigator.of(context).pop();

                          AwesomeDialog(
                              context: context, body: Text('not found acount'))
                            ..show();
                        }
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4),
                        textWidthBasis: TextWidthBasis.longestLine,
                      ),
                    ),
                  ),
                  Text(
                    'Or cnnect using',
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 3),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 3),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: InkWell(
                          splashColor: Colors.blue,
                          onTap: () {
                            print('object');
                          },
                          customBorder:
                              Border.all(color: Colors.black, width: 30),
                          child: Icon(
                            Icons.facebook,
                            size: 55,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 3),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: InkWell(
                            splashColor: Colors.blue,
                            onTap: () {
                              print('object');
                            },
                            child: Image.asset(
                              'images/7.png',
                              width: 55,
                            )),
                      ),
                    ],
                  )
                ],
              ),
            )));
  }
}
