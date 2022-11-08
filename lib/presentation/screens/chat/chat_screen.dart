import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/models/chats/message.dart';
import 'package:shared_advisor_interface/data/models/chats/question.dart';
import 'package:shared_advisor_interface/data/models/chats/questions_type.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/sessions_type.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_widget.dart';

import 'chat_cubit.dart';
import 'widgets/chat_media_widget.dart';
import 'widgets/chat_recorded_widget.dart';
import 'widgets/chat_recording_widget.dart';
import 'widgets/chat_textfield.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);
  final Question _question = Get.arguments;

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
                    final List<Message> items = context
                        .select((ChatCubit cubit) => cubit.state.messages);
                    return Builder(
                      builder: (context) {
                        return ListView.builder(
                          reverse: true,
                          itemBuilder: (_, index) => Builder(
                            builder: (context) {
                              return getChatWidget(
                                  context, chatCubit, items, index);
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

  Widget getChatWidget(BuildContext context, ChatCubit chatCubit,
      List<Message> items, int index) {
    final Message item = items[index];
    if (item.isQuestion) {
      if (item.isQuestionMedia) {
        final audioUrl = item.audioUrl;
        final isCurrent = audioUrl == chatCubit.state.audioUrl;
        final isPlayingAudio =
            context.select((ChatCubit cubit) => cubit.state.isPlayingAudio);
        final isPlayingAudioFinished = context
            .select((ChatCubit cubit) => cubit.state.isPlayingAudioFinished);

        return ChatMediaWidget(
          isQuestion: item.isQuestion,
          imageUrl: item.imageUrl,
          duration: item.duration ?? const Duration(),
          type: item.data.type!,
          ritualIdentifier: item.data.ritualIdentifier,
          isPlaying: isCurrent && isPlayingAudio,
          isPlayingFinished: isCurrent ? isPlayingAudioFinished : true,
          onStartPlayPressed: () {
            if (audioUrl != null) {
              chatCubit.startPlayAudio(audioUrl);
            }
          },
          onPausePlayPressed: () => chatCubit.pauseAudio(),
          playbackStream: chatCubit.onMediaProgress,
        );
      }

      return ChatTextWidget(
        isQuestion: item.isQuestion,
        type: item.data.type!,
        ritualIdentifier: item.data.ritualIdentifier,
        content: item.data.content,
        createdAt:
            DateTime.tryParse(item.data.createdAt ?? '') ?? DateTime.now(),
      );
    }
    if (item.isAnswer) {
      final audioUrl = item.audioUrl;
      final isCurrent = audioUrl == chatCubit.state.audioUrl;
      final isPlayingAudio =
          context.select((ChatCubit cubit) => cubit.state.isPlayingAudio);
      final isPlayingAudioFinished = context
          .select((ChatCubit cubit) => cubit.state.isPlayingAudioFinished);

      if (item.isAnswerMedia) {
        return ChatMediaWidget(
          isQuestion: false,
          imageUrl: item.imageUrl,
          duration: item.duration ?? const Duration(),
          type: QuestionsType.public,
          ritualIdentifier: SessionsTypes.public,
          isPlaying: isCurrent && isPlayingAudio,
          isPlayingFinished: isCurrent ? isPlayingAudioFinished : true,
          onStartPlayPressed: () {
            if (audioUrl != null) {
              chatCubit.startPlayAudio(audioUrl);
            }
          },
          onPausePlayPressed: () => chatCubit.pauseAudio(),
          playbackStream: chatCubit.onMediaProgress,
        );
      }

      return ChatTextWidget(
        isQuestion: false,
        type: QuestionsType.public,
        ritualIdentifier: SessionsTypes.public,
        content: item.data.content,
        createdAt:
            DateTime.tryParse(item.data.createdAt ?? '') ?? DateTime.now(),
      );
    }

    return const SizedBox.shrink();
  }
}
