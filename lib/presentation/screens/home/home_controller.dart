import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt tabPositionIndex = 0.obs;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}
