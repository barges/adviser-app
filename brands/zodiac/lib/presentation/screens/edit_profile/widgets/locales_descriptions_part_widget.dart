import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:zodiac/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:zodiac/presentation/screens/edit_profile/widgets/languages_buttons.dart';

class LocalesDescriptionsPartWidget extends StatelessWidget {
  final int brandIndex;

  const LocalesDescriptionsPartWidget({
    Key? key,
    required this.brandIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditProfileCubit editProfileCubit = context.read<EditProfileCubit>();
    final List<String> locales = context.select(
        (EditProfileCubit cubit) => cubit.state.brandLocales[brandIndex]);

    final int currentLocaleIndex = context.select((EditProfileCubit cubit) =>
        cubit.state.currentLocaleIndexes[brandIndex]);

    context.select<EditProfileCubit, bool>(
        (EditProfileCubit cubit) => cubit.state.updateTextsFlag);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0.0,
        24.0,
        0.0,
        24.0 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LanguagesButtons(
            currentLocaleIndex: currentLocaleIndex,
            onTapToLocale: (index) {
              FocusScope.of(context).unfocus();
              editProfileCubit.changeLocaleIndex(index);
            },
            locales: locales,
            addLocaleOnTap: () => editProfileCubit.goToAddNewLocale(context),
            brandIndex: brandIndex,
          ),
          const SizedBox(
            height: 24.0,
          ),
          IndexedStack(
            index: currentLocaleIndex,
            children: editProfileCubit.textControllersMap[brandIndex].entries
                .map((entry) {
              return Column(
                children: [
                  ValueListenableBuilder(
                      valueListenable:
                          editProfileCubit.hasFocusNotifiersMap[brandIndex]
                              [entry.key]![nickNameIndex],
                      builder: (context, value, child) {
                        return AppTextField(
                          controller: entry.value[nickNameIndex],
                          focusNode: editProfileCubit.focusNodesMap[brandIndex]
                              [entry.key]![nickNameIndex],
                          label: SZodiac.of(context).nicknameZodiac,
                          errorType: editProfileCubit.errorTextsMap[brandIndex]
                                  [entry.key]?[nickNameIndex] ??
                              ValidationErrorType.empty,
                          approvalStatus:
                              editProfileCubit.approvalStatusMap[brandIndex]
                                  [entry.key]?[nickNameIndex],
                        );
                      }),
                  const SizedBox(
                    height: 24.0,
                  ),
                  ValueListenableBuilder(
                      valueListenable:
                          editProfileCubit.hasFocusNotifiersMap[brandIndex]
                              [entry.key]![aboutIndex],
                      builder: (context, value, child) {
                        return AppTextField(
                          controller: entry.value[aboutIndex],
                          focusNode: editProfileCubit.focusNodesMap[brandIndex]
                              [entry.key]![aboutIndex],
                          errorType: editProfileCubit.errorTextsMap[brandIndex]
                                  [entry.key]?[aboutIndex] ??
                              ValidationErrorType.empty,
                          label: SZodiac.of(context).aboutZodiac,
                          textInputType: TextInputType.multiline,
                          isBig: true,
                          approvalStatus:
                              editProfileCubit.approvalStatusMap[brandIndex]
                                  [entry.key]?[aboutIndex],
                        );
                      }),
                  const SizedBox(
                    height: 24.0,
                  ),
                  ValueListenableBuilder(
                      valueListenable:
                          editProfileCubit.hasFocusNotifiersMap[brandIndex]
                              [entry.key]![experienceIndex],
                      builder: (context, value, child) {
                        return AppTextField(
                          controller: entry.value[experienceIndex],
                          focusNode: editProfileCubit.focusNodesMap[brandIndex]
                              [entry.key]![experienceIndex],
                          errorType: editProfileCubit.errorTextsMap[brandIndex]
                                  [entry.key]?[experienceIndex] ??
                              ValidationErrorType.empty,
                          label: SZodiac.of(context).experienceZodiac,
                          textInputType: TextInputType.multiline,
                          isBig: true,
                          approvalStatus:
                              editProfileCubit.approvalStatusMap[brandIndex]
                                  [entry.key]?[experienceIndex],
                        );
                      }),
                  const SizedBox(
                    height: 24.0,
                  ),
                  ValueListenableBuilder(
                      valueListenable:
                          editProfileCubit.hasFocusNotifiersMap[brandIndex]
                              [entry.key]![helloMessageIndex],
                      builder: (context, value, child) {
                        return AppTextField(
                          controller: entry.value[helloMessageIndex],
                          focusNode: editProfileCubit.focusNodesMap[brandIndex]
                              [entry.key]![helloMessageIndex],
                          errorType: editProfileCubit.errorTextsMap[brandIndex]
                                  [entry.key]?[helloMessageIndex] ??
                              ValidationErrorType.empty,
                          label: SZodiac.of(context).chatStartGreetingZodiac,
                          textInputType: TextInputType.multiline,
                          isBig: true,
                          approvalStatus:
                              editProfileCubit.approvalStatusMap[brandIndex]
                                  [entry.key]?[helloMessageIndex],
                        );
                      }),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
