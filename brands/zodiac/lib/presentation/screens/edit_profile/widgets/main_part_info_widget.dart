import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_pick_image_alert.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/models/user_info/detailed_user_info.dart';
import 'package:zodiac/presentation/common_widgets/user_avatar.dart';
import 'package:zodiac/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:zodiac/presentation/screens/edit_profile/widgets/tile_menu_button.dart';

class MainPartInfoWidget extends StatelessWidget {
  final DetailedUserInfo? detailedUserInfo;
  final bool forMainSubBrand;

  const MainPartInfoWidget({
    Key? key,
    required this.detailedUserInfo,
    this.forMainSubBrand = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditProfileCubit editProfileCubit = context.read<EditProfileCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 24.0,
        ),
        Builder(builder: (context) {
          final File? avatar =
              context.select((EditProfileCubit cubit) => cubit.state.avatar);

          return Padding(
            padding: const EdgeInsets.only(
              left: AppConstants.horizontalScreenPadding,
            ),
            child: Stack(children: [
              UserAvatar(
                key: editProfileCubit.profileAvatarKey,
                imageFile: avatar,
                avatarUrl: detailedUserInfo?.details?.avatar,
                withBorder: true,
                withCameraBadge: true,
                canOpenInFullScreen: true,
              ),
              Positioned(
                  right: 0.0,
                  bottom: 0.0,
                  child: GestureDetector(
                    onTap: () {
                      showPickImageAlert(
                          context: context,
                          setImage: (image) {
                            editProfileCubit.setAvatar(image);
                          });
                    },
                    child: Container(
                      width: AppConstants.iconButtonSize,
                      height: AppConstants.iconButtonSize,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColorLight),
                      child: Center(
                          child: Assets.vectors.camera
                              .svg(color: Theme.of(context).primaryColor)),
                    ),
                  )),
            ]),
          );
        }),
        const SizedBox(
          height: 24.0,
        ),
        if (forMainSubBrand)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalScreenPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (context) {
                    final String mainLocaleCode = context.select(
                            (EditProfileCubit cubit) =>
                        cubit.state.advisorMainLocale);

                    return TileMenuButton(
                      label: 'Main language',
                      title: editProfileCubit.localeNativeName(mainLocaleCode),
                    );
                  }
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Builder(builder: (context) {
                  final List<CategoryInfo> mainCategory = context.select(
                      (EditProfileCubit cubit) =>
                          cubit.state.advisorMainCategory);
                  return TileMenuButton(
                    label: 'Main specialty',
                    title:
                        mainCategory.firstOrNull?.name ??
                            detailedUserInfo?.details?.specializing ??
                        '',
                    onTap: () =>
                        editProfileCubit.goToSelectMainCategory(context),
                  );
                }),
                const SizedBox(
                  height: 24.0,
                ),
                Builder(builder: (context) {
                  final List<CategoryInfo> categories = context.select(
                      (EditProfileCubit cubit) =>
                          cubit.state.advisorCategories);
                  return TileMenuButton(
                    label: 'My specialties',
                    title: categories.map((e) => e.name).toList().join(', '),
                    onTap: () =>
                        editProfileCubit.goToSelectAllCategories(context),
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }
}
