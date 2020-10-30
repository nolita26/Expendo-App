import 'package:todoapp/pages/home_page.dart';
import 'package:todoapp/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todoapp/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/services/sign_in.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var _formkey = GlobalKey<FormState>();
  String _email, _password;
  bool isLoading = false;

  AuthService _authService = AuthService();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("images/back.jpg"),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 40,
                        left: 10,
                        child: GestureDetector(
                          onTap: () {},
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RegisterForm(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Center RegisterForm() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text("Register",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontFamily: "Poppins-Bold",
                          fontWeight: FontWeight.bold,
                          letterSpacing: .6)),
                ),
                SizedBox(height: 25),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (item) {
                    return item.contains("@") ? null : "Enter valid Email";
                  },
                  onChanged: (item) {
                    setState(() {
                      _email = item;
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "E-Mail",
                      hintStyle:
                      TextStyle(color: Colors.white, fontSize: 15.0)),
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  validator: (item) {
                    return item.length > 7 ? null : "Password must be at least 8 characters";
                  },
                  onChanged: (item) {
                    setState(() {
                      _password = item;
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle:
                      TextStyle(color: Colors.white, fontSize: 15.0)),
                ),
                SizedBox(height: 25),
                Center(
                  child: Container(
                    width: 150,
                    height: 40,
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password).then((user) {
                          // sign up
                          setState(() {
                            isLoading = false;
                          });
                          Fluttertoast.showToast(msg: "Register Success");
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MyHomePage()), (Route<dynamic> route) => false);
                        }).catchError((onError) {
                          setState(() {
                            isLoading = false;
                          });
                          Fluttertoast.showToast(msg: "error " + onError.toString());
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      color: Colors.white,
                      splashColor: Colors.blue,
                      textColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(children: <Widget>[
            Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                  child: Divider(
                    color: Colors.white,
                    thickness: 3.0,
                  ),
                )),
            Text(
              "OR",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Divider(
                    color: Colors.white,
                    thickness: 3.0,
                  ),
                )),
          ]),
          SizedBox(height: 25),
          _signInButton(),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Have an account?',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 5.0),
              InkWell(
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    fontSize: 17,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Login(),
                          fullscreenDialog: true));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _signInButton() {
    return FlatButton(
      color: Colors.white,
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context){
                return MyHomePage();
              },
            ),
          );
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("images/google.png"), height: 30.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign up with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void login() {
    setState(() {
      isLoading = true;
    });
    _authService.signInWithEmailAndPassword(_email, _password).then((user) {
      // sign up
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Login Success");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MyHomePage()),
              (Route<dynamic> route) => false);
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "error " + onError.toString());
    });
  }
}

