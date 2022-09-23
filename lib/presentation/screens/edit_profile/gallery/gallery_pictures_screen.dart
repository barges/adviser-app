import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
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
        final List<String> photoList = editProfileCubit.state.coverImages;
        return Scaffold(
          body: Stack(
            children: [
              Container(
                color: Get.theme.canvasColor,
                child: PageView.builder(
                  physics: const ClampingScrollPhysics(),
                  allowImplicitScrolling: true,
                  itemCount: photoList.length,
                  controller: galleryPicturesCubit.pageController,
                  onPageChanged: (page) {
                    editProfileCubit.pageController.jumpToPage(page);
                  },
                  itemBuilder: (context, index) {
                    return InteractiveViewer(
                      panEnabled: false,
                      maxScale: 3.0,
                      minScale: 1.0,
                      child: CachedNetworkImage(
                          imageUrl: photoList[index], fit: BoxFit.contain),
                    );
                  },
                ),
              ),
              Positioned(
                  top: MediaQuery.of(context).viewPadding.top + 6.0,
                  left: 8.0,
                  child: AppIconButton(
                    icon: Assets.vectors.arrowLeft.path,
                    onTap: Get.back,
                  )),
              Positioned(
                bottom: 80.0,
                child: SizedBox(
                  width: Get.width,
                  child: Center(
                    child: Builder(builder: (context) {
                      return SmoothPageIndicator(
                        controller: galleryPicturesCubit.pageController,
                        count: photoList.length,
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
              )
            ],
          ),
        );
      }),
    );
  }
}
