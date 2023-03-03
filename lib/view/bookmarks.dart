import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../screens/cart.dart';
import '../screens/product_page.dart';

class BookmarksView extends StatefulWidget {
  const BookmarksView({super.key});

  @override
  State<BookmarksView> createState() => _BookmarksViewState();
}

class _BookmarksViewState extends State<BookmarksView> {
  final bool hasbackarrow = false;

  final CollectionReference _userref =
      FirebaseFirestore.instance.collection("users");

  User? _user = FirebaseAuth.instance.currentUser;
  final CollectionReference<Map<String, dynamic>> _products =
      FirebaseFirestore.instance.collection("products");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _userref.doc(_user!.uid).collection("Favourites").get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                //  Map<String, dynamic> data1 =
                //    snapshot.data!.data() as Map<String, dynamic>;

                return ListView(
                  padding: const EdgeInsets.only(top: 108.0, bottom: 20),
                  children: snapshot.data!.docs.map((document) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProductPage(
                                  productid: document.id,
                                )));
                      },
                      child: FutureBuilder(
                        future: _products.doc(document.id).get(),
                        builder: (context, productsnap) {
                          if (productsnap.hasError) {
                            return Container(
                              child:
                                  Center(child: Text("${productsnap.error}")),
                            );
                          }

                          if (productsnap.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic>? _productMap =
                                productsnap.data!.data();

                            //
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 15),
                                    width: 90,
                                    height: 90,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        "${_productMap!["images"]}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${_productMap["name"]}",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                          ),
                                          child: Text(
                                            "\$${_productMap["price"]}",
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Size ${document.get("size")}",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 90,
                                    height: 90,
                                    margin: const EdgeInsets.only(left: 50),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: IconButton(
                                        onPressed: () {
                                          print(document.id);
                                          _userref
                                              .doc(_user!.uid)
                                              .collection("Cart")
                                              .doc(document.id)
                                              .delete();
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
              }
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),

          //
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
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(context),
                      child: Container(
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
                    ),
                  const Text(
                    "Favourites",
                    style: Constants.Heading,
                    textAlign: TextAlign.start,
                  ),
                  GestureDetector(
                    onTap: (() => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CartPage(),
                          ),
                        )),
                    child: Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: StreamBuilder(
                            stream: _userref
                                .doc(_user!.uid)
                                .collection("Favourites")
                                .snapshots(),
                            builder: (context, snapshot) {
                              int _totalitems = 0;

                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                List _documents = snapshot.data!.docs;
                                _totalitems = _documents.length;
                              }
                              return Text(
                                "${_totalitems}" ?? "0",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              );
                            }),
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
