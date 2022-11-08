import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/user_avatar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class ReviewCardWidget extends StatelessWidget {
  const ReviewCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 122.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: Get.theme.canvasColor),
      child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.horizontalScreenPadding,
            horizontal: 12.0,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ReviewCustomerInfoWidget(),
                  _ReviewRatingWidget(),
                ],
              ),
              const SizedBox(
                height: 12.0,
              ),
              Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fames pulvinar commodo augue.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Get.textTheme.bodySmall?.copyWith(fontSize: 15))
            ],
          )),
    );
  }
}

class _ReviewCustomerInfoWidget extends StatelessWidget {
  const _ReviewCustomerInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserAvatar(diameter: 32.0, withBorder: false, avatarUrl: ''),
        const SizedBox(
          width: AppConstants.horizontalScreenPadding / 2,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wade Warren',
                style: Get.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            Text(
              DateFormat(dateFormat)
                  .format(DateTime.now())
                  .parseDateTimePattern4,
              style: Get.textTheme.bodySmall
                  ?.copyWith(color: Get.theme.shadowColor),
            )
          ],
        ),
      ],
    );
  }
}

class _ReviewRatingWidget extends StatelessWidget {
  const _ReviewRatingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RatingBar(
          initialRating: 4,
          direction: Axis.horizontal,
          itemSize: 18,
          allowHalfRating: true,
          itemCount: 5,
          ratingWidget: RatingWidget(
            full: Assets.vectors.starFilled.svg(),
            half: Assets.vectors.starEmpty.svg(),
            empty: Assets.vectors.starEmpty.svg(),
          ),
          itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
          onRatingUpdate: (rating) {},
        ),
        Text('Session was 12m',
            style: Get.textTheme.bodySmall
                ?.copyWith(fontSize: 12, color: Get.theme.primaryColor))
      ],
    );
  }
}
