import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/models/chats/chat_item.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/presentation/common_widgets/list_tile_content_widget.dart';
import 'package:fortunica/presentation/common_widgets/user_avatar.dart';
import 'package:fortunica/presentation/screens/home/tabs/sessions/sessions_cubit.dart';

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
    final bool hasUnansweredQuestions = count > 0;
    return SizedBox(
      height: 62.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              sessionsCubit.goToCustomerProfile(context, question);
            },
            child: UserAvatar(
              avatarUrl: question.clientInformation?.zodiac?.imagePath(context),
              diameter: 48.0,
              isZodiac: true,
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                sessionsCubit.goToCustomerSessions(context, question);
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
                          question.clientName ?? SFortunica.of(context).notSpecifiedFortunica,
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
                          question.attachments?.isEmpty == true ||
                                  hasUnansweredQuestions
                              ? CrossAxisAlignment.start
                              : CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: AppConstants.iconSize,
                            child: hasUnansweredQuestions
                                ? Text(
                                    question.getUnansweredMessage(context),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 14.0,
                                      color: AppColors.promotion,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : ListTileContentWidget(
                                    question: question,
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: hasUnansweredQuestions ? 8.0 : 32.0,
                        ),
                        if (hasUnansweredQuestions)
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
