import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_media_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_widget.dart';

import 'chat_cubit.dart';
import 'widgets/chat_media_widget.dart';
import 'widgets/chat_recorded_widget.dart';
import 'widgets/chat_recording_widget.dart';
import 'widgets/chat_textfield.dart';

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
                child: Builder(
                  builder: (context) {
                    final List<ChatItem> items = context
                        .select((ChatCubit cubit) => cubit.state.messages);
                    return Builder(
                      builder: (context) {
                        return ListView.builder(
                          controller: chatCubit.controller,
                          reverse: true,
                          itemBuilder: (_, index) => Builder(
                            builder: (context) {
                              return _ChatItemWidget(items[index]);
                            },
                          ),
                          itemCount: items.length,
                        );
                      },
                    );
                  },
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
                  Builder(builder: (context) {
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
                        onDeletePressed: () => chatCubit.deletedRecordedAudio(),
                        onSendPressed: () => chatCubit.sendMedia(),
                      );
                    }

                    if (isRecordingAudio) {
                      return ChatRecordingWidget(
                        onClosePressed: () => chatCubit.cancelRecordingAudio(),
                        onStopRecordPressed: () =>
                            chatCubit.stopRecordingAudio(),
                        recordingStream: chatCubit.state.recordingStream,
                      );
                    } else {
                      return ChatTextfieldWidget(
                        onRecordPressed: () {
                          chatCubit.startRecordingAudio();
                        },
                      );
                    }
                  }),
                  Divider(
                    height: 1,
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
