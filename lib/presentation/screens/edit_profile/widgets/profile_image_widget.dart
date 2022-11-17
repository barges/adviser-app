import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_pick_image_alert.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/user_avatar.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const double _backgroundImageSectionHeight = 140.0;

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
            Builder(
              builder: (context) {
                final List<String> coverPictures = context.select(
                    (EditProfileCubit cubit) => cubit.state.coverPictures);

                return coverPictures.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        height: _backgroundImageSectionHeight,
                        color: Theme.of(context).primaryColorLight,
                        child: GestureDetector(
                          onTap: () {
                            showPickImageAlert(
                                context: context,
                                setImage: (image) {
                                  cubit.addPictureToGallery(image);
                                });
                          },
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
                                Text(S.current.addCoverPicture,
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
                                    child: CachedNetworkImage(
                                      imageUrl: coverPictures[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
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
                                    dotColor:
                                        Theme.of(context).iconTheme.color ??
                                            Colors.grey,
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
            )
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
              child: UserAvatar(
                imageFile: avatar,
                avatarUrl: profileImages.firstOrNull,
                withBorder: true,
              ));
        })
      ],
    );
  }
}
