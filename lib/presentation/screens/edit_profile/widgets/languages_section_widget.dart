import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_text_field.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageSectionWidget extends StatelessWidget {
  const LanguageSectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditProfileCubit editProfileCubit = context.read<EditProfileCubit>();
    final int chosenLanguageIndex = context
        .select((EditProfileCubit cubit) => cubit.state.chosenLanguageIndex);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 24.0),
          height: 38.0,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScreenPadding),
            itemBuilder: (BuildContext context, int index) {
              return _LanguageWidget(
                languageName:
                    editProfileCubit.activeLanguages[index].languageNameByCode,
                isSelected: chosenLanguageIndex == index,
                onTap: () {
                  editProfileCubit.updateCurrentLanguageIndex(index);
                },
              );
            },
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: editProfileCubit.activeLanguages.length,
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
              child: Builder(builder: (context) {
                final bool updateTextsFlag = context.select(
                    (EditProfileCubit cubit) => cubit.state.updateTextsFlag);
                return Column(
                  children: [
                    AppTextField(
                      controller: entry.value.first,
                      errorText:
                          editProfileCubit.errorTextsMap[entry.key]?.first ??
                              '',
                      label: S.of(context).statusText,
                      textInputType: TextInputType.multiline,
                      maxLines: 10,
                      height: 144.0,
                      contentPadding: const EdgeInsets.all(12.0),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    AppTextField(
                      controller: entry.value.last,
                      errorText:
                          editProfileCubit.errorTextsMap[entry.key]?.last ?? '',
                      label: S.of(context).profileText,
                      textInputType: TextInputType.multiline,
                      maxLines: 10,
                      height: 144.0,
                      contentPadding: const EdgeInsets.all(12.0),
                    ),
                  ],
                );
              }),
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
  final VoidCallback? onTap;

  const _LanguageWidget(
      {Key? key,
      required this.languageName,
      this.isSelected = false,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38.0,
        decoration: BoxDecoration(
          color:
              isSelected ? Get.theme.primaryColorLight : Get.theme.canvasColor,
          borderRadius: BorderRadius.circular(
            AppConstants.buttonRadius,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Text(
            languageName,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: isSelected
                  ? Get.theme.primaryColor
                  : Get.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ),
    );
  }
}
