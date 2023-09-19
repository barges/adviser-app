import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/services/image_sample_model.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';

class ChooseImageWidget extends StatelessWidget {
  final List<ImageSampleModel> images;
  final int selectedImageIndex;
  final bool showAllImages;
  final ValueSetter<int> selectImage;
  final VoidCallback setShowAllImages;

  const ChooseImageWidget({
    Key? key,
    required this.images,
    required this.selectedImageIndex,
    required this.showAllImages,
    required this.selectImage,
    required this.setShowAllImages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    logger.d('showAllImages: $showAllImages');

    final List<String> shownImages = showAllImages
        ? images.map((e) => e.image ?? '').toList()
        : images
            .getRange(0, images.length > 12 ? 12 : images.length)
            .toList()
            .map((e) => e.image ?? '')
            .toList();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            SZodiac.of(context).chooseAnImageZodiac,
            style: theme.textTheme.headlineMedium?.copyWith(fontSize: 17.0),
          ),
          const SizedBox(
            height: 12.0,
          ),
          AppImageWidget(
            uri: Uri.parse(images[selectedImageIndex].image ?? ''),
            width: MediaQuery.of(context).size.width,
            height: 118.0,
            radius: 4.0,
          ),
          const SizedBox(
            height: 12.0,
          ),
          GridView.count(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 4,
            mainAxisSpacing: 12.0,
            crossAxisSpacing: 12.0,
            childAspectRatio: 68 / 36,
            children: shownImages
                .mapIndexed(
                  (index, element) => GestureDetector(
                    onTap: () => selectImage(index),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Opacity(
                            opacity: selectedImageIndex == index ? 0.6 : 1.0,
                            child: AppImageWidget(
                              uri: Uri.parse(element),
                              radius: 6.0,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                border: selectedImageIndex == index
                                    ? Border.all(
                                        color: theme.primaryColor,
                                        width: 2.0,
                                      )
                                    : null),
                          ),
                        )
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(
            height: 22.0,
          ),
          GestureDetector(
            onTap: setShowAllImages,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  showAllImages
                      ? SZodiac.of(context).showLessZodiac
                      : SZodiac.of(context).showMoreZodiac,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontSize: 17.0,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(
                  width: 2.0,
                ),
                RotatedBox(
                  quarterTurns: showAllImages ? 1 : -1,
                  child: Assets.vectors.arrowLeft.svg(
                      key: ValueKey(showAllImages),
                      height: 24.0,
                      width: 24.0,
                      colorFilter: ColorFilter.mode(
                        theme.primaryColor,
                        BlendMode.srcIn,
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
