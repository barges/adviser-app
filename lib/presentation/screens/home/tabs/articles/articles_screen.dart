import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/simple_app_bar.dart';

class ArticlesScreen extends GetView {
  const ArticlesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: 'Articles',
      ),
      body: SizedBox(
        height: Get.height,
        child: GestureDetector(
          onTap: () {
          },
          child: const Center(
            child: Text('Articles'),
          ),
        ),
      ),
    );
  }
}
