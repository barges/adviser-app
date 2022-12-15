import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/data/models/chats/history.dart';
import 'package:shared_advisor_interface/extensions.dart';

class HistoryListGroupHeader extends StatelessWidget {
  final History? headerItem;
  const HistoryListGroupHeader({Key? key, required this.headerItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 8.0),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              height: 1,
            ),
          ),
          Text(
              headerItem?.question?.ritualIdentifier?.sessionName(context) ??
                  headerItem?.question?.type?.typeName(context) ??
                  '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.0,
                    color: Theme.of(context).shadowColor,
                  )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: SvgPicture.asset(
              headerItem?.question?.ritualIdentifier != null
                  ? headerItem!.question!.ritualIdentifier!.iconPath
                  : headerItem?.question?.type?.iconPath ?? '',
              width: 16.0,
              height: 16.0,
              color: Theme.of(context).shadowColor,
            ),
          ),
          Text(headerItem?.question?.createdAt?.historyListTime(context) ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.0,
                    color: Theme.of(context).shadowColor,
                  )),
          const Expanded(
            child: Divider(
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
