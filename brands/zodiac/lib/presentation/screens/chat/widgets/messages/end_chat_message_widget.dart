import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/zodiac_extensions.dart';

class EndChatMessageWidget extends StatelessWidget {
  final String title;
  final String iconPath;
  final DateTime? date;
  final bool isOutgoing;

  const EndChatMessageWidget({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.date,
    this.isOutgoing = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: [
        isOutgoing ? const Spacer() : const SizedBox.shrink(),
        Container(
          width: 262.0,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: theme.canvasColor,
            borderRadius: BorderRadius.circular(
              AppConstants.buttonRadius,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    iconPath,
                    color: theme.primaryColor,
                    height: AppConstants.iconSize,
                    width: AppConstants.iconSize,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(title, style: theme.textTheme.labelMedium),
                ],
              ),
              if (date != null)
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 4.0,
                        ),
                        child: Text(
                          date!.chatListTime,
                          textAlign: TextAlign.right,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11.0,
                            color: theme.shadowColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
        isOutgoing ? const SizedBox.shrink() : const Spacer(),
      ],
    );
  }
}
