import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

import '../../../../fortunica_extensions.dart';
import '../../../../data/models/enums/chat_item_type.dart';
import '../../../../data/models/enums/sessions_types.dart';
import '../../../../generated/assets/assets.gen.dart';
import '../../../../generated/l10n.dart';

class ChatItemFooterWidget extends StatelessWidget {
  final ChatItemType? type;
  final DateTime createdAt;
  final SessionsTypes? ritualIdentifier;
  final Color color;
  final bool isSent;

  const ChatItemFooterWidget({
    super.key,
    required this.type,
    required this.createdAt,
    required this.color,
    this.ritualIdentifier,
    this.isSent = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRitual =
        type == ChatItemType.ritual && ritualIdentifier != null;
    return isSent
        ? Row(
            children: [
              Expanded(
                child: Text(
                  isRitual
                      ? ritualIdentifier?.sessionName(context) ?? ''
                      : toBeginningOfSentenceCase(type?.typeName(context)) ??
                          '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                        fontSize: 14.0,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(
                width: 4.0,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SvgPicture.asset(
                  isRitual ? ritualIdentifier!.iconPath : type?.iconPath ?? '',
                  width: 16.0,
                  height: 16.0,
                  color: color,
                ),
              ),
              Text(
                createdAt.chatListTime,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontSize: 14.0,
                    ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Text(
                  SFortunica.of(context).messageIsNotSentFortunica,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                        fontSize: 12.0,
                      ),
                ),
              ),
              Assets.vectors.attention.svg()
            ],
          );
  }
}
