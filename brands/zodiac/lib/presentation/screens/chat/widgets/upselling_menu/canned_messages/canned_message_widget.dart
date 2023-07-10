import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/generated/l10n.dart';

const double cannedMessageContentPadding = 12.0;
const double paddingBetweenMessageAndEdit = 6.0;

class CannedMessageWidget extends StatelessWidget {
  final String message;
  const CannedMessageWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            maxLines: 7,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.backgroundColor,
            ),
          ),
          const SizedBox(
            height: paddingBetweenMessageAndEdit,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                SZodiac.of(context).editZodiac,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.backgroundColor,
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Assets.zodiac.vectors.editIcon.svg(
                height: AppConstants.iconSize,
                width: AppConstants.iconSize,
                colorFilter: ColorFilter.mode(
                  theme.backgroundColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
