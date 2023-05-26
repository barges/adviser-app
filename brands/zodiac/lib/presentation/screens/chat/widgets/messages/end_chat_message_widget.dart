import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/zodiac_extensions.dart';

class EndChatMessageWidget extends StatelessWidget {
  final String title;
  final String iconPath;
  final DateTime? date;
  final bool isOutgoing;
  final Duration chatDuration;

  const EndChatMessageWidget({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.date,
    required this.chatDuration,
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
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (chatDuration.inSeconds > 0)
                        Text(
                          _parseChatDuration(chatDuration, context),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11.0,
                            color: theme.shadowColor,
                          ),
                        ),
                      Text(
                        date!.chatListTime,
                        textAlign: TextAlign.right,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11.0,
                          color: theme.shadowColor,
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
        isOutgoing ? const SizedBox.shrink() : const Spacer(),
      ],
    );
  }

  String _parseChatDuration(Duration duration, BuildContext context) {
    String result = '';
    SZodiac s = SZodiac.of(context);

    String hours = '${duration.inHours} ${s.hoursZodiac}';
    String minutes = '${duration.inMinutes.remainder(60)} ${s.minutesZodiac}';
    String seconds = '${duration.inSeconds.remainder(60)} ${s.secondsZodiac}';

    if (duration.inHours > 0) {
      result = '$hours $minutes $seconds, ';
    } else if (duration.inMinutes > 0) {
      result = '$minutes $seconds, ';
    } else {
      result = '$seconds, ';
    }

    return result;
  }
}
