import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class ChangeLocaleButton extends StatefulWidget {
  const ChangeLocaleButton({Key? key}) : super(key: key);

  @override
  State<ChangeLocaleButton> createState() => _ChangeLocaleButtonState();
}

class _ChangeLocaleButtonState extends State<ChangeLocaleButton> {
  int _localeIndex = 0;

  @override
  void initState() {
    super.initState();
    _localeIndex = Get.find<CacheManager>().getLocaleIndex() ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: InkResponse(
        onTap: () => _showDialog(),
        child: Container(
          height: 32.0,
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 6.0,
            vertical: 4.0,
          ),
          child: Row(
            children: [
              Text(
                Intl.getCurrentLocale().capitalize ?? '',
                style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500, color: Get.theme.primaryColor),
              ),
              const SizedBox(width: 4.0),
              Assets.vectors.globe.svg(
                color: Get.theme.primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          final FixedExtentScrollController controller =
              FixedExtentScrollController(
            initialItem: _localeIndex,
          );
          final List<Locale> locales = S.delegate.supportedLocales;
          return Material(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 52.0,
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
                          height: 52.0,
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
                          _localeIndex = controller.selectedItem;
                          _changeLocale();
                          Get.back();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 52.0,
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
                  padding: const EdgeInsets.symmetric(
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
                      children: locales.mapIndexed((element, index) {
                        return Center(
                          child: GestureDetector(
                            onTap: () {
                              controller.jumpToItem(index);
                            },
                            child: Text(
                              element.languageCode.languageNameByCode,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _changeLocale() {
    final Locale locale = S.delegate.supportedLocales[_localeIndex];
    Get.updateLocale(
        Locale(locale.languageCode, locale.languageCode.toUpperCase()));
    Get.find<CacheManager>().saveLocaleIndex(_localeIndex);
  }
}
