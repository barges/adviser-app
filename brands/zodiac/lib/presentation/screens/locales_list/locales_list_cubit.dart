import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/user_info/locale_model.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/presentation/screens/locales_list/locales_list_state.dart';

class LocalesListCubit extends Cubit<LocalesListState> {
  final ZodiacUserRepository _userRepository;
  final ZodiacCachingManager _cachingManager;
  final String? _oldSelectedLocaleCode;
  final List<String>? unnecessaryLocalesCodes;

  late final List<LocaleModel> _locales;

  LocalesListCubit(
    this._userRepository,
    this._cachingManager,
    this._oldSelectedLocaleCode, {
    this.unnecessaryLocalesCodes,
  }) : super(const LocalesListState()) {
    getAllLocales();
  }

  Future<void> getAllLocales() async {
    List<LocaleModel>? responseLocales;

    if (_cachingManager.haveLocales) {
      responseLocales = _cachingManager.getAllLocales();
    } else {
      responseLocales =
          ((await _userRepository.getAllLocales(AuthorizedRequest())).result);
      if (responseLocales != null) {
        _cachingManager.saveAllLocales(responseLocales);
      }
    }

    if (responseLocales != null) {
      if (unnecessaryLocalesCodes != null) {
        for (String code in unnecessaryLocalesCodes!) {
          responseLocales.removeWhere((element) => element.code == code);
        }
      }
      _locales = responseLocales;
      emit(state.copyWith(
        locales: responseLocales,
        selectedLocaleCode: _oldSelectedLocaleCode,
      ));
    }
  }

  void search(String text) {
    List<LocaleModel> locales = _locales
        .where((element) =>
            element.nameNative?.toLowerCase().startsWith(text.toLowerCase()) ??
            false)
        .toList();

    emit(state.copyWith(
      locales: locales,
    ));
  }

  void tapToLocale(int index) {
    final List<LocaleModel> allLocales = state.locales;
    if (index < allLocales.length) {
      final String? localeCode = allLocales[index].code;

      if (localeCode != null) {
        emit(state.copyWith(
          selectedLocaleCode: localeCode,
        ));
      }
    }
  }
}
