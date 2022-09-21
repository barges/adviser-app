import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_pick_image_alert.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/user_avatar.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditProfileCubit cubit = context.read<EditProfileCubit>();
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(onTap: () {
              showPickImageAlert(
                  context: context,
                  setImage: (image) {
                    cubit.setBackgroundImage(image);
                  });
            }, child: Builder(
              builder: (context) {
                final File? backgroundImage = context.select(
                    (EditProfileCubit cubit) => cubit.state.backgroundImage);
                return Container(
                  alignment: Alignment.center,
                  height: 140.0,
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColorLight,
                      image: backgroundImage != null
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(backgroundImage),
                            )
                          : null),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Get.theme.primaryColorLight),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Assets.vectors.add.svg(
                          color: Get.theme.primaryColor,
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                            backgroundImage != null
                                ? S.of(context).changeCoverPicture
                                : S.current.addCoverPicture,
                            style: Get.textTheme.titleMedium?.copyWith(
                                color: Get.theme.primaryColor,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                );
              },
            )),
            GestureDetector(
              onTap: () {
                showPickImageAlert(
                    context: context,
                    setImage: (image) {
                      cubit.setAvatar(image);
                    });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: Text(
                  S.current.changePhoto,
                  style: Get.textTheme.titleMedium?.copyWith(
                      color: Get.theme.primaryColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
            )
          ],
        ),
        Builder(builder: (context) {
          final File? avatar =
              context.select((EditProfileCubit cubit) => cubit.state.avatar);
          return Positioned(
              left: 16.0,
              bottom: 0.0,
              child: UserAvatar(
                imageFile: avatar,
              ));
        })
      ],
    );
  }
}
