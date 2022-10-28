import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/picker_modal_pop_up.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';

class ChangeLocaleButton extends StatelessWidget {
  const ChangeLocaleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String languageCode = Intl.getCurrentLocale();
    final List<String> locales =
        S.delegate.supportedLocales.map((e) => e.languageCode).toList();
    final int currentLocaleIndex =
        !locales.contains(languageCode) ? 0 : locales.indexOf(languageCode);

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: InkResponse(
        onTap: () => showPickerModalPopUp(
          context: context,
          setIndex: Utils.changeLocale,
          currentIndex: currentLocaleIndex,
          elements: locales.map((element) {
            return Center(
              child: Text(
                element.languageNameByCode,
              ),
            );
          }).toList(),
        ),
        child: Container(
          height: AppConstants.iconButtonSize,
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
}
