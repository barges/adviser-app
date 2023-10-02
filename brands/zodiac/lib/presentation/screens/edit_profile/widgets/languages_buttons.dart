import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_delete_alert.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/edit_profile/edit_profile_cubit.dart';

class LanguagesButtons extends StatelessWidget {
  final List<String> locales;
  final ValueChanged<int> onTapToLocale;
  final VoidCallback addLocaleOnTap;
  final int? currentLocaleIndex;
  final int selectedBrandIndex;

  const LanguagesButtons({
    Key? key,
    required this.currentLocaleIndex,
    required this.locales,
    required this.onTapToLocale,
    required this.addLocaleOnTap,
    required this.selectedBrandIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditProfileCubit editProfileCubit = context.read<EditProfileCubit>();
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalScreenPadding,
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: locales.mapIndexed<Widget>(
              (index, element) {
                final bool isSelected = index == currentLocaleIndex;
                final GlobalKey key = editProfileCubit
                    .localesGlobalKeys[selectedBrandIndex][index];

                logger.d('Keyy: $key');

                ///TODO - Refactoring
                final bool isMainLocale = true;
                // element == editProfileCubit.state.advisorMainLocale;

                if (index < locales.length - 1) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _LanguageButton(
                      key: key,
                      editProfileCubit: editProfileCubit,
                      localeCode: element,
                      isSelected: isSelected,
                      isMain: isMainLocale,
                      onTap: isSelected ? null : () => onTapToLocale(index),
                    ),
                  );
                } else {
                  return Row(
                    children: [
                      _LanguageButton(
                        key: key,
                        editProfileCubit: editProfileCubit,
                        onTap: isSelected ? null : () => onTapToLocale(index),
                        localeCode: element,
                        isMain: isMainLocale,
                        isSelected: isSelected,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      GestureDetector(
                        onTap: addLocaleOnTap,
                        child: Container(
                          height: 38.0,
                          width: 38.0,
                          decoration: BoxDecoration(
                              color: theme.canvasColor,
                              borderRadius: BorderRadius.circular(
                                AppConstants.buttonRadius,
                              )),
                          child: Center(
                            child: Assets.vectors.add.svg(
                              height: 24.0,
                              width: 24.0,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }
              },
            ).toList()),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final EditProfileCubit editProfileCubit;
  final VoidCallback? onTap;
  final String localeCode;
  final bool isSelected;
  final bool isMain;

  const _LanguageButton({
    Key? key,
    required this.editProfileCubit,
    required this.onTap,
    required this.localeCode,
    required this.isSelected,
    this.isMain = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String localeName = editProfileCubit.localeNativeName(localeCode);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: isSelected ? theme.primaryColorLight : theme.canvasColor,
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 24.0,
            ),
            Text(
              localeName,
              style: isSelected
                  ? theme.textTheme.labelMedium?.copyWith(
                      color: theme.primaryColor,
                      fontSize: 15.0,
                    )
                  : theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color,
                    ),
            ),
            const SizedBox(
              width: 24.0,
            ),
            if (!isMain)
              GestureDetector(
                onTap: () async {
                  final bool? needDelete =
                      await _deleteLocaleAlert(context, localeName);
                  if (needDelete == true) {
                    editProfileCubit.removeLocale(localeCode);
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
                        color: isSelected
                            ? theme.primaryColor
                            : theme.iconTheme.color,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _deleteLocaleAlert(
      BuildContext context, String localeName) async {
    return await showDeleteAlert(
      context,
      SZodiac.of(context)
          .doYouReallyWantToDeleteLocaleNameFromYourListZodiac(localeName),
    );
  }
}
