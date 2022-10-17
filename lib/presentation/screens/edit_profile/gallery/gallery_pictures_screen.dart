import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/transparrent_app_bar.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/gallery/gallery_pictures_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GalleryPicturesScreen extends StatelessWidget {
  const GalleryPicturesScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GalleryPicturesCubit(),
      child: Builder(builder: (context) {
        final GalleryPicturesCubit galleryPicturesCubit =
            context.read<GalleryPicturesCubit>();
        final EditProfileCubit editProfileCubit = Get.find<EditProfileCubit>();
        final List<String> coverPictures = editProfileCubit.state.coverPictures;
        return Scaffold(
          body: Stack(
            children: [
              Container(
                color: Get.theme.canvasColor,
                child: PageView.builder(
                  physics: const ClampingScrollPhysics(),
                  allowImplicitScrolling: true,
                  itemCount: coverPictures.length,
                  controller: galleryPicturesCubit.pageController,
                  onPageChanged: (page) {
                    editProfileCubit.picturesPageController.jumpToPage(page);
                  },
                  itemBuilder: (context, index) {
                    return InteractiveViewer(
                      panEnabled: false,
                      maxScale: 3.0,
                      minScale: 1.0,
                      child: CachedNetworkImage(
                          imageUrl: coverPictures[index], fit: BoxFit.contain),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 80.0,
                child: SizedBox(
                  width: Get.width,
                  child: Center(
                    child: Builder(builder: (context) {
                      return SmoothPageIndicator(
                        controller: galleryPicturesCubit.pageController,
                        count: coverPictures.length,
                        effect: ScrollingDotsEffect(
                          spacing: 12.0,
                          maxVisibleDots: 7,
                          dotWidth: 8.0,
                          dotHeight: 8.0,
                          dotColor: Get.iconColor ?? Colors.grey,
                          activeDotColor: Get.theme.primaryColor,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const TransparentAppBar(),
            ],
          ),
        );
      }),
    );
  }
}
