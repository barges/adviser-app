import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/app_drawer.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_state.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/widgets/gallery_images.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/widgets/languages_section_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/widgets/profile_image_widget.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Get.put<EditProfileCubit>(EditProfileCubit()),
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
          child: Builder(builder: (context) {
            return Scaffold(
              key: editProfileCubit.scaffoldKey,
              drawer: const AppDrawer(),
              body: SafeArea(
                top: false,
                child: CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    ScrollableAppBar(
                      title: S.of(context).editProfile,
                      actionOnClick: () => editProfileCubit.updateUserInfo(),
                      openDrawer: editProfileCubit.openDrawer,
                    ),
                    SliverToBoxAdapter(
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: Column(
                          children: [
                            const ProfileImageWidget(),
                            const SizedBox(
                              height: 16.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          AppConstants.horizontalScreenPadding),
                                  child: Builder(builder: (context) {
                                    final String nicknameErrorText = context
                                        .select((EditProfileCubit cubit) =>
                                            cubit.state.nicknameErrorText);
                                    return AppTextField(
                                      controller:
                                          editProfileCubit.nicknameController,
                                      label: S.of(context).nickname,
                                      errorText: nicknameErrorText,
                                    );
                                  }),
                                ),
                                const LanguageSectionWidget(),
                                const SizedBox(
                                  height: 24.0,
                                ),
                                const GalleryImages(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
