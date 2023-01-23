import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_type.dart';
import 'package:shared_advisor_interface/data/models/enums/sessions_types.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

class ChatItemFooterWidget extends StatelessWidget {
  final ChatItemType? type;
  final DateTime createdAt;
  final SessionsTypes? ritualIdentifier;
  final Color color;
  final bool isSent;
  final bool isHistoryQuestion;
  final bool isHistoryAnswer;
  final bool isHistoryAnswerInSameDay;
  const ChatItemFooterWidget({
    super.key,
    required this.type,
    required this.createdAt,
    required this.color,
    this.ritualIdentifier,
    this.isSent = true,
    this.isHistoryQuestion = false,
    this.isHistoryAnswer = false,
    this.isHistoryAnswerInSameDay = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRitual =
        type == ChatItemType.ritual && ritualIdentifier != null;
    return isSent
        ? Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Text(
                  isRitual
                      ? ritualIdentifier?.sessionName(context) ?? ''
                      : toBeginningOfSentenceCase(type?.typeName(context)) ??
                          '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                        fontSize: 12.0,
                      ),
                ),
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
                isHistoryQuestion
                    ? createdAt.historyCardQuestionTime
                    : isHistoryAnswer
                        ? createdAt
                            .historyCardAnswerTime(isHistoryAnswerInSameDay)
                        : createdAt.chatListTime,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontSize: 12.0,
                    ),
              ),
            ],
          )
        : Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Text(
                  S.of(context).messageIsNotSent,
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
