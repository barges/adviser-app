import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_loading_indicator.dart';

abstract class RunnableGetView<T extends RunnableController>
    extends GetView<T> {
  const RunnableGetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

  Widget body(BuildContext context);
}

abstract class RunnableController extends GetxController {
  final RxBool isLoading = false.obs;

  Future<T> run<T>(Future<T> future) async {
    isLoading.value = true;
    try {
      final result = await future;
      return result;
    } on DioError catch (e) {
      isLoading.value = false;
      return Future.error(e);
    } catch (e) {
      isLoading.value = false;
      return Future.error(e);
    } finally {
      isLoading.value = false;
    }
  }
}
