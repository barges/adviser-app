import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../fortunica_extensions.dart';
import '../../../../../../data/models/chats/chat_item.dart';

class HistoryListGroupHeader extends StatelessWidget {
  final ChatItem? question;

  const HistoryListGroupHeader({Key? key, required this.question})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 8.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              height: 1,
              color: Theme.of(context).shadowColor,
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Text(
              question?.ritualIdentifier?.sessionName(context) ??
                  question?.type?.typeName(context) ??
                  '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.0,
                    color: Theme.of(context).shadowColor,
                  )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: SvgPicture.asset(
              question?.ritualIdentifier != null
                  ? question!.ritualIdentifier!.iconPath
                  : question?.type?.iconPath ?? '',
              width: 16.0,
              height: 16.0,
              color: Theme.of(context).shadowColor,
            ),
          ),
          Text(question?.createdAt?.historyListTime(context) ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.0,
                    color: Theme.of(context).shadowColor,
                  )),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Divider(height: 1, color: Theme.of(context).shadowColor),
          ),
        ],
      ),
    );
  }
}
