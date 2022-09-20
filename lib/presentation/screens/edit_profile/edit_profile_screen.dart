import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_text_field.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_Icon_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/app_drawer.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/widgets/add_more_images_from_gallery_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/widgets/profile_image_widget.dart';

const double maxHeight = 104.0;
const double minHeight = 52.0;

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = ['English', 'Spanish'];

    return BlocProvider(
      create: (_) => EditProfileCubit(),
      child: Builder(builder: (context) {
        final EditProfileCubit editProfileCubit =
            context.read<EditProfileCubit>();
        return Scaffold(
          key: editProfileCubit.scaffoldKey,
          drawer: const AppDrawer(),
          body: CustomScrollView(
            controller: editProfileCubit.scrollController,
            slivers: [
              Builder(builder: (context) {
                final bool isWide = context.select(
                    (EditProfileCubit cubit) => cubit.state.isWideAppBar);
                return AppSliverAppBar(
                  setIsWideValue: (value) {
                    editProfileCubit.setIsWideAppbar(value);
                  },
                  isWide: isWide,
                  actionOnClick: () => editProfileCubit.updateUser(context),
                  openDrawer: editProfileCubit.openDrawer,
                );
              }),
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(children: [
                    const ProfileImageWidget(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.horizontalScreenPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Builder(builder: (context) {
                              final String nicknameErrorText = context.select(
                                  (EditProfileCubit cubit) =>
                                      cubit.state.nicknameErrorText);
                              return AppTextField(
                                controller: editProfileCubit.nicknameController,
                                label: S.of(context).nickname,
                                errorText: nicknameErrorText,
                              );
                            }),
                          ),
                          //List of supported languages
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Wrap(
                                spacing: 6.0,
                                runSpacing: 6.0,
                                children: List.generate(
                                    languages.length,
                                    (index) => Builder(
                                          builder: (context) {
                                            final int chosenLanguageIndex =
                                                context.select((EditProfileCubit
                                                        cubit) =>
                                                    cubit.state
                                                        .chosenLanguageIndex);
                                            return LanguageWidget(
                                              languageName: languages[index],
                                              isSelected:
                                                  chosenLanguageIndex == index,
                                              onTap: () {
                                                editProfileCubit
                                                    .updateCurrentLanguageIndex(
                                                        index);
                                              },
                                            );
                                          },
                                        ))),
                          ),
                          AppTextField(
                            controller: editProfileCubit.statusTextController,
                            label: S.of(context).statusText,
                            textInputType: TextInputType.multiline,
                            maxLines: 10,
                            height: 144.0,
                            contentPadding: const EdgeInsets.all(12.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: AppTextField(
                              controller:
                                  editProfileCubit.profileTextController,
                              label: S.of(context).profileText,
                              textInputType: TextInputType.multiline,
                              maxLines: 10,
                              height: 144.0,
                              contentPadding: const EdgeInsets.all(12.0),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.of(context).addGalleryPictures,
                                  style: Get.textTheme.titleLarge),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 15.0),
                                  child: Text(
                                      '${S.of(context).customersWantSeeIfYouReal} ${S.of(context).theMorePhotosYourselfYouAddBetter}',
                                      style: Get.textTheme.bodyMedium?.copyWith(
                                          color: Get.theme.shadowColor))),
                              Builder(builder: (context) {
                                // return
                                // Wrap(
                                //   spacing: 8.0,
                                //   runSpacing: 8.0,
                                //   children: List.generate(
                                //       imagesFromGallery.length + 1, (index) {
                                //     if (index < imagesFromGallery.length) {
                                //       return UploadedImageFromGallery(
                                //         imageFilePath:
                                //             imagesFromGallery.elementAt(index).path,
                                //         onTap: () {
                                //           editProfileCubit.removeGalleryImage(index);
                                //         },
                                //       );
                                //     } else {
                                return const AddMoreImagesFromGalleryWidget();
                                //   }
                                // },
                                // ),
                                // )
                              })
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class UploadedImageFromGallery extends StatelessWidget {
  final String imageFilePath;
  final VoidCallback? onTap;

  const UploadedImageFromGallery(
      {Key? key, required this.imageFilePath, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = Get.width * 0.29;
    return Container(
      height: width,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          image: DecorationImage(
              fit: BoxFit.fill, image: FileImage(File(imageFilePath)))),
      child: Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 32.0,
              width: 32.0,
              margin: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Get.theme.canvasColor.withOpacity(0.7),
              ),
              child: Assets.vectors.close.svg(
                color: Get.theme.primaryColor,
              ),
            ),
          )),
    );
  }
}

class LanguageWidget extends StatelessWidget {
  final String languageName;
  final bool isSelected;
  final VoidCallback? onTap;

  const LanguageWidget(
      {Key? key,
      required this.languageName,
      this.isSelected = false,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
            color: isSelected
                ? Get.theme.primaryColorLight
                : Get.theme.canvasColor,
            borderRadius: BorderRadius.circular(31)),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 9.0),
        child: Text(
          languageName,
          style: Get.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? Get.theme.primaryColor
                : Get.textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }
}

class AppSliverAppBar extends StatelessWidget {
  final VoidCallback? actionOnClick;
  final bool isWide;
  final VoidCallback? openDrawer;
  final ValueChanged<bool> setIsWideValue;

  const AppSliverAppBar({
    Key? key,
    required this.setIsWideValue,
    required this.isWide,
    this.actionOnClick,
    this.openDrawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      forceElevated: true,
      backgroundColor: Get.theme.canvasColor,
      expandedHeight: 104.0,
      centerTitle: true,
      pinned: true,
      snap: true,
      floating: true,
      titleSpacing: 16.0,
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        setIsWideValue(
            constraints.maxHeight - MediaQuery.of(context).padding.top >
                    maxHeight - 1.0 &&
                constraints.maxHeight - MediaQuery.of(context).padding.top <=
                    maxHeight);

        return FlexibleSpaceBar(
          expandedTitleScale: 1,
          titlePadding: const EdgeInsets.all(16.0),
          title: Builder(
            builder: (context) {
              return SizedBox(
                height: 104.0,
                child: Builder(builder: (context) {
                  return isWide
                      ? ConstrainedBox(
                          constraints: BoxConstraints(minWidth: Get.width),
                          child: Row(
                            children: [
                              AppIconButton(
                                icon: Assets.vectors.back.path,
                                onTap: Get.back,
                              ),
                              Builder(builder: (context) {
                                final Brand currentBrand = context.select(
                                    (MainCubit cubit) =>
                                        cubit.state.currentBrand);
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: openDrawer,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: AppConstants.iconsSize,
                                          width: AppConstants.iconsSize,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3.0),
                                          margin: const EdgeInsets.only(
                                            left: 8.0,
                                            right: 4.0,
                                          ),
                                          child: SvgPicture.asset(
                                            currentBrand.icon,
                                          ),
                                        ),
                                        Text(currentBrand.name,
                                            style: Get.textTheme.labelMedium
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: Get
                                                        .theme.primaryColor)),
                                        const SizedBox(width: 4.0),
                                        Assets.vectors.swap.svg(
                                          color: Get.theme.primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              AppIconButton(
                                icon: Assets.vectors.check.path,
                                onTap: () {
                                  if (actionOnClick != null) {
                                    actionOnClick!();
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink();
                }),
              );
            },
          ),
        );
      }),
      //title:
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(52.0),
        child: Builder(
          builder: (context) {
            final Brand currentBrand =
                context.select((MainCubit cubit) => cubit.state.currentBrand);
            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 52,
                child: !isWide
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppIconButton(
                            icon: Assets.vectors.back.path,
                            onTap: Get.back,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: AppConstants.iconsSize,
                                    width: AppConstants.iconsSize,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: SvgPicture.asset(
                                      currentBrand.icon,
                                    ),
                                  ),
                                  Text(
                                    S.of(context).editProfile,
                                    style:
                                        Get.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                currentBrand.name,
                                style: Get.textTheme.bodySmall?.copyWith(
                                  fontSize: 12.0,
                                  color: Get.iconColor,
                                ),
                              ),
                            ],
                          ),
                          AppIconButton(
                            icon: Assets.vectors.check.path,
                            onTap: () {
                              if (actionOnClick != null) {
                                actionOnClick!();
                              }
                            },
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Text(
                            S.of(context).editProfile,
                            style: Get.textTheme.headlineMedium,
                          ),
                        ],
                      ));
          },
        ),
      ),
    );
  }
}
