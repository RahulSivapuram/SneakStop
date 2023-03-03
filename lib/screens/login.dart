import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;

  final _fkey = GlobalKey<FormState>();
  var _email = "";
  var _password = "";
  var _username = "";

  startauthentication() {
    final valid = _fkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (valid) {
      _fkey.currentState!.save();
      submitform(_email, _password, _username);
    }
  }

  submitform(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authresult;
    try {
      if (loading) {
        authresult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
      } else {
        authresult = await auth.signInWithEmailAndPassword(
            email: email, password: password);

        String uid = authresult.user!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'username': username, 'email': email});
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Form(
              key: _fkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: const EdgeInsets.only(top: 15),
                      child: loading
                          ? Text(
                              "Welcome \nRegister your account",
                              style: Constants.Heading,
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              "Welcome \nLogin to your account",
                              style: Constants.Heading,
                              textAlign: TextAlign.center,
                            )),
                  Column(
                    children: [
                      loading
                          ? Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              decoration: BoxDecoration(
                                  color: Color(0xFFF2F2F2),
                                  borderRadius: BorderRadius.circular(8)),
                              child: TextFormField(
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  hintText: "Username",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 24),
                                ),
                                onSaved: (newValue) {
                                  _username = newValue!;
                                },
                              ),
                            )
                          : Container(),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                            color: Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(8)),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          key: ValueKey('email'),
                          decoration: InputDecoration(
                            hintText: "Email..",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 24),
                          ),
                          validator: (value) {
                            if (value.toString().isEmpty ||
                                !value.toString().contains('@')) {
                              return "Email Invalid";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (newValue) {
                            _email = newValue!;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                            color: Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(8)),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Password ..",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 24),
                          ),
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return "Password invalid";
                            } else if (value.toString().length < 7) {
                              return "Password should be greater than 7";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (newValue) {
                            _password = newValue!;
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          startauthentication();
                        },
                        child: Container(
                          height: 50,
                          width: 200,
                          margin: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                              child: loading
                                  ? Text(
                                      "Register",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      "Login",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    )),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        loading = !loading;
                      });
                    },
                    child: Container(
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        margin: const EdgeInsets.only(
                            left: 19, right: 19, bottom: 25),
                        child: loading
                            ? Text(
                                "Login in to your account",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            : Text(
                                "Don't have an account,Create",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
