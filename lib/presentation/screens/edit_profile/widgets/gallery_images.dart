import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
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
                        S.of(context).customersWantSeeIfYouReal,
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
                itemCount: coverPictures.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  return index < coverPictures.length
                      ? GalleryImageItem(
                          imageUrl: coverPictures[index],
                          onDeleteTap: () {
                            cubit.deletePictureFromGallery(index);
                          },
                        )
                      : AddMoreImagesFromGalleryWidget(
                          onTap: () {
                            if (cubit.mainCubit.state
                                .internetConnectionIsAvailable) {
                              showPickImageAlert(
                                context: context,
                                setImage: cubit.addPictureToGallery,
                              );
                            }
                          },
                        );
                },
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}

class GalleryImageItem extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onDeleteTap;

  const GalleryImageItem({
    Key? key,
    required this.imageUrl,
    required this.onDeleteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(imageUrl),
        ),
      ),
      child: Align(
          alignment: Alignment.topRight,
          child: AppIconButton(
            icon: Assets.vectors.close.path,
            onTap: onDeleteTap,
          )),
    );
  }
}
