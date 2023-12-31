import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_image_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/transparrent_app_bar.dart';
import 'package:shared_advisor_interface/presentation/screens/gallery/gallery_pictures_cubit.dart';
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
        final List<String> coverPictures = galleryPicturesCubit.coverPictures;
        return Scaffold(
          body: Stack(
            children: [
              Container(
                color: Theme.of(context).canvasColor,
                child: PageView.builder(
                  physics: const ClampingScrollPhysics(),
                  allowImplicitScrolling: true,
                  itemCount: coverPictures.length,
                  controller: galleryPicturesCubit.pageController,
                  onPageChanged: (page) {
                    galleryPicturesCubit.editProfilePageController
                        ?.jumpToPage(page);
                  },
                  itemBuilder: (context, index) {
                    final Uri uri = Uri.parse(coverPictures[index]);

                    return InteractiveViewer(
                        panEnabled: false,
                        maxScale: 5.0,
                        minScale: 1.0,
                        child: AppImageWidget(
                          uri: uri,
                          fit: BoxFit.contain,
                        ));
                  },
                ),
              ),
              if (galleryPicturesCubit.coverPictures.length > 1)
                Positioned(
                  bottom: 80.0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Builder(builder: (context) {
                        return SmoothPageIndicator(
                          controller: galleryPicturesCubit.pageController,
                          count: coverPictures.length,
                          effect: ScrollingDotsEffect(
                            activeDotScale: 1.0,
                            spacing: 12.0,
                            maxVisibleDots: 7,
                            dotWidth: 8.0,
                            dotHeight: 8.0,
                            dotColor: Theme.of(context).hintColor,
                            activeDotColor: Theme.of(context).primaryColor,
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
