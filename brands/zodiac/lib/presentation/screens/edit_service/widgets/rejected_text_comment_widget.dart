import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/generated/l10n.dart';

class RejectedTextCommentWidget extends StatelessWidget {
  final String? rejectedText;
  final String? commentText;

  const RejectedTextCommentWidget({
    Key? key,
    this.rejectedText,
    this.commentText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool rejectedIsNotNull = rejectedText != null;
    final bool commentIsNotNull = commentText != null;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Theme.of(context).canvasColor,
      ),
      child: Column(
        children: [
          if (rejectedIsNotNull)
            _RejectedTextWidget(
              rejectedText: rejectedText!,
            ),
          if (rejectedIsNotNull && commentIsNotNull)
            const SizedBox(
              height: 16.0,
            ),
          if (commentIsNotNull)
            _CommentTextWidget(
              commentText: commentText!,
            )
        ],
      ),
    );
  }
}

class _RejectedTextWidget extends StatelessWidget {
  final String rejectedText;
  const _RejectedTextWidget({
    Key? key,
    required this.rejectedText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Assets.zodiac.vectors.warningTriangleUnfilled.svg(
          height: 18.0,
          width: 18.0,
          colorFilter: const ColorFilter.mode(
            AppColors.error,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                SZodiac.of(context).yourServiceHasBeenRejectedBecauseOfZodiac,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                rejectedText,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 14.0,
                  color: theme.shadowColor,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class _CommentTextWidget extends StatelessWidget {
  final String commentText;
  const _CommentTextWidget({
    Key? key,
    required this.commentText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Assets.zodiac.vectors.infoCircleIcon.svg(
          height: 18.0,
          width: 18.0,
          color: theme.shadowColor,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                SZodiac.of(context).commentFromSupportTeamZodiac,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                commentText,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 14.0,
                  color: theme.shadowColor,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
