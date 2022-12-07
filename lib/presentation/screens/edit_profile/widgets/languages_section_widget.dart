import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/error_badge.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_cubit.dart';

class LanguageSectionWidget extends StatelessWidget {
  const LanguageSectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditProfileCubit editProfileCubit = context.read<EditProfileCubit>();
    final int chosenLanguageIndex = context
        .select((EditProfileCubit cubit) => cubit.state.chosenLanguageIndex);
    context.select((EditProfileCubit cubit) => cubit.state.updateTextsFlag);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 24.0),
          height: 38.0,
          child: ListView.separated(
            controller: editProfileCubit.languagesScrollController,
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScreenPadding),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: editProfileCubit.activeLanguages.length,
            itemBuilder: (BuildContext context, int index) {
              final MarketsType languageCode =
                  editProfileCubit.activeLanguages[index];
              return _LanguageWidget(
                key: editProfileCubit.activeLanguagesGlobalKeys[index],
                languageName: languageCode.languageName(context),
                isSelected: chosenLanguageIndex == index,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  editProfileCubit.changeCurrentLanguageIndex(index);
                },
                withError: editProfileCubit
                            .errorTextsMap[languageCode]?.first.isNotEmpty ==
                        true ||
                    editProfileCubit
                            .errorTextsMap[languageCode]?.last.isNotEmpty ==
                        true,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                width: 6.0,
              );
            },
          ),
        ),
        IndexedStack(
          index: chosenLanguageIndex,
          children: editProfileCubit.textControllersMap.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalScreenPadding),
              child: Column(
                children: [
                  ValueListenableBuilder(
                      valueListenable: editProfileCubit
                          .hasFocusNotifiersMap[entry.key]!.first,
                      builder: (context, value, child) {
                        return AppTextField(
                          controller: entry.value.first,
                          focusNode:
                              editProfileCubit.focusNodesMap[entry.key]!.first,
                          errorText: editProfileCubit
                                  .errorTextsMap[entry.key]?.first ??
                              '',
                          label: S.of(context).statusText,
                          textInputType: TextInputType.multiline,
                          isBig: true,
                        );
                      }),
                  const SizedBox(
                    height: 24.0,
                  ),
                  ValueListenableBuilder(
                      valueListenable: editProfileCubit
                          .hasFocusNotifiersMap[entry.key]!.last,
                      builder: (context, value, child) {
                        return AppTextField(
                          controller: entry.value.last,
                          focusNode:
                              editProfileCubit.focusNodesMap[entry.key]!.last,
                          errorText:
                              editProfileCubit.errorTextsMap[entry.key]?.last ??
                                  '',
                          label: S.of(context).profileText,
                          textInputType: TextInputType.multiline,
                          isBig: true,
                        );
                      }),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _LanguageWidget extends StatelessWidget {
  final String languageName;
  final bool isSelected;
  final bool withError;
  final VoidCallback? onTap;

  const _LanguageWidget({
    Key? key,
    required this.languageName,
    this.onTap,
    this.isSelected = false,
    this.withError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 38.0,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColorLight
                  : Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(
                AppConstants.buttonRadius,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: Text(
                languageName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
              ),
            ),
          ),
          if (withError)
            const Positioned(
              right: 0.0,
              child: ErrorBadge(),
            )
        ],
      ),
    );
  }
}
