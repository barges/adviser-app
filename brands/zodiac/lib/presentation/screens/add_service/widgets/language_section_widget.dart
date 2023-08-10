import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_delete_alert.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/checkbox_widget.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_cubit.dart';

class LanguageSectionWidget extends StatelessWidget {
  final int selectedLanguageIndex;

  const LanguageSectionWidget({
    Key? key,
    required this.selectedLanguageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AddServiceCubit addServiceCubit = context.read<AddServiceCubit>();

    final List<String>? languagesList =
        context.select((AddServiceCubit cubit) => cubit.state.languagesList);

    final int? mainLanguageIndex = context
        .select((AddServiceCubit cubit) => cubit.state.mainLanguageIndex);

    final bool isMain = selectedLanguageIndex == mainLanguageIndex;

    if (languagesList != null) {
      final bool deleteEnabled = languagesList.length > 1;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScreenPadding,
              ),
              child: Row(
                children: [
                  ...languagesList
                      .mapIndexed(
                        (index, element) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: _LanguageButton(
                            key: addServiceCubit.localesGlobalKeys[index],
                            title: addServiceCubit.localeNativeName(element),
                            isSelected: selectedLanguageIndex == index,
                            isMain: mainLanguageIndex == index,
                            deleteEnabled: deleteEnabled,
                            setIsSelected: () =>
                                addServiceCubit.changeLocaleIndex(index),
                            removeLocale: () =>
                                addServiceCubit.removeLocale(element),
                          ),
                        ),
                      )
                      .toList(),
                  GestureDetector(
                    onTap: () => addServiceCubit.goToAddNewLocale(context),
                    child: Container(
                      height: 38.0,
                      width: 38.0,
                      decoration: BoxDecoration(
                        color: theme.canvasColor,
                        borderRadius: BorderRadius.circular(
                          AppConstants.buttonRadius,
                        ),
                      ),
                      child: Center(
                        child: Assets.vectors.add.svg(
                          height: 24.0,
                          width: 24.0,
                          colorFilter: ColorFilter.mode(
                            theme.primaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 9.0,
              horizontal: AppConstants.horizontalScreenPadding,
            ),
            child: Opacity(
              opacity: mainLanguageIndex == null || isMain ? 1.0 : 0.6,
              child: Row(
                children: [
                  CheckboxWidget(
                    value: isMain,
                    onChanged: (value) => mainLanguageIndex == null || isMain
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
            ),
          )
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _LanguageButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final bool isMain;
  final VoidCallback setIsSelected;
  final VoidCallback removeLocale;
  final bool deleteEnabled;

  const _LanguageButton({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.isMain,
    required this.setIsSelected,
    required this.removeLocale,
    required this.deleteEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      height: 38.0,
      decoration: BoxDecoration(
        color: isSelected ? theme.primaryColorLight : theme.canvasColor,
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
      ),
      child: Row(children: [
        GestureDetector(
          onTap: setIsSelected,
          child: Row(
            children: [
              const SizedBox(
                width: 24.0,
              ),
              Text(
                title,
                style: isSelected
                    ? theme.textTheme.labelMedium
                        ?.copyWith(fontSize: 15.0, color: theme.primaryColor)
                    : theme.textTheme.bodyMedium,
              ),
              if (isMain)
                Row(
                  children: [
                    const SizedBox(
                      width: 4.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: theme.scaffoldBackgroundColor,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 2.0),
                      child: Text(
                        SZodiac.of(context).mainZodiac.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 12.0,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(
                width: 24.0,
              ),
            ],
          ),
        ),
        if (!isMain && deleteEnabled)
          GestureDetector(
            onTap: () async {
              final bool? shouldDelete = await showDeleteAlert(
                  context,
                  SZodiac.of(context)
                      .doYouReallyWantToDeleteLocaleNameFromYourListZodiac(
                          '"$title"'));

              if (shouldDelete == true) {
                removeLocale();
              }
            },
            child: Row(
              children: [
                const VerticalDivider(
                  width: 1.0,
                  thickness: 1.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Assets.vectors.delete.svg(
                    height: AppConstants.iconSize,
                    width: AppConstants.iconSize,
                    color:
                        isSelected ? theme.primaryColor : theme.iconTheme.color,
                  ),
                ),
              ],
            ),
          ),
      ]),
    );
  }
}
