import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/chats/rirual_card_info.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_type.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_input_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/ritual_info_card_widget.dart';

class ActiveChatMessagesWidget extends StatelessWidget {
  final List<ChatItem> activeMessages;

  const ActiveChatMessagesWidget({
    super.key,
    required this.activeMessages,
  });

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final RitualCardInfo? ritualCardInfo =
        context.select((ChatCubit cubit) => cubit.state.ritualCardInfo);
    final bool refreshEnabled =
        context.select((ChatCubit cubit) => cubit.state.refreshEnabled);

    final double bottomTextAreaHeight =
        context.select((ChatCubit cubit) => cubit.state.bottomTextAreaHeight);

    final double textInputHeight =
        context.select((ChatCubit cubit) => cubit.state.textInputHeight);

    final double bottomPadding =
        (MediaQueryData.fromWindow(window).viewPadding.bottom > 0.0
            ? MediaQueryData.fromWindow(window).viewPadding.bottom
            : 24.0) +
                bottomTextAreaHeight +
                grabbingHeight +
                textInputHeight +
                textCounterHeight;

    return Column(
      children: [
        Expanded(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: RefreshIndicator(
              onRefresh: chatCubit.refreshChatInfo,
              notificationPredicate: (_) => refreshEnabled,
              child: SingleChildScrollView(
                controller: chatCubit.activeMessagesScrollController,
                physics: const AlwaysScrollableScrollPhysics()
                    .applyTo(const ClampingScrollPhysics()),
                padding: EdgeInsets.fromLTRB(12.0, 16.0, 12.0, bottomPadding),
                child: Builder(builder: (context) {
                  final List<Widget> widgets = [];

                  if (activeMessages.last.type == ChatItemType.ritual &&
                      ritualCardInfo != null) {
                    widgets.add(
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16.0,
                        ),
                        child: RitualInfoCardWidget(
                          ritualCardInfo: ritualCardInfo,
                        ),
                      ),
                    );
                  }

                  for (int i = 0; i < activeMessages.length; i++) {
                    final ChatItem item = activeMessages[i];
                    final GlobalKey key = GlobalKey();

                    ///TODO: Maybe we need add global key to chat item only if isAudio!
                    if (i == activeMessages.length - 1 && !item.isAnswer) {
                      chatCubit.questionGlobalKey = key;
                    }
                    widgets.add(
                      ChatItemWidget(
                        key: key,
                        item: item,
                      ),
                    );
                    if (i < activeMessages.length - 1) {
                      widgets.add(
                        const SizedBox(
                          height: 8.0,
                        ),
                      );
                    }
                  }

                  return Column(
                    children: widgets,
                  );
                }),
              ),
            ),
          ),
        ),
        if (chatCubit.isPublicChat())
          Builder(
            builder: (context) {
              final ChatItemStatusType? questionStatus = context
                  .select((ChatCubit cubit) => cubit.state.questionStatus);
              if (questionStatus == ChatItemStatusType.open) {
                return const SizedBox(
                  height: 72.0,
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
      ],
    );
  }
}
