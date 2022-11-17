import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_advisor_interface/data/models/enums/questions_type.dart';
import 'package:shared_advisor_interface/data/models/enums/sessions_type.dart';

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
        Text(
          type == SessionsTypes.ritual && ritualIdentifier != null
              ? ritualIdentifier!.sessionName
              : type.name,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontSize: 12.0,
              ),
        ),
        if (type == SessionsTypes.ritual && ritualIdentifier != null)
          const SizedBox(
            width: 6.5,
          ),
        if (type == SessionsTypes.ritual && ritualIdentifier != null)
          SvgPicture.asset(
            ritualIdentifier!.iconPath,
            width: 16.0,
            height: 16.0,
            color: color,
          ),
        const SizedBox(
          width: 8,
        ),
        Text(
          //createdAt.toString(),
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
