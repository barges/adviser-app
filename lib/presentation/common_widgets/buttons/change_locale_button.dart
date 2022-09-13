import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_icons.dart';

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
        onTap: changeLocale,
        child: Container(
          height: 32.0,
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
            children: [
              SvgPicture.asset(
                AppIcons.languages,
                color: Get.theme.primaryColor,
                width: 20.0,
                height: 20.0,
              ),
              const SizedBox(
                width: 6.0,
              ),
              Text(
                Intl.getCurrentLocale().capitalize ?? '',
                style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500, color: Get.theme.primaryColor),
              )
            ],
          ),
        ),
      ),
    );
  }

  void changeLocale() {
    Locale locale;
    if (_localeIndex < S.delegate.supportedLocales.length - 1) {
      locale = S.delegate.supportedLocales[++_localeIndex];
      Get.updateLocale(
          Locale(locale.languageCode, locale.languageCode.toUpperCase()));
    } else {
      _localeIndex = 0;
      locale = S.delegate.supportedLocales[_localeIndex];
      Get.updateLocale(
          Locale(locale.languageCode, locale.languageCode.toUpperCase()));
    }
    Get.find<CacheManager>().saveLocaleIndex(_localeIndex);
  }
}
