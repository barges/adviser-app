import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/picker_modal_pop_up.dart';
import 'package:zodiac/data/network/requests/update_locale_request.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/zodiac.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class ChangeLocaleButton extends StatelessWidget {
  const ChangeLocaleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String languageCode = Intl.getCurrentLocale();
    final List<String> locales =
        SZodiac.delegate.supportedLocales.map((e) => e.languageCode).toList();
    locales.removeWhere((element) => element == 'de');
    final int currentLocaleIndex =
        !locales.contains(languageCode) ? 0 : locales.indexOf(languageCode);

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: InkResponse(
        onTap: () => showPickerModalPopUp(
          context: context,
          setIndex: (index) async {
            final String languageCode = locales[index];
            final String? oldLanguageCode = zodiacGetIt
                .get<GlobalCachingManager>().getLanguageCode();
            if(languageCode != oldLanguageCode) {
              zodiacGetIt
                  .get<GlobalCachingManager>()
                  .saveLanguageCode(languageCode);
              ZodiacBrand().languageCode = languageCode;
              if (ZodiacBrand().isAuth) {
                await zodiacGetIt
                    .get<ZodiacUserRepository>()
                    .updateLocale(UpdateLocaleRequest(locale: languageCode));
                zodiacGetIt
                    .get<ZodiacMainCubit>().updateAccount();
              }
            }
          },
          currentIndex: currentLocaleIndex,
          elements: locales.map((element) {
            return Center(
              child: Text(
                element.languageNameByCode(context),
              ),
            );
          }).toList(),
        ),
        child: Container(
          height: AppConstants.iconButtonSize,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 4.0),
              Assets.vectors.globe.svg(
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
