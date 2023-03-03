import 'package:ecomapp/view/bookmarks.dart';
import 'package:ecomapp/view/homeview.dart';
import 'package:ecomapp/view/searchview.dart';
import 'package:ecomapp/view/signout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  //
  int sindex = 0;
  //

  //
  static const List<Widget> wo = <Widget>[
    HomeView(),
    SearchView(),
    BookmarksView(),
    SignOut(),
  ];

  void _onsingletap(int index) {
    setState(() {
      sindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                child: wo.elementAt(sindex),
              ),
            ),
            BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: sindex == 0 ? Colors.orange : Colors.white),
                      ),
                    ),
                    child: Icon(
                      Icons.home,
                      color: sindex == 0 ? Colors.orange : Colors.black,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: sindex == 1 ? Colors.orange : Colors.white),
                      ),
                    ),
                    child: Icon(
                      Icons.search_rounded,
                      color: sindex == 1 ? Colors.orange : Colors.black,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: sindex == 2 ? Colors.orange : Colors.white),
                      ),
                    ),
                    child: Icon(
                      Icons.bookmark_add_outlined,
                      color: sindex == 2 ? Colors.orange : Colors.black,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: sindex == 3 ? Colors.orange : Colors.white),
                      ),
                    ),
                    child: Icon(
                      Icons.logout_outlined,
                      color: sindex == 3 ? Colors.orange : Colors.black,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  label: "",
                ),
              ],
              currentIndex: sindex,
              selectedItemColor: Colors.orange,
              onTap: _onsingletap,
            ),
          ],
        ),
      ),
    );
  }
}
