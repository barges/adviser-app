import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/widgets/list_tile/list_tile_content_widget.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class PrivateChatsListTileWidget extends StatelessWidget {
  final ChatItem question;

  const PrivateChatsListTileWidget({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final SessionsCubit sessionsCubit = context.read<SessionsCubit>();
    final int count = question.unansweredCount ?? 0;
    return SizedBox(
      height: 62.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              sessionsCubit.goToCustomerProfile(question);
            },
            child: SizedBox(
              width: 48.0,
              height: 48.0,
              child: SvgPicture.asset(
                question.clientInformation?.zodiac?.imagePath(context) ?? '',
              ),
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                sessionsCubit.goToCustomerSessions(question);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          question.clientName ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      Text(
                        question.updatedAt?.chatListTime ??
                            DateTime.now().chatListTime,
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
                      crossAxisAlignment:
                          question.attachments?.isEmpty == true || count > 0
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: AppConstants.iconSize,
                            child: count > 0
                                ? Text(
                                    S.of(context).youHaveAnActiveSession,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 14.0,
                                      color: AppColors.promotion,
                                    ),
                                  )
                                : ListTileContentWidget(
                                    question: question,
                                  ),
                          ),
                        ),
                        const SizedBox(
                          width: 32.0,
                        ),
                        if (count > 0)
                          _PrivateBadge(
                            count: count,
                          ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivateBadge extends StatelessWidget {
  final int count;

  const _PrivateBadge({
    Key? key,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double diameter = 18.0;
    return Container(
      alignment: Alignment.center,
      height: diameter,
      width: diameter,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.promotion,
      ),
      child: Text(
        count.toString(),
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Theme.of(context).canvasColor,
            ),
      ),
    );
  }
}
