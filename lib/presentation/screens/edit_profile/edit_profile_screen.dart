import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/text_fields/custom_field_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/app_drawer.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/widgets/add_more_images_from_gallery_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/widgets/profile_image_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => HomeCubit()),
      BlocProvider(create: (context) => EditProfileCubit())
    ], child: const _BuildUI());
  }
}

class _BuildUI extends StatelessWidget {
  const _BuildUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = ['English', 'spanish'];
    final EditProfileCubit editProfileCubit = context.read<EditProfileCubit>();
    final HomeCubit homeCubit = context.read<HomeCubit>();
    final Brand currentBrand =
        context.select((MainCubit cubit) => cubit.state.currentBrand);

    return Scaffold(
      key: editProfileCubit.scaffoldKey,
      drawer: const AppDrawer(),
      appBar: WideAppBar(
          title: S.of(context).editProfile,
          topRightWidget: Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: InkWell(
                    onTap: homeCubit.openDrawer,
                    child: Builder(
                        builder: (context) => Row(
                              children: [
                                SvgPicture.asset(currentBrand.icon, width: 9.0),
                                const SizedBox(width: 8.0),
                                Text(currentBrand.name,
                                    style: Get.textTheme.labelMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Get.theme.primaryColor)),
                                const SizedBox(width: 9.0),
                                Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  color: Get.theme.primaryColor,
                                )
                              ],
                            )),
                  ),
                ),
                InkResponse(
                    onTap: () {
                      //TODO -- Save
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        S.of(context).save,
                        style: Get.textTheme.titleMedium?.copyWith(
                            color: Get.theme.primaryColor,
                            fontWeight: FontWeight.w500),
                      ),
                    )),
              ],
            ),
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16.0),
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
                    child: CustomFieldWidget(
                      controller: editProfileCubit.nicknameController,
                      label: S.of(context).nickname,
                    ),
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
                                    final int chosenLanguageIndex = context
                                        .select((EditProfileCubit cubit) =>
                                            editProfileCubit
                                                .state.chosenLanguageIndex);
                                    return LanguageWidget(
                                      languageName: languages[index],
                                      isSelected: chosenLanguageIndex == index,
                                      onTap: () {
                                        editProfileCubit
                                            .updateCurrentLanguageIndex(index);
                                      },
                                    );
                                  },
                                ))),
                  ),
                  CustomFieldWidget(
                    controller: editProfileCubit.statusTextController,
                    label: S.of(context).statusText,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    height: 144.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: CustomFieldWidget(
                      controller: editProfileCubit.profileTextController,
                      label: S.of(context).profileText,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      height: 144.0,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).addGalleryPictures,
                          style: Get.textTheme.titleLarge),
                      Padding(
                          padding:
                              const EdgeInsets.only(top: 8.0, bottom: 15.0),
                          child: Text(
                              '${S.of(context).customersWantSeeIfYouReal} ${S.of(context).theMorePhotosYourselfYouAddBetter}',
                              style: Get.textTheme.bodyMedium
                                  ?.copyWith(color: Get.theme.shadowColor))),
                      Builder(builder: (context) {
                        final List<XFile> imagesFromGallery = context.select(
                            (EditProfileCubit cubit) =>
                                cubit.state.imagesFromGallery);
                        return Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: List.generate(
                                imagesFromGallery.length + 1, (index) {
                              if (index < imagesFromGallery.length) {
                                return UploadedImageFromGallery(
                                  imageFilePath:
                                      imagesFromGallery.elementAt(index).path,
                                  onTap: () {
                                    editProfileCubit.removeGalleryImage(index);
                                  },
                                );
                              } else {
                                return AddMoreImagesFromGalleryWidget(
                                    onTap: editProfileCubit
                                        .addNewImageFromGallery);
                              }
                            }));
                      })
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
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
              child: Icon(Icons.close,
                  color: Get.theme.primaryColor, size: 24.0),
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
    return InkWell(
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
            color: isSelected
                ? Get.theme.primaryColor.withOpacity(0.2)
                : Get.theme.canvasColor,
            borderRadius: BorderRadius.circular(31)),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 9.0),
        child: Text(languageName,
            style: Get.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? Get.theme.primaryColor
                    : Get.theme.hoverColor)),
      ),
    );
  }
}
