import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/presentation/screens/edit_profile/edit_profile_cubit.dart';

class LanguagesButtons extends StatelessWidget {
  final List<String> locales;
  final ValueChanged<int> onTapToLocale;
  final VoidCallback addLocaleOnTap;
  final int? currentLocaleIndex;

  const LanguagesButtons({
    Key? key,
    required this.currentLocaleIndex,
    required this.locales,
    required this.onTapToLocale,
    required this.addLocaleOnTap,
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
                final GlobalKey key = editProfileCubit.localesGlobalKeys[index];

                if (index < locales.length - 1) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _LanguageButton(
                      key: key,
                      title: editProfileCubit.localeNativeName(element),
                      isSelected: isSelected,
                      onTap: isSelected ? null : () => onTapToLocale(index),
                    ),
                  );
                } else {
                  return Row(
                    children: [
                      _LanguageButton(
                        key: key,
                        onTap: isSelected ? null : () => onTapToLocale(index),
                        title: editProfileCubit.localeNativeName(element),
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
  final VoidCallback? onTap;
  final String title;
  final bool isSelected;
  final bool isMain;

  const _LanguageButton({
    Key? key,
    required this.onTap,
    required this.title,
    required this.isSelected,
    this.isMain = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38.0,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: isSelected
              ? theme.primaryColorLight
              : theme.canvasColor,
        ),
        child: Text(
          title,
          style: isSelected
              ? theme.textTheme.labelMedium?.copyWith(
                    color: theme.primaryColor,
                    fontSize: 15.0,
                  )
              : theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color,
                  ),
        ),
      ),
    );
  }
}
