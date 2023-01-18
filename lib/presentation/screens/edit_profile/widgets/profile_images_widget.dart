import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_image_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_pick_image_alert.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/user_avatar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const double _backgroundImageSectionHeight = 140.0;

class ProfileImagesWidget extends StatelessWidget {
  const ProfileImagesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditProfileCubit cubit = context.read<EditProfileCubit>();
    final List<String> coverPictures =
        context.select((EditProfileCubit cubit) => cubit.state.coverPictures);
    final bool isOnline = context
        .select((MainCubit cubit) => cubit.state.internetConnectionIsAvailable);
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Builder(
              builder: (context) {
                return coverPictures.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        height: _backgroundImageSectionHeight,
                        color: Theme.of(context).primaryColorLight,
                        child: GestureDetector(
                          onTap: isOnline ? cubit.goToAddGalleryPictures : null,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Theme.of(context).primaryColorLight),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Assets.vectors.add.svg(
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 6.0),
                                Text(S.of(context).addCoverPicture,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          SizedBox(
                            height: _backgroundImageSectionHeight,
                            child: PageView.builder(
                              physics: const ClampingScrollPhysics(),
                              controller: cubit.picturesPageController,
                              allowImplicitScrolling: true,
                              itemCount: coverPictures.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: cubit.goToGallery,
                                  child: SizedBox(
                                      height: _backgroundImageSectionHeight,
                                      child: AppImageWidget(
                                        uri: Uri.parse(coverPictures[index]),
                                      )),
                                );
                              },
                            ),
                          ),
                          if (coverPictures.length > 1)
                            Positioned(
                              bottom: 16.0,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: SmoothPageIndicator(
                                    controller: cubit.picturesPageController,
                                    count: coverPictures.length,
                                    effect: ScrollingDotsEffect(
                                      spacing: 12.0,
                                      maxVisibleDots: 7,
                                      dotWidth: 8.0,
                                      dotHeight: 8.0,
                                      dotColor: Theme.of(context).hintColor,
                                      activeDotColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      );
              },
            ),
            coverPictures.isNotEmpty
                ? Opacity(
                    opacity: isOnline ? 1.0 : 0.4,
                    child: GestureDetector(
                      onTap: isOnline ? cubit.goToAddGalleryPictures : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Assets.vectors.myGallery.svg(
                              width: AppConstants.iconSize,
                              height: AppConstants.iconSize,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              S.of(context).myGallery,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox(height: 43.0),
          ],
        ),
        Builder(builder: (context) {
          final File? avatar =
              context.select((EditProfileCubit cubit) => cubit.state.avatar);
          final List<String> profileImages =
              cubit.userProfile?.profilePictures ?? [];
          return Positioned(
              left: 16.0,
              bottom: 0.0,
              child: Stack(children: [
                UserAvatar(
                  key: cubit.profileAvatarKey,
                  imageFile: avatar,
                  avatarUrl: profileImages.firstOrNull,
                  withBorder: true,
                  withError: profileImages.isEmpty && avatar == null,
                  withCameraBadge: true,
                ),
                Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: GestureDetector(
                      onTap: () {
                        showPickImageAlert(
                            context: context,
                            setImage: (image) {
                              cubit.setAvatar(image);
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
                    ))
              ]));
        })
      ],
    );
  }
}
