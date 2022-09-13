import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_loading_indicator.dart';
import 'package:shared_advisor_interface/presentation/base_screen/listening_brand_screen.dart';
import 'package:shared_advisor_interface/presentation/base_screen/runnable_controller.dart';

abstract class RunnableGetView<T extends RunnableController>
    extends ListeningBrandGetView<T> {
  const RunnableGetView({Key? key}) : super(key: key);

  @override
  Widget mainBody(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        body(context),
        Obx(
          () => controller.isLoading.value
              ? const AppLoadingIndicator()
              : const SizedBox.shrink(),
        )
      ],
    );
  }
}
