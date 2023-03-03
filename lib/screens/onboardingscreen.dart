import 'package:ecomapp/screens/onboardingcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Onboardingscreen extends StatelessWidget {
  final _controller = Onboardingcontroller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller.pagecontroller,
              onPageChanged: _controller.pageindex,
              itemCount: _controller.pages.length,
              itemBuilder: ((context, index) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        _controller.pages[index].imageasset,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Text(
                        _controller.pages[index].title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        _controller.pages[index].description,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                );
              }),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Row(
                children: List.generate(
                  _controller.pages.length,
                  (index) => Obx(
                    () {
                      return Container(
                        margin: const EdgeInsets.all(4),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                            color: _controller.pageindex.value == index
                                ? Colors.red
                                : Colors.black,
                            shape: BoxShape.circle),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton(
                elevation: 1,
                onPressed: _controller.forwardAction,
                child: Obx(() {
                  return Text(_controller.lastindex ? "Start" : "Next");
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
