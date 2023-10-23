import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../extensions.dart';
import '../../../../app_constants.dart';
import '../../../../data/models/chats/chat_item.dart';
import '../../../common_widgets/list_tile_content_widget.dart';
import '../../../common_widgets/small_list_tile_badge.dart';
import '../customer_sessions_cubit.dart';

class CustomerSessionListTileWidget extends StatelessWidget {
  final ChatItem question;

  const CustomerSessionListTileWidget({Key? key, required this.question})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomerSessionsCubit customerSessionsCubit =
        context.read<CustomerSessionsCubit>();
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        customerSessionsCubit.goToChat(context, question);
      },
      child: SizedBox(
        height: 62.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44.0,
              height: 44.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.primaryColor,
                  width: 2.0,
                ),
              ),
              child: SvgPicture.asset(
                question.ritualIdentifier?.iconPath ??
                    question.type?.iconPath ??
                    '',
                color: theme.primaryColor,
                height: AppConstants.iconSize,
                width: AppConstants.iconSize,
                fit: BoxFit.scaleDown,
              ),
            ),
            const SizedBox(
              width: 12.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          question.ritualIdentifier?.sessionName(context) ??
                              question.type?.typeName(context) ??
                              '',
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      if (question.createdAt != null ||
                          question.updatedAt != null)
                        Text(
                          question.createdAt?.chatListTime ??
                              question.updatedAt!.chatListTime,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.shadowColor,
                            fontSize: 12.0,
                          ),
                        )
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: question.attachments?.isEmpty == true
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            color: theme.canvasColor,
                            height: AppConstants.iconSize,
                            child: ListTileContentWidget(
                              question: question,
                            ),
                          ),
                        ),
                        Container(
                          color: theme.canvasColor,
                          width: 32.0,
                        ),
                        if (question.isActive) const SmallListTileBadge(),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
