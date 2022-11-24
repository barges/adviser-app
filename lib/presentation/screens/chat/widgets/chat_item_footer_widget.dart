import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_type.dart';
import 'package:shared_advisor_interface/data/models/enums/sessions_types.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class ChatItemFooterWidget extends StatelessWidget {
  final ChatItemType type;
  final DateTime createdAt;
  final SessionsTypes? ritualIdentifier;
  final Color color;
  const ChatItemFooterWidget({
    super.key,
    required this.type,
    required this.createdAt,
    required this.color,
    this.ritualIdentifier,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Text(
            type == ChatItemType.ritual && ritualIdentifier != null
                ? ritualIdentifier!.sessionName
                : toBeginningOfSentenceCase(type.name)!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontSize: 12.0,
                ),
          ),
        ),
        if (type == ChatItemType.ritual && ritualIdentifier != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SvgPicture.asset(
              ritualIdentifier!.iconPath,
              width: 16.0,
              height: 16.0,
              color: color,
            ),
          ),
        Text(
          '${createdAt.hour}:${createdAt.minute}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontSize: 12.0,
              ),
        ),
      ],
    );
  }
}
