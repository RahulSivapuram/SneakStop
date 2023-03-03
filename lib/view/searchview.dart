import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomapp/constants.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../screens/product_page.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final CollectionReference _productref =
      FirebaseFirestore.instance.collection("products");

  String _searchstring = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if (_searchstring.isEmpty)
            Container(child: Center(child: Text("Search Results")))
          else
            FutureBuilder<QuerySnapshot>(
                future: _productref.orderBy("name").startAt(
                    [_searchstring]).endAt(["$_searchstring\uf8ff"]).get(),
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

          //  ///
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
              decoration: BoxDecoration(
                color: Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search..",
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                ),
                style: Constants.Heading,
                onSubmitted: (value) {
                  setState(() {
                    _searchstring = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
