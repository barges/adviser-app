import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/base_screen/listening_brand_controller.dart';

abstract class ListeningBrandGetView<T extends ListeningBrandController>
    extends GetView<T> {
  const ListeningBrandGetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return mainBody(context);
  }

  Widget body(BuildContext context);

  @protected
  Widget mainBody(BuildContext context) => body(context);
}
