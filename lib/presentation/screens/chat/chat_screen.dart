import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_media_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_widget.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

import 'chat_cubit.dart';
import 'widgets/chat_media_widget.dart';
import 'widgets/chat_recorded_widget.dart';
import 'widgets/chat_recording_widget.dart';
import 'widgets/chat_input_widget.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);
  final ChatItem _question = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(Get.find<ChatsRepository>(), _question),
      child: Builder(builder: (context) {
        final ChatCubit chatCubit = context.read<ChatCubit>();
        final Brand selectedBrand =
            context.select((MainCubit cubit) => cubit.state.currentBrand);
        return Scaffold(
          appBar: ChatConversationAppBar(
            title: _question.clientName ?? '',
            selectedBrand: selectedBrand,
            question: _question,
          ),
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Builder(
                      builder: (context) {
                        final List<ChatItem> items = context
                            .select((ChatCubit cubit) => cubit.state.messages);
                        return ListView.builder(
                          controller: chatCubit.scrollController,
                          reverse: true,
                          itemBuilder: (_, index) =>
                              _ChatItemWidget(items[index]),
                          itemCount: items.length,
                        );
                      },
                    ),
                    const Positioned(
                      bottom: 0.0,
                      right: 0.0,
                      child: _TextCounter(),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Center(
                    child: Container(
                      color: Get.theme.canvasColor,
                      height: 86.0,
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      final bool isRecordingAudio = context.select(
                          (ChatCubit cubit) => cubit.state.isRecordingAudio);
                      final bool isAudioFileSaved = context.select(
                          (ChatCubit cubit) => cubit.state.isAudioFileSaved);
                      final isPlayingRecordedAudio = context.select(
                          (ChatCubit cubit) =>
                              cubit.state.isPlayingRecordedAudio);

                      if (isAudioFileSaved) {
                        return ChatRecordedWidget(
                          isPlaying: isPlayingRecordedAudio,
                          playbackStream: chatCubit.state.playbackStream,
                          onStartPlayPressed: () =>
                              chatCubit.startPlayRecordedAudio(),
                          onPausePlayPressed: () =>
                              chatCubit.pauseRecordedAudio(),
                          onDeletePressed: () =>
                              chatCubit.deletedRecordedAudio(),
                          onSendPressed: () => chatCubit.sendMedia(),
                        );
                      }

                      if (isRecordingAudio) {
                        return ChatRecordingWidget(
                          onClosePressed: () =>
                              chatCubit.cancelRecordingAudio(),
                          onStopRecordPressed: () =>
                              chatCubit.stopRecordingAudio(),
                          recordingStream: chatCubit.state.recordingStream,
                        );
                      } else {
                        return const ChatInputWidget();
                      }
                    },
                  ),
                  Divider(
                    height: 1.0,
                    endIndent: 68.0,
                    color: Get.theme.hintColor,
                  ),
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}

class _ChatItemWidget extends StatelessWidget {
  final ChatItem item;
  const _ChatItemWidget(
    this.item, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item.isMedia) {
      if (item.content != null && item.content!.isNotEmpty) {
        return ChatTextMediaWidget(
          item: item,
        );
      }

      return ChatMediaWidget(
        item: item,
      );
    }

    return ChatTextWidget(
      item: item,
    );
  }
}

class _TextCounter extends StatelessWidget {
  const _TextCounter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final int inputTextLength =
          context.select((ChatCubit cubit) => cubit.state.inputTextLength);
      return Stack(
        children: [
          Container(
            width: 68.0,
            height: 22.0,
            decoration: BoxDecoration(
              color: Get.theme.canvasColor,
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(4.0)),
              border: Border(
                top: BorderSide(color: Get.theme.hintColor),
                right: BorderSide(color: Get.theme.hintColor),
                bottom: BorderSide(color: Get.theme.hintColor),
                left: BorderSide(color: Get.theme.hintColor),
              ),
            ),
            child: Center(
              child: Text(
                '$inputTextLength/${AppConstants.minTextLength}',
                style: Get.textTheme.bodySmall?.copyWith(
                  color: AppColors.online,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: Get.theme.canvasColor,
              width: 68.0,
              height: 1,
            ),
          )
        ],
      );
    });
  }
}
