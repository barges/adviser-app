import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/checkbox_widget.dart';
import 'package:zodiac/presentation/common_widgets/service/service_languages_widget.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_cubit.dart';

class LanguageSectionWidget extends StatelessWidget {
  final int selectedLanguageIndex;
  final List<String> languagesList;

  const LanguageSectionWidget({
    Key? key,
    required this.selectedLanguageIndex,
    required this.languagesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddServiceCubit addServiceCubit = context.read<AddServiceCubit>();

    final int? mainLanguageIndex = context
        .select((AddServiceCubit cubit) => cubit.state.mainLanguageIndex);

    final bool isMain = selectedLanguageIndex == mainLanguageIndex;

    final bool deleteEnabled = languagesList.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ServiceLanguagesWidget(
          languagesList: languagesList,
          languagesGlobalKeys: addServiceCubit.localesGlobalKeys,
          titleFormatter: addServiceCubit.localeNativeName,
          selectedLanguageIndex: selectedLanguageIndex,
          mainLanguageIndex: mainLanguageIndex,
          deleteEnabled: deleteEnabled,
          setIsSelected: addServiceCubit.changeLocaleIndex,
          removeLanguage: addServiceCubit.removeLocale,
          addNewLanguage: () => addServiceCubit.goToAddNewLocale(context),
          errorTextsMap: addServiceCubit.errorTextsMap,
        ),
        const SizedBox(
          height: 8.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 9.0,
            horizontal: AppConstants.horizontalScreenPadding,
          ),
          child: Builder(builder: (context) {
            final bool selectingMainLanguageIsEnabled =
                (mainLanguageIndex == null || isMain) &&
                    languagesList.length > 1;
            return Opacity(
              opacity: selectingMainLanguageIsEnabled ? 1.0 : 0.6,
              child: Row(
                children: [
                  CheckboxWidget(
                    value: isMain,
                    onChanged: (value) => selectingMainLanguageIsEnabled
                        ? addServiceCubit.setMainLanguage(selectedLanguageIndex)
                        : {},
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Text(SZodiac.of(context).setAsMainLanguageZodiac,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(fontSize: 16.0))
                ],
              ),
            );
          }),
        )
      ],
    );
  }
}
