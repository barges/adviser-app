import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_image_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_pick_image_alert.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/widgets/add_more_images_from_gallery_widget.dart';

class GalleryImages extends StatelessWidget {
  const GalleryImages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditProfileCubit cubit = context.read<EditProfileCubit>();
    final List<String> coverPictures =
        context.select((EditProfileCubit cubit) => cubit.state.coverPictures);

    return coverPictures.isNotEmpty
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalScreenPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).addGalleryPictures,
                        style: Theme.of(context).textTheme.titleLarge),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 15.0),
                      child: Text(
                        S
                            .of(context)
                            .customersWantToKnowYouReARealPersonTheMorePhotosYouAddTheMoreTrustYouCanBuild,
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
                padding:
                    const EdgeInsets.all(AppConstants.horizontalScreenPadding),
                itemCount: coverPictures.length < 6
                    ? coverPictures.length + 1
                    : coverPictures.length,
                itemBuilder: (BuildContext context, int index) {
                  return index < coverPictures.length
                      ? _GalleryImageItem(
                          uri: Uri.parse(coverPictures[index]),
                          onDeleteTap: () {
                            cubit.deletePictureFromGallery(index);
                          },
                        )
                      : coverPictures.length < 6
                          ? AddMoreImagesFromGalleryWidget(
                              onTap: () {
                                if (cubit.mainCubit.state
                                    .internetConnectionIsAvailable) {
                                  showPickImageAlert(
                                    context: context,
                                    setImage: cubit.addPictureToGallery,
                                  );
                                }
                              },
                            )
                          : const SizedBox.shrink();
                },
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}

class _GalleryImageItem extends StatelessWidget {
  final Uri uri;
  final VoidCallback onDeleteTap;

  const _GalleryImageItem({
    Key? key,
    required this.uri,
    required this.onDeleteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppImageWidget(
          uri: uri,
          radius: AppConstants.buttonRadius,
        ),
        Positioned(
          top: 4.0,
          right: 4.0,
          child: AppIconButton(
            icon: Assets.vectors.close.path,
            onTap: onDeleteTap,
          ),
        )
      ],
    );
  }
}
