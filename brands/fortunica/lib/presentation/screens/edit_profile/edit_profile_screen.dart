import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/data/models/enums/validation_error_type.dart';
import 'package:fortunica/domain/repositories/fortunica_user_repository.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:fortunica/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import 'package:fortunica/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:fortunica/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:fortunica/presentation/screens/edit_profile/edit_profile_state.dart';
import 'package:fortunica/presentation/screens/edit_profile/widgets/languages_section_widget.dart';
import 'package:fortunica/presentation/screens/edit_profile/widgets/profile_images_widget.dart';

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
        mainCubit: fortunicaGetIt.get<FortunicaMainCubit>(),
        userRepository: fortunicaGetIt.get<FortunicaUserRepository>(),
        cacheManager: fortunicaGetIt.get<FortunicaCachingManager>(),
        connectivityService: fortunicaGetIt.get<ConnectivityService>(),
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
              key: editProfileCubit.scaffoldKey,
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
                                              AppConstants.minNickNameLength,
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
