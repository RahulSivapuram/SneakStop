import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomapp/constants.dart';
import 'package:ecomapp/screens/cart.dart';
import 'package:ecomapp/screens/product_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final bool hasbackarrow = true;

  final CollectionReference _products =
      FirebaseFirestore.instance.collection("products");

  final CollectionReference _userref =
      FirebaseFirestore.instance.collection("users");

  User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
              future: _products.get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text("Error: ${snapshot.error}"),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 108.0, bottom: 20),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProductPage(
                                    productid: snapshot.data!.docs[index].id,
                                  )));
                        },
                        child: Container(
                          //child: Text(snapshot.data!.docs[index]['name']),
                          margin: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 24.0),

                          child: Stack(
                            children: [
                              Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.network(
                                    snapshot.data!.docs[index]['images'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      snapshot.data!.docs[index]['name'] ??
                                          "Product Name",
                                      style: Constants.Heading,
                                    ),
                                    Text(
                                      snapshot.data!.docs[index]["price"] ??
                                          "Price",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }),
          //
          //action bar
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.white,
                Colors.white.withOpacity(0),
              ], begin: Alignment(0, 0), end: Alignment(0, 1)),
            ),
            padding:
                const EdgeInsets.only(top: 56, bottom: 42, left: 24, right: 24),
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (hasbackarrow)
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  const Text(
                    "ACTION BAR",
                    style: Constants.Heading,
                    textAlign: TextAlign.start,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => CartPage()));
                    },
                    child: Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      child: StreamBuilder(
                        stream: _userref
                            .doc(_user!.uid)
                            .collection("Cart")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          int _totalitems = 0;

                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            List _documents = snapshot.data.docs;
                            _totalitems = _documents.length;
                          }
                          return Text(
                            "${_totalitems}" ?? "0",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
