import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerController extends GetxController {
  static DrawerController instance = Get.find<DrawerController>();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var homeScaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    // if (authController.isLoggedIn.value) {
    scaffoldKey.currentState?.openDrawer();
    // } else {
    //   homeScaffoldKey.currentState?.openDrawer();
    // }
  }

  void closeDrawer() {
    // if (authController.isLoggedIn.value) {
    scaffoldKey.currentState?.closeDrawer();
    // } else {
    //   homeScaffoldKey.currentState?.closeDrawer();
    // }
  }
}
