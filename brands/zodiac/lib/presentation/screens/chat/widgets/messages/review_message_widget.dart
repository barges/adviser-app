import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';

class ReviewMessageWidget extends StatelessWidget {
  final ChatMessageModel chatMessageModel;

  const ReviewMessageWidget({
    Key? key,
    required this.chatMessageModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool ratingIsNotNull = chatMessageModel.rating != null;
    final bool messageIsNotEmpty = chatMessageModel.message?.isNotEmpty == true;

    if (ratingIsNotNull || messageIsNotEmpty) {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: theme.canvasColor,
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            if (ratingIsNotNull)
              RatingBar(
                initialRating: chatMessageModel.rating!,
                direction: Axis.horizontal,
                ignoreGestures: true,
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
            if (messageIsNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: ratingIsNotNull ? 8.0 : 0.0),
                child: Text(
                  '"${chatMessageModel.message!}"',
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
              )
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
