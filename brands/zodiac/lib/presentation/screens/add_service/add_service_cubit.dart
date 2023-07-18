import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/user_info/locale_model.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_state.dart';

class AddServiceCubit extends Cubit<AddServiceState> {
  final ZodiacCachingManager _cachingManager;

  late List<GlobalKey> localesGlobalKeys;

  AddServiceCubit(this._cachingManager) : super(const AddServiceState()) {
    emit(state.copyWith(languagesList: ['en', 'es']));

    localesGlobalKeys =
        List.generate(state.languagesList?.length ?? 0, (index) => GlobalKey());
  }

  void goToAddNewLocale(BuildContext context) {
    context.push(
      route: ZodiacLocalesList(
        title: SZodiac.of(context).serviceLanguageZodiac,
        unnecessaryLocalesCodes: state.languagesList,
        returnCallback: (locale) {
          _addLocaleLocally(locale);
        },
      ),
    );
  }

  String localeNativeName(String code) {
    List<LocaleModel>? locales = _cachingManager.getAllLocales();

    return locales
            ?.firstWhere((element) => element.code == code,
                orElse: () => const LocaleModel())
            .nameNative ??
        '';
  }

  void changeLocaleIndex(int newIndex) {
    emit(state.copyWith(selectedLanguageIndex: newIndex));
    Utils.animateToWidget(localesGlobalKeys[newIndex]);
  }

  void _addLocaleLocally(String localeCode) {
    final List<String> locales = List.from(state.languagesList ?? []);
    locales.add(localeCode);
    _setNewLocaleProperties(localeCode);

    emit(state.copyWith(languagesList: locales));

    final codeIndex = locales.indexOf(localeCode);
    if (codeIndex != -1) {
      changeLocaleIndex(codeIndex);
    }
  }

  void _setNewLocaleProperties(String localeCode) {
    localesGlobalKeys.add(GlobalKey());
  }

  void setMainLanguage(int index) {
    if (state.mainLanguageIndex == index) {
      emit(state.copyWith(mainLanguageIndex: null));
    } else {
      emit(state.copyWith(mainLanguageIndex: index));
    }
  }

  Future<void> removeLocale(String localeCode) async {
    _removeLocaleLocally(localeCode);
  }

  void _removeLocaleLocally(String localeCode) {
    final List<String> locales = List.of(state.languagesList ?? []);
    final codeIndex = locales.indexOf(localeCode);
    int newLocaleIndex = state.selectedLanguageIndex;

    if (codeIndex <= newLocaleIndex && codeIndex != 0) {
      newLocaleIndex = newLocaleIndex - 1;
    }
    _removeLocaleProperties(localeCode);

    locales.remove(localeCode);

    emit(state.copyWith(
      languagesList: List.of(locales),
      selectedLanguageIndex: newLocaleIndex,
    ));
  }

  void _removeLocaleProperties(String localeCode) {
    localesGlobalKeys.removeAt(state.languagesList?.indexOf(localeCode) ?? 0);
  }
}
