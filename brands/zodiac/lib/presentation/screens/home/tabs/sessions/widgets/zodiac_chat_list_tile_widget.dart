import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/chats/chat_item_zodiac.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/user_avatar.dart';
import 'package:zodiac/presentation/screens/home/tabs/sessions/sessions_cubit.dart';
import 'package:zodiac/zodiac_extensions.dart';

const String _groupTag = 'groupTag';

class ZodiacChatListTileWidget extends StatelessWidget {
  final ZodiacChatsListItem item;

  const ZodiacChatListTileWidget({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? style = Theme.of(context).textTheme.labelMedium?.copyWith(
          fontSize: 15.0,
          color: Theme.of(context).backgroundColor,
        );
    final textSpan = TextSpan(
      text: SZodiac.of(context).hideChatZodiac,
      style: style,
    );
    final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    tp.layout();

    final SessionsCubit sessionsCubit = context.read<SessionsCubit>();

    return Slidable(
      key: ValueKey(item.hashCode),
      groupTag: _groupTag,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: (tp.width + 32.0) / MediaQuery.of(context).size.width,
        dragDismissible: false,
        children: [
          CustomSlidableAction(
            backgroundColor: AppColors.error,
            onPressed: (_) => sessionsCubit.hideChat(item.id),
            child: Center(
              child: Text(
                SZodiac.of(context).hideChatZodiac,
                style: style,
              ),
            ),
          )
        ],
      ),
      child: Builder(builder: (context) {
        final controller = Slidable.of(context);
        final isClosed =
            controller?.actionPaneType.value == ActionPaneType.none;
        if (!isClosed) {
          controller?.close();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalScreenPadding),
          child: SizedBox(
              height: 62.0,
              child: Row(
                children: [
                  UserAvatar(
                    avatarUrl: item.avatar,
                    diameter: 48.0,
                    badgeColor: item.status?.statusBadgeColor(context),
                    badgeDiameter: 12.0,
                    badgeBorderWidth: 2.0,
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.name ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(fontSize: 15.0),
                              ),
                              Text(
                                item.dateLastUpdate != null
                                    ? DateTime.fromMillisecondsSinceEpoch(
                                            (item.dateLastUpdate! * 1000),
                                            isUtc: true)
                                        .sessionsListTime
                                    : '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontSize: 12.0,
                                      color: Theme.of(context).shadowColor,
                                    ),
                              )
                            ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.lastMessage ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontSize: 14.0,
                                      color: item.isMissed
                                          ? AppColors.error
                                          : Theme.of(context).shadowColor,
                                    ),
                              ),
                            ),
                            item.haveUnreadedMessages
                                ? Container(
                                    height: 18.0,
                                    width: 18.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: item.isMissed
                                          ? Theme.of(context).errorColor
                                          : Theme.of(context).primaryColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        item.unreadCount.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .backgroundColor,
                                            ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(
                                    width: 18.0,
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        const Divider(
                          height: 1.0,
                        )
                      ],
                    ),
                  )
                ],
              )),
        );
      }),
    );
  }
}
