import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';
import 'package:zodiac/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:zodiac/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:zodiac/presentation/screens/edit_profile/widgets/languages_buttons.dart';

class LocalesDescriptionsPartWidget extends StatelessWidget {
  const LocalesDescriptionsPartWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditProfileCubit editProfileCubit = context.read<EditProfileCubit>();
    final List<String> locales =
        context.select((EditProfileCubit cubit) => cubit.state.advisorLocales);

    final int currentLocaleIndex = context
        .select((EditProfileCubit cubit) => cubit.state.currentLocaleIndex);
    context.select((EditProfileCubit cubit) => cubit.state.updateTextsFlag);

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
          ),
          const SizedBox(
            height: 24.0,
          ),
          IndexedStack(
            index: currentLocaleIndex,
            children: editProfileCubit.textControllersMap.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalScreenPadding),
                child: Column(
                  children: [
                    ValueListenableBuilder(
                        valueListenable: editProfileCubit
                            .hasFocusNotifiersMap[entry.key]![nickNameIndex],
                        builder: (context, value, child) {
                          return AppTextField(
                            controller: entry.value[nickNameIndex],
                            focusNode: editProfileCubit
                                .focusNodesMap[entry.key]![nickNameIndex],
                            label: 'Nickname',
                            errorType: editProfileCubit.errorTextsMap[entry.key]
                                    ?[nickNameIndex] ??
                                ValidationErrorType.empty,
                          );
                        }),
                    const SizedBox(
                      height: 24.0,
                    ),
                    ValueListenableBuilder(
                        valueListenable: editProfileCubit
                            .hasFocusNotifiersMap[entry.key]![aboutIndex],
                        builder: (context, value, child) {
                          return AppTextField(
                            controller: entry.value[aboutIndex],
                            focusNode: editProfileCubit
                                .focusNodesMap[entry.key]![aboutIndex],
                            errorType: editProfileCubit.errorTextsMap[entry.key]
                                    ?[aboutIndex] ??
                                ValidationErrorType.empty,
                            label: 'About',
                            textInputType: TextInputType.multiline,
                            isBig: true,
                          );
                        }),
                    const SizedBox(
                      height: 24.0,
                    ),
                    ValueListenableBuilder(
                        valueListenable: editProfileCubit
                            .hasFocusNotifiersMap[entry.key]![experienceIndex],
                        builder: (context, value, child) {
                          return AppTextField(
                            controller: entry.value[experienceIndex],
                            focusNode: editProfileCubit
                                .focusNodesMap[entry.key]![experienceIndex],
                            errorType: editProfileCubit.errorTextsMap[entry.key]
                                    ?[experienceIndex] ??
                                ValidationErrorType.empty,
                            label: 'Experience',
                            textInputType: TextInputType.multiline,
                            isBig: true,
                          );
                        }),
                    const SizedBox(
                      height: 24.0,
                    ),
                    ValueListenableBuilder(
                        valueListenable: editProfileCubit.hasFocusNotifiersMap[
                            entry.key]![helloMessageIndex],
                        builder: (context, value, child) {
                          return AppTextField(
                            controller: entry.value[helloMessageIndex],
                            focusNode: editProfileCubit
                                .focusNodesMap[entry.key]![helloMessageIndex],
                            errorType: editProfileCubit.errorTextsMap[entry.key]
                                    ?[helloMessageIndex] ??
                                ValidationErrorType.empty,
                            label: 'Chat start greeting',
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
      ),
    );
  }
}
