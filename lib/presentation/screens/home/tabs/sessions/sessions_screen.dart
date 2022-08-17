import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/simple_app_bar.dart';

class SessionsScreen extends GetView {
  const SessionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: 'Sessions',
      ),
      body: SizedBox(
        height: Get.height,
        child: GestureDetector(
          onTap: () {
            logger.d(Get.find<CacheManager>().getToken());
          },
          child: const Center(
            child: Text('Sessions'),
          ),
        ),
      ),
    );
  }
}
