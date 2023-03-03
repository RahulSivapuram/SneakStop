import 'package:ecomapp/screens/onboardmodel.dart';
import 'package:ecomapp/screens/screen1.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class Onboardingcontroller {
  var pageindex = 0.obs;
  var pagecontroller = PageController();
  bool get lastindex => pageindex == pages.length - 1;

  forwardAction() {
    if (lastindex) {
      Get.to(Screen1());
    } else {
      pagecontroller.nextPage(duration: 300.milliseconds, curve: Curves.ease);
    }
  }

  List<OnboardInfo> pages = [
    OnboardInfo('lib/assets/nike_heart_logo_embroidery_design.jpg.mst.webp',
        "Choose your product", ""),
    OnboardInfo('lib/assets/order.png', "Order Your Shoe", ""),
    OnboardInfo('lib/assets/deliver.png', "Quick Delivery", ""),
  ];
}
