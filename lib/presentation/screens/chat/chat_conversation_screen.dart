import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/models/question.dart';
import 'package:shared_advisor_interface/domain/repositories/sessions_repository.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';

import 'chat_cubit.dart';
import 'widgets/chat_recorded_widget.dart';
import 'widgets/chat_recording_widget.dart';
import 'widgets/chat_textfield.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);
  final Question _question = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(Get.find<SessionsRepository>(), _question.id),
      child: Builder(builder: (context) {
        final Brand selectedBrand =
            context.select((MainCubit cubit) => cubit.state.currentBrand);
        final ChatCubit chatCubit = context.read<ChatCubit>();
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
              SingleChildScrollView(
                child: Container(),
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
                    final isPlaybackAudio = context.select(
                        (ChatCubit cubit) => cubit.state.isPlaybackAudio);

                    if (isAudioFileSaved) {
                      return ChatRecordedWidget(
                        isPlayback: isPlaybackAudio,
                        playbackStream: chatCubit.state.playbackStream,
                        onStartPlayPressed: () => chatCubit.startPlayAudio(),
                        onPausePlayPressed: () => chatCubit.pausePlayAudio(),
                        onDeletePressed: () => chatCubit.deletedRecordedAudio(),
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
