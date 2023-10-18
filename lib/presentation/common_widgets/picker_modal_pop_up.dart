import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../infrastructure/routing/app_router.dart';
import '../../app_constants.dart';
import '../../generated/l10n.dart';

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
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: context.pop,
                      child: Container(
                        alignment: Alignment.center,
                        height: AppConstants.appBarHeight,
                        color: Colors.transparent,
                        child: Text(
                          SFortunica.of(context).cancel,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setIndex(controller.selectedItem);
                        context.pop();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: AppConstants.appBarHeight,
                        color: Colors.transparent,
                        child: Text(
                          SFortunica.of(context).done,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontSize: 15.0,
                                    color: Theme.of(context).primaryColor,
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
                color: Theme.of(context).canvasColor,
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
