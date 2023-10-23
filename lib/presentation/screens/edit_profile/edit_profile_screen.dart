import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_constants.dart';
import '../../../data/cache/fortunica_caching_manager.dart';
import '../../../data/models/enums/validation_error_type.dart';
import '../../../domain/repositories/fortunica_user_repository.dart';
import '../../../fortunica_constants.dart';
import '../../../generated/l10n.dart';
import '../../../global.dart';
import '../../../main_cubit.dart';
import '../../../services/connectivity_service.dart';
import '../../common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import '../../common_widgets/text_fields/app_text_field.dart';
import 'edit_profile_cubit.dart';
import 'edit_profile_state.dart';
import 'widgets/languages_section_widget.dart';
import 'widgets/profile_images_widget.dart';

class EditProfileScreen extends StatelessWidget {
  final bool isAccountTimeout;

  const EditProfileScreen({
    Key? key,
    required this.isAccountTimeout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileCubit(
        mainCubit: globalGetIt.get<MainCubit>(),
        userRepository: globalGetIt.get<FortunicaUserRepository>(),
        cacheManager: globalGetIt.get<FortunicaCachingManager>(),
        connectivityService: globalGetIt.get<ConnectivityService>(),
      ),
      child: Builder(builder: (context) {
        final EditProfileCubit editProfileCubit =
            context.read<EditProfileCubit>();

        return BlocListener<EditProfileCubit, EditProfileState>(
          listener: (prev, current) {
            if (current.chosenLanguageIndex == 0) {
              editProfileCubit.languagesScrollController.animateTo(
                  editProfileCubit
                      .languagesScrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear);
            } else if (current.chosenLanguageIndex ==
                editProfileCubit.activeLanguages.length - 1) {
              editProfileCubit.languagesScrollController.animateTo(
                  editProfileCubit
                      .languagesScrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear);
            }
          },
          child: GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: Scaffold(
              body: SafeArea(
                top: false,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: RefreshIndicator(
                    onRefresh: editProfileCubit.refreshUserProfile,
                    notificationPredicate: (_) => isAccountTimeout,
                    edgeOffset: (AppConstants.appBarHeight * 2) +
                        MediaQuery.of(context).padding.top,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics()
                          .applyTo(const ClampingScrollPhysics()),
                      slivers: [
                        ScrollableAppBar(
                          title: SFortunica.of(context).editProfileFortunica,
                          needShowError: true,
                          actionOnClick: () =>
                              editProfileCubit.updateUserInfo(context),
                        ),
                        SliverToBoxAdapter(
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: Column(
                              children: [
                                const ProfileImagesWidget(),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: AppConstants
                                              .horizontalScreenPadding),
                                      child: Builder(builder: (context) {
                                        final ValidationErrorType
                                            nicknameErrorType = context.select(
                                                (EditProfileCubit cubit) =>
                                                    cubit.state
                                                        .nicknameErrorType);
                                        context.select(
                                            (EditProfileCubit cubit) =>
                                                cubit.state.nicknameHasFocus);
                                        return AppTextField(
                                          key:
                                              editProfileCubit.nicknameFieldKey,
                                          controller: editProfileCubit
                                              .nicknameController,
                                          focusNode: editProfileCubit
                                              .nicknameFocusNode,
                                          label: SFortunica.of(context)
                                              .nicknameFortunica,
                                          errorType: nicknameErrorType,
                                          isEnabled: (editProfileCubit
                                                      .userProfile
                                                      ?.profileName
                                                      ?.length ??
                                                  0) <
                                              FortunicaConstants
                                                  .minNickNameLength,
                                          detailsText: SFortunica.of(context)
                                              .nameCanBeChangedOnlyOnAdvisorToolFortunica,
                                        );
                                      }),
                                    ),
                                    const LanguageSectionWidget(),
                                    const SizedBox(height: 46.0),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
