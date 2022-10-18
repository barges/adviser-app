import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

void showPickerModalPopUp({
  required BuildContext context,
  required ValueChanged<int> setIndex,
  required List<Widget> elements,
  int? currentIndex,
}) {
  showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        final FixedExtentScrollController controller =
            FixedExtentScrollController(
          initialItem: currentIndex ?? 0,
        );

        return Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: AppConstants.appBarHeight,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalScreenPadding,
                ),
                color: Get.theme.scaffoldBackgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: Get.back,
                      child: Container(
                        alignment: Alignment.center,
                        height: AppConstants.appBarHeight,
                        color: Colors.transparent,
                        child: Text(
                          S.of(context).cancel,
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: Get.theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setIndex(controller.selectedItem);
                        Get.back();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: AppConstants.appBarHeight,
                        color: Colors.transparent,
                        child: Text(
                          S.of(context).done,
                          style: Get.textTheme.labelMedium?.copyWith(
                            fontSize: 15.0,
                            color: Get.theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 216.0,
                margin: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
                color: Get.theme.canvasColor,
                child: SafeArea(
                  top: false,
                  child: CupertinoPicker(
                    scrollController: controller,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: 34.0,
                    onSelectedItemChanged: null,
                    children: elements,
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
