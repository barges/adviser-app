import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/chats/chat_item_zodiac.dart';
import 'package:zodiac/presentation/common_widgets/user_avatar.dart';
import 'package:zodiac/zodiac_extensions.dart';

class ZodiacChatListTileWidget extends StatelessWidget {
  final ZodiacChatsListItem item;

  const ZodiacChatListTileWidget({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 48.0,
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
                                  .listTime(context)
                              : '',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
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
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
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
                                        color:
                                            Theme.of(context).backgroundColor,
                                      ),
                                ),
                              ),
                            )
                          : const SizedBox(
                              width: 18.0,
                            ),
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
