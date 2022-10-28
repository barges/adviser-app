import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/models/question.dart';
import 'package:shared_advisor_interface/domain/repositories/sessions_repository.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';

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
      create: (_) => ChatCubit(Get.find<SessionsRepository>(), _question),
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
          backgroundColor: const Color(0xffF1F4FB),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Builder(builder: (context) {
                  final messages =
                      context.select((ChatCubit cubit) => cubit.state.messages);
                  return Builder(builder: (context) {
                    return ListView.builder(
                      itemBuilder: (_, index) => Builder(builder: (context) {
                        final audioPath = messages[index].audioPath!;
                        final isPlayingAudioFinished = context.select(
                            (ChatCubit cubit) =>
                                cubit.state.isPlayingAudioFinished);
                        return ChatMediaWidget(
                          isPlayingFinished:
                              (audioPath == chatCubit.state.audioPath)
                                  ? isPlayingAudioFinished
                                  : true,
                          mediaMessage: messages[index],
                          onStartPlayPressed: () {
                            chatCubit.startPlayAudio(audioPath);
                          },
                          onPausePlayPressed: () => chatCubit.pauseAudio(),
                          playbackStream: chatCubit.onMediaProgress,
                        );
                      }),
                      itemCount: messages.length,
                    );
                  });
                }),
              ),
              Stack(
                children: [
                  Container(
                    color: Colors.white,
                    height: 90,
                  ),
                  Builder(builder: (context) {
                    final bool isRecordingAudio = context.select(
                        (ChatCubit cubit) => cubit.state.isRecordingAudio);
                    final bool isAudioFileSaved = context.select(
                        (ChatCubit cubit) => cubit.state.isAudioFileSaved);
                    final isPlaybackAudio = context.select((ChatCubit cubit) =>
                        cubit.state.isPlayingRecordedAudio);

                    if (isAudioFileSaved) {
                      return ChatRecordedWidget(
                        isPlaying: isPlaybackAudio,
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
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
