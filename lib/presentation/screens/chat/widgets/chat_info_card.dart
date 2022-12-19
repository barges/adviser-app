import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/chats/rirual_card_info.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/rounded_rect_image.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';

class InfoCard extends StatelessWidget {
  final RitualCardInfo? ritualCardInfo;

  const InfoCard({super.key, required this.ritualCardInfo});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final isLeftImage = ritualCardInfo?.leftImage != null;
    final isRightImage = ritualCardInfo?.rightImage != null;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        border: Border.all(
          width: 1.0,
          color: theme.hintColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                S.of(context).personalDetails,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.shadowColor,
                  fontSize: 13.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                ritualCardInfo?.name ?? '',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.hoverColor,
                  fontSize: 17.0,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat(datePattern1)
                      .format(ritualCardInfo?.birthdate ?? DateTime.now()),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.shadowColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    height: 4.0,
                    width: 4.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.hintColor,
                    ),
                  ),
                ),
                Text(
                  ritualCardInfo?.gender?.name(context) ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.shadowColor,
                  ),
                ),
              ],
            ),
            if (isLeftImage || isRightImage)
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 36.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isLeftImage)
                      Column(
                        children: [
                          if (ritualCardInfo?.leftImageTitle != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                ritualCardInfo!.leftImageTitle!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.shadowColor,
                                ),
                              ),
                            ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.galleryPictures,
                                arguments: GalleryPicturesScreenArguments(
                                  pictures: [ritualCardInfo!.leftImage!],
                                ),
                              );
                            },
                            child: RoundedRectImage(
                              uri: Uri.parse(ritualCardInfo!.leftImage!),
                              width: 132.0,
                              height: 132.0,
                            ),
                          )
                        ],
                      ),
                    if (isRightImage)
                      Column(
                        children: [
                          if (ritualCardInfo?.rightImageTitle != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                ritualCardInfo!.rightImageTitle!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.shadowColor,
                                ),
                              ),
                            ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.galleryPictures,
                                arguments: GalleryPicturesScreenArguments(
                                  pictures: [ritualCardInfo!.rightImage!],
                                ),
                              );
                            },
                            child: RoundedRectImage(
                              uri: Uri.parse(ritualCardInfo!.rightImage!),
                              width: 132.0,
                              height: 132.0,
                            ),
                          )
                        ],
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
