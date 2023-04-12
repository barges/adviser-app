import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/presentation/common_widgets/app_image_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_delete_alert.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_pick_image_alert.dart';
import 'package:fortunica/presentation/screens/add_gallery_pictures/add_gallery_pictures_cubit.dart';
import 'package:fortunica/presentation/screens/add_gallery_pictures/widgets/add_more_images_from_gallery_widget.dart';
import 'package:fortunica/presentation/screens/gallery/gallery_pictures_screen.dart';

class GalleryImages extends StatelessWidget {
  const GalleryImages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddGalleryPicturesCubit addGalleryPicturesCubit =
        context.read<AddGalleryPicturesCubit>();
    final MainCubit mainCubit = context.read<MainCubit>();
    final List<String> coverPictures = context
        .select((AddGalleryPicturesCubit cubit) => cubit.state.coverPictures);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalScreenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
                child: Text(
                  SFortunica.of(context)
                      .customersWantToKnowYouReARealPersonTheMorePhotosYouAddTheMoreTrustYouCanBuildFortunica,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).shadowColor),
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(AppConstants.horizontalScreenPadding),
          itemCount: coverPictures.length < 6
              ? coverPictures.length + 1
              : coverPictures.length,
          itemBuilder: (BuildContext context, int index) {
            return index < coverPictures.length
                ? _GalleryImageItem(
                    uri: Uri.parse(coverPictures[index]),
                    onSelectTap: () {
                      context.push(
                          route: FortunicaGalleryPictures(
                        galleryPicturesScreenArguments:
                            GalleryPicturesScreenArguments(
                          pictures: coverPictures,
                          initPage: index.toDouble(),
                        ),
                      ));
                    },
                    onDeleteTap: () {
                      addGalleryPicturesCubit.deletePictureFromGallery(index);
                    },
                  )
                : coverPictures.length < 6
                    ? AddMoreImagesFromGalleryWidget(
                        onTap: () {
                          if (mainCubit.state.internetConnectionIsAvailable) {
                            showPickImageAlert(
                              context: context,
                              setImage:
                                  addGalleryPicturesCubit.addPictureToGallery,
                            );
                          }
                        },
                      )
                    : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class _GalleryImageItem extends StatelessWidget {
  final Uri uri;
  final VoidCallback onSelectTap;
  final VoidCallback onDeleteTap;

  const _GalleryImageItem({
    Key? key,
    required this.uri,
    required this.onSelectTap,
    required this.onDeleteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onSelectTap,
          child: AppImageWidget(
            uri: uri,
            radius: AppConstants.buttonRadius,
            memCacheHeight: MediaQuery.of(context).size.width ~/ 3,
            backgroundColor: Theme.of(context).canvasColor,
          ),
        ),
        Positioned(
          top: 4.0,
          right: 4.0,
          child: AppIconButton(
            icon: Assets.vectors.close.path,
            onTap: () async {
              final bool? isDelete = await showDeleteAlert(
                context,
                SFortunica.of(context).doYouWantToDeleteImageFortunica,
              );
              if (isDelete == true) {
                onDeleteTap();
              }
            },
          ),
        )
      ],
    );
  }
}
