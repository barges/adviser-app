import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/data/models/user_info/review_item_zodiac.dart';
import 'package:zodiac/presentation/common_widgets/user_avatar.dart';

class ReviewCardWidget extends StatelessWidget {
  final ZodiacReviewItem item;
  const ReviewCardWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: Theme.of(context).canvasColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.horizontalScreenPadding,
          horizontal: 12.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ReviewCustomerInfoWidget(
              item: item,
            ),
            if (item.text != null && item.text!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(item.text!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 15)),
              )
          ],
        ),
      ),
    );
  }
}

class _ReviewCustomerInfoWidget extends StatelessWidget {
  final ZodiacReviewItem item;
  const _ReviewCustomerInfoWidget({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserAvatar(
            diameter: 32.0, avatarUrl: item.avatar ?? ''),
        const SizedBox(
          width: AppConstants.horizontalScreenPadding / 2,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.fakeName ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _ReviewRatingWidget(rating: item.rating ?? 0),
                ],
              ),
              Text(
                DateFormat(dateFormat)
                    .format(DateTime.fromMillisecondsSinceEpoch(
                        (item.dateCreate ?? 0) * 1000))
                    .parseDateTimePattern4,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).shadowColor),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewRatingWidget extends StatelessWidget {
  final int rating;
  const _ReviewRatingWidget({
    Key? key,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: rating.toDouble(),
      ignoreGestures: true,
      direction: Axis.horizontal,
      itemSize: 16,
      allowHalfRating: true,
      itemCount: 5,
      ratingWidget: RatingWidget(
        full: Assets.vectors.starFilled.svg(),
        half: Assets.vectors.starEmpty.svg(),
        empty: Assets.vectors.starEmpty.svg(),
      ),
      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      onRatingUpdate: (rating) {},
    );
  }
}
