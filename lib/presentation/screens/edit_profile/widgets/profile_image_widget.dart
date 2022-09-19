import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/user_profile_image_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_cubit.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditProfileCubit editProfileCubit = context.read<EditProfileCubit>();
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
                onTap: editProfileCubit.pickProfileImageFromGallery,
                child: Builder(
                  builder: (context) {
                    final String imagePath = context.select(
                        (EditProfileCubit cubit) => cubit.state.imagePath);
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 49.0),
                      decoration: BoxDecoration(
                          color: Get.theme.primaryColor.withOpacity(0.15),
                          image: imagePath.isNotEmpty
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(imagePath)))
                              : null),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Get.theme.scaffoldBackgroundColor),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Get.theme.primaryColor.withOpacity(0.15)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Assets.vectors.circledAdd.svg(
                                  width: 20.0, color: Get.theme.primaryColor),
                              const SizedBox(width: 6.0),
                              Text(S.current.addCoverPicture,
                                  style: Get.textTheme.titleMedium?.copyWith(
                                      color: Get.theme.primaryColor,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
            GestureDetector(
              onTap: editProfileCubit.pickProfileImageFromGallery,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: Text(S.current.changePhoto,
                    style: Get.textTheme.titleMedium?.copyWith(
                        color: Get.theme.primaryColor,
                        fontWeight: FontWeight.w500)),
              ),
            )
          ],
        ),
        const Positioned(left: 16.0, top: 97.0, child: UserProfileImageWidget())
      ],
    );
  }
}
