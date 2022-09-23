import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/widgets/add_more_images_from_gallery_widget.dart';

class GalleryImages extends StatelessWidget {
  const GalleryImages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> coverImages =
        context.select((EditProfileCubit cubit) => cubit.state.coverImages);
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(AppConstants.horizontalScreenPadding),
      itemCount: coverImages.length + 1,
      itemBuilder: (BuildContext context, int index) {
        return index < coverImages.length
            ? GalleryImageItem(
                imageUrl: coverImages[index],
              )
            : const AddMoreImagesFromGalleryWidget();
      },
    );
  }
}

class GalleryImageItem extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;

  const GalleryImageItem({Key? key, required this.imageUrl, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          image: DecorationImage(
              fit: BoxFit.fill, image: CachedNetworkImageProvider(imageUrl))),
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
