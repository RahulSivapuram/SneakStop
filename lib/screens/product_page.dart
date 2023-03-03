import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomapp/screens/cart.dart';

import 'package:ecomapp/widget/product_size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../constants.dart';

class ProductPage extends StatefulWidget {
  final String productid;
  const ProductPage({super.key, required this.productid});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final bool hasbackarrow = true;
  final CollectionReference _products =
      FirebaseFirestore.instance.collection("products");
  //

  final CollectionReference _userref =
      FirebaseFirestore.instance.collection("users");

  User? _user = FirebaseAuth.instance.currentUser;
  //
  Future _addcart() {
    return _userref
        .doc(_user!.uid)
        .collection("Cart")
        .doc(widget.productid)
        .set({"size": _selectedsize});
  }

  Future _addfav() {
    return _userref
        .doc(_user!.uid)
        .collection("Favourites")
        .doc(widget.productid)
        .set({"size": _selectedsize});
  }

//

  String _selectedsize = "0";

  //
  final _razorpay = Razorpay();

  @override
  void initState() {
    // TODO: implement initState
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: _products.doc(widget.productid).get(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error :${snapshot.error}"),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> documentdata = snapshot.data.data();

                List sdata = documentdata["size"];
                _selectedsize = sdata[0];
                return ListView(
                  children: [
                    Image.network("${documentdata['images']}"),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 24, bottom: 4, left: 24, right: 24),
                      child: Text(
                        "${documentdata["name"]}",
                        style: Constants.bHeading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 24),
                      child: Text(
                        "${documentdata["price"]}",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 24),
                      child: SingleChildScrollView(
                        child: Text(
                          "${documentdata["description"]}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 24),
                      child: Text("Select Size"),
                    ),
                    ProductSize(
                      pros: sdata,
                      onselected: (size) {
                        _selectedsize = size;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await _addfav();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('product added to favourites')));
                            },
                            child: Container(
                              width: 65.0,
                              height: 65.0,
                              decoration: BoxDecoration(
                                color: Color(0xFFDCDCDC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage("lib/assets/saved.jpg"),
                                height: 22.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await _addcart();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('product added to cart'),
                                ));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 16.0),
                                height: 65.0,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Center(
                                  child: Text(
                                    "Add To Cart",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        var options = {
                          'key': 'rzp_test_hWZbyw9mwPvNgA',
                          'amount': '${documentdata['price']}',
                          'name': 'Rahul',
                          'description': 'payment',
                          'prefill': {
                            'contact': "9176867689",
                            "email": "contact@protocoderspoint.com"
                          },
                        };
                        try {
                          _razorpay.open(options);
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 25, right: 25),
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Buy Now",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
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
          //custom action bar
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
                  /*
                  const Text(
                    "ACTION BAR",
                    style: Constants.Heading,
                    textAlign: TextAlign.start,
                  ),*/
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
                                .collection("Cart")
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(
        'Payment success  ${response.paymentId} ${response.orderId} ${response.signature}');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: Text(
            'payment id: ${response.paymentId} ${response.orderId} ${response.signature}'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok"))
        ],
      ),
    );
    _razorpay.clear();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment error: ${response.code}-${response.message}');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("error"),
        content: Text('code: ${response.code} - Message: ${response.message} '),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Ok"),
          )
        ],
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print('External wallet is: ${response.walletName}');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("External wallet"),
        content: Text('Wallet name: ${response.walletName}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Ok"),
          )
        ],
      ),
    );
  }
}
