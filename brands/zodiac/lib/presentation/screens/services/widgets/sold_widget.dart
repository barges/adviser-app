import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/generated/l10n.dart';

class SoldWidget extends StatelessWidget {
  final int sold;
  final int like;
  final int unlike;
  const SoldWidget({
    Key? key,
    required this.sold,
    required this.like,
    required this.unlike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: const Color(0xFF2C444A),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$sold ${SZodiac.of(context).soldZodiac.toUpperCase()}',
            style: theme.textTheme.displaySmall?.copyWith(
              fontSize: 10.0,
              color: theme.canvasColor,
            ),
          ),
          SizedBox(
            width: 52.0,
            child: Divider(
              height: 8.0,
              color: theme.shadowColor,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Assets.zodiac.vectors.heart.svg(),
                  Text(
                    like.toString(),
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontSize: 10.0,
                      color: theme.canvasColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppConstants.horizontalScreenPadding),
              Column(
                children: [
                  Assets.zodiac.vectors.heartCrack.svg(),
                  Text(
                    unlike.toString(),
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontSize: 10.0,
                      color: theme.canvasColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
