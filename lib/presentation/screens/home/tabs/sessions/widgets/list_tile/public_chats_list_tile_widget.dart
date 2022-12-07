import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_type.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/list_tile_content_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_cubit.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class PublicChatsListTileWidget extends StatelessWidget {
  final ChatItem question;
  final bool needCheckTakenStatus;

  const PublicChatsListTileWidget({
    Key? key,
    required this.question,
    this.needCheckTakenStatus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final SessionsCubit sessionsCubit = context.read<SessionsCubit>();
    final bool isTaken =
        needCheckTakenStatus && question.status == ChatItemStatusType.taken;
    return Opacity(
      opacity: needCheckTakenStatus
          ? isTaken
              ? 1.0
              : 0.4
          : 1.0,
      child: SizedBox(
        height: 62.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                if (needCheckTakenStatus) {
                  if (isTaken) {
                    sessionsCubit.goToCustomerProfile(question);
                  }
                } else {
                  sessionsCubit.goToCustomerProfile(question);
                }
              },
              child: SizedBox(
                width: 48.0,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    SvgPicture.asset(
                      question.clientInformation?.zodiac?.imagePath(context) ??
                          '',
                      height: 48.0,
                    ),
                    question.type == ChatItemType.public
                        ? Container(
                            height: 20.0,
                            width: 20.0,
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              color: theme.canvasColor,
                              shape: BoxShape.circle,
                            ),
                            child: Assets.vectors.sessionsTypes.public.svg())
                        : const SizedBox.shrink()
                  ],
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
                  if (needCheckTakenStatus) {
                    if (isTaken) {
                      sessionsCubit.goToChat(question);
                    }
                  } else {
                    sessionsCubit.goToChat(question);
                  }
                },
                child: Column(
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
                          question.createdAt?.chatListTime ??
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
                            question.attachments?.isNotEmpty == true
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: AppConstants.iconSize,
                              child: ListTileContentWidget(
                                question: question,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 32.0,
                          ),
                          needCheckTakenStatus
                              ? isTaken
                                  ? const SizedBox.shrink()
                                  : const _PublicBadge()
                              : const _PublicBadge(),
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
      ),
    );
  }
}

class _PublicBadge extends StatelessWidget {
  const _PublicBadge({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double diameter = 8.0;
    return Container(
      alignment: Alignment.center,
      height: diameter,
      width: diameter,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.promotion,
      ),
    );
  }
}
