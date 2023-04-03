import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/enums/validation_error_type.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/app_drawer.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_state.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/widgets/languages_section_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/widgets/profile_images_widget.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileCubit(),
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
              drawer: const AppDrawer(),
              body: SafeArea(
                top: false,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: RefreshIndicator(
                    onRefresh: editProfileCubit.refreshUserProfile,
                    notificationPredicate: (_) => editProfileCubit.needRefresh,
                    edgeOffset: (AppConstants.appBarHeight * 2) +
                        MediaQuery.of(context).padding.top,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics()
                          .applyTo(const ClampingScrollPhysics()),
                      slivers: [
                        ScrollableAppBar(
                          title: S.of(context).editProfile,
                          needShowError: true,
                          actionOnClick: editProfileCubit.updateUserInfo,
                          openDrawer: editProfileCubit.openDrawer,
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
                                          label: S.of(context).nickname,
                                          errorType: nicknameErrorType,
                                          isEnabled: (editProfileCubit
                                                      .userProfile
                                                      ?.profileName
                                                      ?.length ??
                                                  0) <
                                              AppConstants.minNickNameLength,
                                          detailsText: S
                                              .of(context)
                                              .nameCanBeChangedOnlyOnAdvisorTool,
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
