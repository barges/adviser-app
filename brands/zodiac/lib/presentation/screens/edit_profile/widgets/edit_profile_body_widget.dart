import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_pick_image_alert.dart';
import 'package:zodiac/data/models/user_info/brand_model.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/user_avatar.dart';
import 'package:zodiac/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:zodiac/presentation/screens/edit_profile/widgets/brands_part/brands_list_widget.dart';
import 'package:zodiac/presentation/screens/edit_profile/widgets/tile_menu_button.dart';

class EditProfileBodyWidget extends StatelessWidget {
  final List<BrandModel> brands;
  final int selectedBrandIndex;

  const EditProfileBodyWidget({
    Key? key,
    required this.brands,
    required this.selectedBrandIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditProfileCubit editProfileCubit = context.read<EditProfileCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16.0,
        ),
        BrandsListWidget(
          brands: brands,
          selectedBrandIndex: selectedBrandIndex,
        ),
        const SizedBox(
          height: 24.0,
        ),
        _UserAvatarWidget(
          selectedBrandIndex: selectedBrandIndex,
          avatarUrls: brands.map((e) => e.fields?.avatar).toList(),
        ),
        const SizedBox(
          height: 24.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalScreenPadding),
          child: Column(
            children: [
              TileMenuButton(
                label: SZodiac.of(context).categoriesZodiac,
                title: brands[selectedBrandIndex]
                        .fields
                        ?.categories
                        ?.map((e) => e.name)
                        .toList()
                        .join(', ') ??
                    '',
                onTap: () => editProfileCubit.goToCategoriesList(context),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _UserAvatarWidget extends StatelessWidget {
  final int selectedBrandIndex;
  final List<String?> avatarUrls;

  const _UserAvatarWidget({
    Key? key,
    required this.selectedBrandIndex,
    required this.avatarUrls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<File?> avatarFiles =
        context.select((EditProfileCubit cubit) => cubit.state.avatars);

    return Padding(
      padding: const EdgeInsets.only(
        left: AppConstants.horizontalScreenPadding,
      ),
      child: Stack(children: [
        UserAvatar(
          // key: editProfileCubit.profileAvatarKey,
          imageFile: avatarFiles[selectedBrandIndex],
          avatarUrl: avatarUrls[selectedBrandIndex],
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
                      // editProfileCubit.setAvatar(image);
                    });
              },
              child: Container(
                width: AppConstants.iconButtonSize,
                height: AppConstants.iconButtonSize,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: theme.primaryColorLight),
                child: Center(
                    child:
                        Assets.vectors.camera.svg(color: theme.primaryColor)),
              ),
            )),
      ]),
    );
  }
}
