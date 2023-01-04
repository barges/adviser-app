import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/list_tile_content_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/small_list_tile_badge.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_sessions/customer_sessions_cubit.dart';

class CustomerSessionListTileWidget extends StatelessWidget {
  const CustomerSessionListTileWidget({Key? key, required this.question})
      : super(key: key);

  final ChatItem question;

  @override
  Widget build(BuildContext context) {
    final CustomerSessionsCubit customerSessionsCubit =
        context.read<CustomerSessionsCubit>();
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        customerSessionsCubit.goToChat(question);
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
                      Text(
                        question.createdAt?.chatListTime ??
                            question.updatedAt?.chatListTime ??
                            DateTime.now().toUtc().chatListTime,
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
