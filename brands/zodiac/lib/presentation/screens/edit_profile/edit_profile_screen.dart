import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';
import 'package:zodiac/data/models/user_info/detailed_user_info.dart';
import 'package:zodiac/data/models/user_info/locale_model.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import 'package:zodiac/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:zodiac/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:zodiac/presentation/screens/edit_profile/widgets/languages_buttons.dart';
import 'package:zodiac/presentation/screens/edit_profile/widgets/main_part_info_widget.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileCubit(
        zodiacGetIt.get<ZodiacMainCubit>(),
        zodiacGetIt.get<ZodiacCachingManager>(),
        zodiacGetIt.get<ZodiacUserRepository>(),
      ),
      child: Scaffold(
        body: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Builder(builder: (context) {
            final EditProfileCubit editProfileCubit =
                context.read<EditProfileCubit>();
            final DetailedUserInfo? detailedUserInfo = context.select(
                (EditProfileCubit cubit) => cubit.state.detailedUserInfo);
            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                ScrollableAppBar(
                  title: SZodiac.of(context).editProfileZodiac,
                  needShowError: true,
                  actionOnClick: () {
                    editProfileCubit.saveInfo();
                  },
                ),
                SliverToBoxAdapter(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainPartInfoWidget(
                      detailedUserInfo: detailedUserInfo,
                    ),
                    if (detailedUserInfo?.locales?.isNotEmpty == true)
                      const LocalesDescriptionsPartWidget()
                  ],
                )),
              ],
            );
          }),
        ),
      ),
    );
  }
}

const int _nickNameIndex = 0;
const int _aboutIndex = 1;
const int _experienceIndex = 2;
const int _helloMessageIndex = 3;

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
            addLocaleOnTap: () {
              editProfileCubit.addLocaleLocally(LocaleModel(
                code: 'pt',
              ));
            },
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
                            .hasFocusNotifiersMap[entry.key]![_nickNameIndex],
                        builder: (context, value, child) {
                          return AppTextField(
                            controller: entry.value[_nickNameIndex],
                            focusNode: editProfileCubit
                                .focusNodesMap[entry.key]![_nickNameIndex],
                            label: 'Nickname',
                            errorType: editProfileCubit.errorTextsMap[entry.key]
                                    ?[_nickNameIndex] ??
                                ValidationErrorType.empty,
                          );
                        }),
                    const SizedBox(
                      height: 24.0,
                    ),
                    ValueListenableBuilder(
                        valueListenable: editProfileCubit
                            .hasFocusNotifiersMap[entry.key]![_aboutIndex],
                        builder: (context, value, child) {
                          return AppTextField(
                            controller: entry.value[_aboutIndex],
                            focusNode: editProfileCubit
                                .focusNodesMap[entry.key]![_aboutIndex],
                            errorType: editProfileCubit.errorTextsMap[entry.key]
                                    ?[_aboutIndex] ??
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
                            .hasFocusNotifiersMap[entry.key]![_experienceIndex],
                        builder: (context, value, child) {
                          return AppTextField(
                            controller: entry.value[_experienceIndex],
                            focusNode: editProfileCubit
                                .focusNodesMap[entry.key]![_experienceIndex],
                            errorType: editProfileCubit.errorTextsMap[entry.key]
                                    ?[_experienceIndex] ??
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
                            entry.key]![_helloMessageIndex],
                        builder: (context, value, child) {
                          return AppTextField(
                            controller: entry.value[_helloMessageIndex],
                            focusNode: editProfileCubit
                                .focusNodesMap[entry.key]![_helloMessageIndex],
                            errorType: editProfileCubit.errorTextsMap[entry.key]
                                    ?[_helloMessageIndex] ??
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
